
module SubdomainFinder
  module Helper
    module ScannerCaller
      class Joomlavs

        def initialize
        end

        def run_joomlavs target

          @target = target
          @params = "-u #{@target} -a --follow-redirection --no-colour --threads 50"

          @output_path = "#{REPORTS_PATH}/joomlavs/#{target}.txt"
          @main_command = "joomlavs #{@params} > #{@output_path}"
          self.run
        end

        def run
          system(@main_command)
        end
      end
    end
  end
end

