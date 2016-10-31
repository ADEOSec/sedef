require 'open3'
module SubdomainFinder
  module Tools
    class Fierce
      def initialize target
        @target = target
        @main_command = "fierce"
        @param = "-dns #{@target} -threads 16"
        @tools_public = SubdomainFinder::Tools::ToolsPublic.new @main_command,@param
        self.response_parse

      end

      def response_parse
        @subdomains = $results.scan(/(?:[0-9]{1,3}\.){3}[0-9]{1,3}\s+[a-z.A-Z-]+\n/).map { |site| site.split("\t").last.delete!("\n") }
        self.get_subdomains
      end

      def get_subdomains
        @subdomains
      end

    end
  end
end
