module SubdomainFinder
  module Tools
    class TheHarvester
      def initialize target
        @target = target
        @main_command = "theharvester"
        @param = " -d #{@target} -l 500 -b bing"
        @tools_public = SubdomainFinder::Tools::ToolsPublic.new @main_command,@param

        self.response_parse
      end
      def response_parse
        @subdomains = $results.scan(/[0-9.]+:[a-zA-Z.0-9]+\n/).map{ |site| site.split(':').last.delete!("\n") }
      end
      def get_subdomains
        @subdomains
      end
    end
  end
end
