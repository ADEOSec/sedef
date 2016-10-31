module SubdomainFinder
  module WebServices
    class Wolframalfa
      def initialize(target)
        @paint = SubdomainFinder::Helper::Paint.new
        @target_host = target
        @subdomains = []

        unless File.exist?(File.join(MAIN_PATH, 'config.yml'))
          @paint.danger "[-] Config.yml file is not exist."
          return 0
        end

        @thing = YAML.load_file(File.join(MAIN_PATH, 'config.yml'))

        if @thing["wolfram"].empty?
          @paint.danger "[-] WolframAlfa haven't API Key. Please check #{MAIN_PATH}/config.yml file"
          return 0
        end

        @api_key = @thing["wolfram"]

        @api_host = "http://api.wolframalpha.com/v2/query"
        @query = self.set_query

        if self.up_down == 200
          @paint.success "[+] WolframAlfa is UP!"
          self.send_request
        else
          @paint.danger "[-] WolframAlfa is DOWN!"
        end
      end

      def up_down
        query = "?input=#{@target_host}"
        query += "&pi&appid=#{@api_key}"
        query += "&format=plaintext"
        query += "&podstate=WebSiteStatisticsPod:InternetData__Subdomains&podstate=WebSiteStatisticsPod:InternetData__Subdomains_More"

        res = Typhoeus.get(@api_host + query, followlocation: true)
        res.code
      end


      def set_query
        query = "?input=#{@target_host}"
        query += "&pi&appid=#{@api_key}"
        query += "&format=plaintext"
        query += "&podstate=WebSiteStatisticsPod:InternetData__Subdomains&podstate=WebSiteStatisticsPod:InternetData__Subdomains_More"
        query
      end

      def send_request
          res = Typhoeus.get(@api_host + self.set_query, followlocation: true)

          self.parse_response res.body
      end

      def parse_response response
        xml_doc = Nokogiri::XML (response)
        parsed_string = xml_doc.css('pod[id="WebSiteStatisticsPod:InternetData"] > subpod[title="Subdomains"] > plaintext').text
        lines = parsed_string.split("\n")
        lines.each_with_index do |line, index|
          next if index == 0
          line = line.sub(/\s.+/, '')
          @subdomains.push(line)
        end

      end

      def get_subdomains
        @subdomains
      end

    end
  end
end
