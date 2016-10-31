module SubdomainFinder
  module Tools
    class ToolsPublic
      def initialize main_command,param
        self.check_tool main_command,param
      end
      def check_tool main_command,param
        Open3.popen3(main_command) do |stdin, stdout, stderr, thread|
          exit_status = thread.value.exitstatus
          if exit_status != 127
            self.run main_command,param
          else
            @paint.danger("Command not found!")
          end
        end
      end
      def run main_command,param
        command = "#{main_command} #{param}"

        Open3.popen3(command) { |stdin, stdout, stderr, thread|
          $results = stdout.read
        }
      end
    end
  end
end