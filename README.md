# RailsTestServing

Tired of waiting 10 seconds before your tests run? `RailsTestServing` can make them run almost instantly.

## Usage

1.  Install the gem:

        gem install Roman2K-rails-test-serving -s http://gems.github.com

2.  Insert the following lines at the very top of `test/test_helper.rb`:

        require 'rubygems'
        require 'rails_test_serving'
        RailsTestServing.boot

3.  Append the following line to `~/.bash_profile`:

        export RUBYLIB=".:test:$RUBYLIB"

    If you get loading errors during the next steps:
    * Move the `RUBYLIB` line from `~/.bash_profile` to `~/.bash_login` instead.
    * If you are using TextMate, you may try to apply <del>this (hopefully temporary) fix</del>.

4.  Start the server:

        cd <project-dir>
        ruby test/test_helper.rb --serve

5.  Run tests as you usually do:

        ruby test/unit/account_test.rb
        ruby test/unit/account_test.rb -n /balance/

    As a consequence, they work in RubyMate too (⌘R in TextMate).

6.  Have a lot a models and/or mixins? You can reduce reloading time to almost nothing by using `RailsTestServing` in combination with [RailsDevelopmentBoost](https://github.com/Roman2K/rails-dev-boost). Since was originally intended to speed up web-browsing in development mode, be sure to read the note in the `README` for how to enable it in test mode.

**Note:** if the server is not started, tests fall back to running the usual way.

## Options

An option hash can be specified for `RailsTestServing` to use, by defining `$test_server_options` right before `require 'rails_test_serving'`. It must be a hash with symbol keys. Currently available options are:

*   `reload`: An array of regular expressions (or any object responding to `===`) matching the name of the files that should be forced to reload right after the regular constant cleanup. Note that the constants these files have defined are kept around before being re-`require`'d.

Example `test_helper.rb` head:

    require 'rubygems'

    $test_server_options = { :reload => [/blueprint/] }
    require 'rails_test_serving'
    RailsTestServing.boot

    # ...remainder here...

When running tests from the command line, you can bypass the server, forcing tests to be run locally, by passing the `--local` flag. For example:

    ruby test/unit/account_test.rb --local

## Caveats

*   Tested working with Rails 2.1.2 up to 2.2.2. Compatibility with versions of Rails out of that range is not guaranteed.
*   There might exist some quirks: search for "TODO" in the source. I can bear them but contributions are welcome.
*   Some unit tests are left to be written.

## Credits

Code:

*   Roman Le Négrate
*   [Jack Chen](http://github.com/chendo) (chendo)

Feedback:

*   Justin Ko
*   [Dr Nic Williams](http://drnicwilliams.com)
