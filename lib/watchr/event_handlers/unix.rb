module Watchr
  module EventHandler
    class Unix
      include Base

      # Used by Rev. Wraps a monitored path, and Rev::Loop will call its
      # callback on file events.
      class SingleFileWatcher < Rev::StatWatcher #:nodoc:
        class << self
          # Stores a reference back to handler so we can call its #nofity
          # method with file event info
          attr_accessor :handler
        end

        # Callback. Called on file change event
        # Delegates to Controller#update, passing in path and event type
        def on_change
          self.class.handler.notify(path, :changed)
        end
      end

      def initialize
        SingleFileWatcher.handler = self
        @loop = Rev::Loop.default
      end

      # Enters listening loop.
      #
      # Will block control flow until application is explicitly stopped/killed.
      #
      def listen(monitored_paths)
        @monitored_paths = monitored_paths
        attach
        @loop.run
      end

      # Rebuilds file bindings.
      #
      # will detach all current bindings, and reattach the <tt>monitored_paths</tt>
      #
      def refresh(monitored_paths)
        @monitored_paths = monitored_paths
        detach
        attach
      end

      private

      # Binds all <tt>monitored_paths</tt> to the listening loop.
      def attach
        @monitored_paths.each {|path| SingleFileWatcher.new(path.to_s).attach(@loop) }
      end

      # Unbinds all paths currently attached to listening loop.
      def detach
        @loop.watchers.each {|watcher| watcher.detach }
      end
    end
  end
end