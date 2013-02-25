require 'pathname'
require 'rbconfig'
require 'observr/version'

# Agile development tool that monitors a directory recursively, and triggers a
# user defined action whenever an observed file is modified. Its most typical
# use is continuous testing.
#
# See README for more details
#
# @example
#
#     # on command line, from project's root dir
#     $ observr path/to/script
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
module Observr
  begin
    require 'fsevent'
    HAVE_FSE = true
  rescue LoadError, RuntimeError
    HAVE_FSE = false
  end

  begin
    require 'rev'
    HAVE_REV = true
  rescue LoadError, RuntimeError
    HAVE_REV = false
  end

  autoload :Script,     'observr/script'
  autoload :Controller, 'observr/controller'

  module EventHandler
    autoload :Base,     'observr/event_handlers/base'
    autoload :Portable, 'observr/event_handlers/portable'
    autoload :Unix,     'observr/event_handlers/unix'      if ::Observr::HAVE_REV
    autoload :Darwin,   'observr/event_handlers/darwin'    if ::Observr::HAVE_FSE
  end

  class << self
    attr_accessor :options
    attr_accessor :handler

    # @deprecated
    def version #:nodoc:
      Observr::VERSION
    end

    # Options proxy.
    #
    # Currently supported options:
    #
    # * debug[Boolean] Debugging state. More verbose.
    #
    # @example
    #
    #     Observr.options.debug #=> false
    #     Observr.options.debug = true
    #
    # @return [Struct]
    #   options proxy.
    #
    def options
      @options ||= Struct.new(:debug).new
      @options.debug ||= false
      @options
    end

    # Outputs formatted debug statement to stdout, only if `::options.debug` is true
    #
    # @example
    #
    #     Observr.options.debug = true
    #     Observr.debug('im in ur codes, notifayinin u')
    #
    #     #outputs: "[observr debug] im in ur codes, notifayinin u"
    #
    # @param [String] message
    #   debug message to print
    #
    # @return [nil]
    #
    def debug(msg)
      puts "[observr debug] #{msg}" if options.debug
    end

    # Detect current OS and return appropriate handler.
    #
    # @example
    #
    #     Config::CONFIG['host_os'] #=> 'linux-gnu'
    #     Observr.handler #=> Observr::EventHandler::Unix
    #
    #     Config::CONFIG['host_os'] #=> 'cygwin'
    #     Observr.handler #=> Observr::EventHandler::Portable
    #
    #     ENV['HANDLER'] #=> 'unix'
    #     Observr.handler #=> Observr::EventHandler::Unix
    #
    #     ENV['HANDLER'] #=> 'portable'
    #     Observr.handler #=> Observr::EventHandler::Portable
    #
    # @return [Class]
    #   handler class for current architecture
    #
    def handler
      @handler ||=
        case ENV['HANDLER'] || RbConfig::CONFIG['host_os']
          when /darwin|mach|osx|fsevents?/i
            if Observr::HAVE_FSE
              Observr::EventHandler::Darwin
            else
              Observr.debug "fsevent not found. `gem install ruby-fsevent` to get evented handler"
              Observr::EventHandler::Portable
            end
          when /sunos|solaris|bsd|linux|unix/i
            if Observr::HAVE_REV
              Observr::EventHandler::Unix
            else
              Observr.debug "rev not found. `gem install rev` to get evented handler"
              Observr::EventHandler::Portable
            end
          when /mswin|windows|cygwin/i
            Observr::EventHandler::Portable
          else
            Observr::EventHandler::Portable
        end
    end
  end
end
