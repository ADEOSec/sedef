module SubdomainFinder
  module Helper
    module ScannerCaller
      class Shodan
        def initialize
          directory_name = "shodan"
          Dir.mkdir("#{MAIN_PATH}/reports/#{MAIN_DOMAIN}/#{directory_name}") unless File.exists?("#{MAIN_PATH}/reports/#{MAIN_DOMAIN}/#{directory_name}")

        end
        def get_info target
          @target = target
          ip = Resolv.getaddress(@target)
          @main_host = "https://www.shodan.io/host/#{ip}"

          self.send_request
        end

        def send_request
          opt  = { ssl_verifyhost:0 , followlocation: true}
          res = Typhoeus::Request.new(@main_host,opt)
          res = res.run
          File.open("#{REPORTS_PATH}/shodan/#{@target}.html", 'w'){|f| f.write(res.body)}
        end

      end
    end
  end
end
