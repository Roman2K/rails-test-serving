# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails-test-serving}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Le N\303\251grate"]
  s.date = %q{2009-02-08}
  s.description = %q{Makes unit tests of a Rails application run instantly}
  s.email = %q{roman.lenegrate@gmail.com}
  s.extra_rdoc_files = ["lib/rails_test_serving.rb", "LICENSE", "README.rdoc"]
  s.files = ["lib/rails_test_serving.rb", "LICENSE", "Rakefile", "README.rdoc", "test/rails_test_serving_test.rb", "Manifest", "rails-test-serving.gemspec", "test/rails_test_serving/bootstrap_test.rb", "test/rails_test_serving/cleaner_test.rb", "test/rails_test_serving/client_test.rb", "test/rails_test_serving/constant_management_test.rb", "test/rails_test_serving/server_test.rb", "test/rails_test_serving/utilities_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{https://github.com/Roman2K/rails-test-serving}
  s.rdoc_options = ["--main", "README.mdown", "--inline-source", "--line-numbers", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails-test-serving}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Makes unit tests of a Rails application run instantly}
  s.test_files = ["test/rails_test_serving/bootstrap_test.rb", "test/rails_test_serving/cleaner_test.rb", "test/rails_test_serving/client_test.rb", "test/rails_test_serving/constant_management_test.rb", "test/rails_test_serving/server_test.rb", "test/rails_test_serving/utilities_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
