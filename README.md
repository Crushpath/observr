Summary
-------

Agile development tool that monitors a directory tree, and triggers a user
defined action whenever an observed file is modified. Its most typical use is
continuous testing, and as such it is a more flexible alternative to autotest.

Features
--------

observr is:

* Simple to use
* Highly flexible
* Evented               ( Listens for filesystem events with native c libs )
* Portable              ( Linux, \*BSD, OSX, Solaris, Windows )
* Fast                  ( Immediately reacts to file changes )

Most importantly it allows running tests in an environment that is **agnostic** to:

* Web frameworks        ( rails, merb, sinatra, camping, invisible, ... )
* Test frameworks       ( test/unit, minitest, rspec, test/spec, expectations, ... )
* Ruby interpreters     ( ruby1.8, ruby1.9, MRI, JRuby, Rubinius, ... )
* Package frameworks    ( rubygems, rip, ... )

Usage
-----

On the command line,

    $ observr path/to/script.file

will monitor files in the current directory tree, and react to events on those
files in accordance with the script.

Scripts
-------

The script contains a set of simple rules that map observed files to an action.
Its DSL is a single method: `watch(pattern, &action)`

    watch( 'a regexp pattern matching paths to observe' )  {|match_data_object| command_to_run }

So for example,

    watch( 'test/test_.*\.rb' )  {|md| system("ruby #{md[0]}") }

will match any test file and run it whenever it is saved.

A continuous testing script for a basic project could be

    watch( 'test/test_.*\.rb' )  {|md| system("ruby #{md[0]}") }
    watch( 'lib/(.*)\.rb' )      {|md| system("ruby test/test_#{md[1]}.rb") }

which, in addition to running any saved test file as above, will also run a
lib file's associated test. This mimics the equivalent autotest behaviour.

It's easy to see why observr is so flexible, since the whole command is custom.
The above actions could just as easily call "jruby", "ruby --rubygems", "ruby
-Ilib", "specrb", "rbx", ... or any combination of these. For the sake of
comparison, autotest runs with:

    $ /usr/bin/ruby1.8 -I.:lib:test -rubygems -e "%w[test/unit test/test_helper.rb test/test_observr.rb].each { |f| require f }"

locking the environment into ruby1.8, rubygems and test/unit for all tests.

And remember the scripts are pure ruby, so feel free to add methods,
`Signal#trap` calls, etc. Updates to script files are picked up on the fly (no
need to restart observr) so experimenting is painless.

The [wiki][5] has more details and examples.  You might also want to take a
look at observr's own scripts, [specs.observr][1], [docs.observr][2] and
[gem.observr][3], to get you started.

Install
-------

    gem install observr

If you're on Linux/BSD and have the [rev][4] gem installed, Observr will detect
it and use it automatically. This will make Observr evented.

    gem install rev

You can get the same evented behaviour on OS X by installing
[ruby-fsevent][10].

    gem install ruby-fsevent

See Also
--------

* [redgreen][6]:   Standalone redgreen eye candy for test results, ala autotest.
* [phocus][7]:     Run focused tests when running the whole file/suite is unnecessary.
* [autoobservr][8]: Provides some autotest-like behavior for observr
* [nestor][9]:     Continuous testing server for Rails

Links
-----

* code:  <http://github.com/kevinburke/observr>
* docs:  <http://yardoc.org/docs/mynyml-observr/file:README.rdoc>
* wiki:  <http://wiki.github.com/mynyml/observr>
* bugs:  <http://github.com/kevinburke/observr/issues>




[1]:  http://github.com/kevinburke/observr/blob/master/specs.observr
[2]:  http://github.com/kevinburke/observr/blob/master/docs.observr
[3]:  http://github.com/kevinburke/observr/blob/master/gem.observr
[4]:  http://rev.rubyforge.org/rdoc/
[5]:  http://wiki.github.com/mynyml/observr
[6]:  http://github.com/mynyml/redgreen
[7]:  http://github.com/mynyml/phocus
[8]:  http://github.com/viking/autoobservr
[9]:  http://github.com/francois/nestor
[10]: http://github.com/sandro/ruby-fsevent

