require 'test/unit'
require 'mocha'
Mocha::Configuration.prevent :stubbing_non_existent_method
Mocha::Configuration.warn_when :stubbing_method_unnecessarily

require 'rails_test_serving'

class RailsTestServingTest < Test::Unit::TestCase
  include RailsTestServing
  
# class

  def test_boot
    argv = []
    Client.expects(:run_tests)
    RailsTestServing.boot(argv)
    
    argv = ['--local']
    Client.expects(:run_tests).never
    RailsTestServing.boot(argv)
    assert_equal [], argv
    
    argv = ["--serve"]
    Server.expects(:start)
    RailsTestServing.boot(argv)
    assert_equal [], argv
  end
end

class RailsTestServing::ConstantManagementTest < Test::Unit::TestCase
  include RailsTestServing::ConstantManagement
  NS = self
  
  Foo = :foo
  NamedFoo = Module.new
  Namespace = Module.new
  
  class A; end
  class B < A; end
  class C < B; end
  
  def test_legit
    assert legit?(NamedFoo)
    
    assert !legit?("Inexistent")
    
    fake = stub(:to_s => NamedFoo.to_s)
    assert_equal NamedFoo.to_s, "#{fake}"   # sanity check
    assert !legit?(fake)
  end
  
  def test_constantize
    assert_equal :foo, constantize("#{NS}::Foo")
    assert_equal nil,  constantize("#{NS}::Bar")
  end
  
  def test_constantize!
    assert_equal :foo, constantize!("#{NS}::Foo")
    assert_raise(NameError) { constantize!("#{NS}::Bar") }
  end
  
  def test_remove_constants
    mod_A = Module.new
    Namespace.const_set(:A, mod_A)
    assert eval("defined? #{NS}::Namespace::A")  # sanity check
    
    removed = remove_constants("#{NS}::Namespace::A")
    assert_equal [mod_A], removed
    assert !eval("defined? #{NS}::Namespace::A")
    
    removed = remove_constants("#{NS}::Namespace::A")
    assert_equal [nil], removed
  end
  
  def test_subclasses_of
    assert_equal [C, B],  subclasses_of(A)
    assert_equal [C],     subclasses_of(B)
    assert_equal [],      subclasses_of(C)
    
    self.stubs(:legit?).with(B).returns true
    self.stubs(:legit?).with(C).returns false
    assert_equal [B], subclasses_of(A, :legit => true)
  end
end

class RailsTestServing::ClientTest < Test::Unit::TestCase
  C = RailsTestServing::Client
  
  def test_run_tests
    C.expects(:run_tests!)
    C.run_tests
    
    C.disable do
      C.expects(:run_tests!).never
      C.run_tests
    end
  end
end

class RailsTestServing::ServerTest < Test::Unit::TestCase
  
# private

  def test_perform_run
    server = stub_server
    file, argv = "test.rb", ["-n", "/pat/"]
    
    server.stubs(:sanitize_arguments!)
    Benchmark.stubs(:realtime).yields.returns 1
    
    server.expects(:log).with(">> test.rb -n /pat/").once
    server.stubs(:capture_test_result).with(file, argv).returns "result"
    server.expects(:log).with(" (1000 ms)\n").once
  
    result = server.instance_eval { perform_run(file, argv) }
    assert_equal "result", result
  end
  
  def test_sanitize_arguments
    server = stub_server
    sanitize = lambda { |*args| server.instance_eval { sanitize_arguments! *args } }
    
    # valid
    file, argv = "test.rb", ["--name=test_create"]
    sanitize.call file, argv
    
    assert_equal "test.rb", file
    assert_equal ["--name=test_create"], argv
    
    # TextMate junk
    junk = "[test_create,", "nil,", "nil]"
    
    # a)  at the beginning
    file, argv = "test.rb", junk + ["foo"]
    sanitize.call file, argv
    
    assert_equal "test.rb", file
    assert_equal ["foo"], argv
    
    # b)  in between normal arguments
    file, argv = "test.rb", ["foo"] + junk + ["bar"]
    sanitize.call file, argv
    
    assert_equal "test.rb", file
    assert_equal ["foo", "bar"], argv
    
    # invalid arguments
    assert_raise RailsTestServing::InvalidArgumentPattern do
      sanitize.call "-e", ["code"]
    end
  end

  def test_shorten_path
    server = stub_server
    Dir.stubs(:pwd).returns '/base'
    
    assert_equal 'test.rb', server.instance_eval { shorten_path 'test.rb' }
    assert_equal 'test.rb', server.instance_eval { shorten_path '/base/test.rb' }
    assert_equal '/other-base/test.rb', server.instance_eval { shorten_path '/other-base/test.rb' }
    assert_equal '/other-base/test.rb', server.instance_eval { shorten_path '/other-base/././test.rb' }
  end

  def test_capture_test_result
    server = stub_server
    cleaner = server.instance_variable_set(:@cleaner, stub)
    
    cleaner.stubs(:clean_up_around).yields
    server.stubs(:capture_standard_stream).with('err').yields.returns "stderr"
    server.stubs(:capture_standard_stream).with('out').yields.returns "stdout"
    server.stubs(:capture_testrunner_result).yields.returns "result"
    server.stubs(:fix_objectspace_collector).yields
    
    server.stubs(:load).with("file")
    Test::Unit::AutoRunner.expects(:run).with(false, nil, "argv")
    
    result = server.instance_eval { capture_test_result("file", "argv") }
    assert_equal "stderrstdoutresult", result
  end
  
  def test_capture_standard_stream
    server = stub_server
    assert_equal STDOUT, $stdout  # sanity check
    
    captured = server.instance_eval { capture_standard_stream('out') { print "test" } }
    
    assert_equal "test", captured
    assert_equal STDOUT, $stdout
  end
  
  def test_capture_testrunner_result
    server = stub_server
    
    captured = server.instance_eval do
      capture_testrunner_result { Thread.current["test_runner_io"].print "test" }
    end
    
    assert_equal "test", captured
  end
  
private

  S = RailsTestServing::Server
  
  def stub_server
    S.any_instance.stubs(:enable_dependency_tracking)
    S.any_instance.stubs(:start_cleaner)
    S.any_instance.stubs(:load_framework)
    S.any_instance.stubs(:log)
    S.new
  end
end
