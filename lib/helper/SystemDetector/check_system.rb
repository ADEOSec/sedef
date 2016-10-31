
module SubdomainFinder
  module Helper
    module SystemDetector
      class CheckSystem

        def initialize
          @joomla_check = SubdomainFinder::Helper::SystemDetector::Joomla.new
          @wordpress_check = SubdomainFinder::Helper::SystemDetector::WordPress.new

        end

        def check_wp domain
            directory_name = "wpscan"
            Dir.mkdir("#{REPORTS_PATH}/#{directory_name}") unless File.exists?("#{REPORTS_PATH}/#{directory_name}")

            t1 = Thread.new do SubdomainFinder::Helper::ScannerCaller::WpScan.new.run_wpscan domain end
            t1.join

        end

        def check_joomla domain

            directory_name = "joomlavs"
            Dir.mkdir("#{REPORTS_PATH}/#{directory_name}") unless File.exists?("#{REPORTS_PATH}/#{directory_name}")

            t1 = Thread.new do SubdomainFinder::Helper::ScannerCaller::Joomlavs.new.run_joomlavs domain end
            t1.join

        end
      end
    end
  end
end

