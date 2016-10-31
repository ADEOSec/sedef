module SubdomainFinder
  module Helper
    module ScannerCaller
      class WpScan
        def initialize
        end

        def run_wpscan target
          @target = target
          @params = "--url #{@target} --threads 100 --no-color --batch --follow-redirection"

          @output_path = "#{REPORTS_PATH}/wpscan/#{target}.txt"
          @main_command = "wpscan #{@params} > #{@output_path}"
          self.run
        end

        def run
          command = "#{@main_command}"
          system(command)

        end
      end
    end
  end
end
