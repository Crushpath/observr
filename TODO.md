Features
--------

* observr -e ( `$ observr -e "watch('foo.gemspec') { system('gem build foo.gemspec') }"` )
* observr --auto
* observr --fetch

* enable ability to watch dirs
  * requires new handler(s)
  * will allow recognizing `:added` events

* allow setting latency

Bugs
----

* sometimes an action is fired without a file being saved
  * buffer flushing issue?
  * libev issue?
  * probably fixed with event type handling update, which ignores atime
    updates by defaults

* when a file is saved twice quickly, subsequent events are ignored.
  * seems like rev/libev drops the file watch

Other
-----

* add tests for executable
* memory profiling / benchmarks

