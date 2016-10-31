require 'colorize'
module SubdomainFinder
  module Helper
    class Paint
      def initialize
      end

      def boolean_message message
        message ? "✔".colorize(:green) : "✗".colorize(:red)
      end

      def success message
        puts message.colorize(:green)
      end

      def warning message
        puts message.colorize(:yellow)
      end

      def info message
        puts message.colorize(:blue)
      end

      def danger message
        puts message.colorize(:red)
      end

    end
  end
end
