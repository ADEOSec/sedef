module SubdomainFinder
  module WebServices
    class Pkey

      def initialize target

        @target_host = target
        @main_host = 'https://www.pkey.in/tools-i/search-subdomains'
        @opt = {
            body: "zone=#{@target_host}&submit=",
            headers: {
                Referer: 'https://www.pkey.in/tools-i/search-subdomains'
            },
            method: :post,
            ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
        }
        @subdomains = []
        @paint = SubdomainFinder::Helper::Paint.new
        if self.up_down == 200
          @paint.success "[+] Pkey is UP!"
          self.send_request
        else
           @paint.danger "[-] Pkey is DOWN!"
        end
      end

      def up_down
        opt = {
            body: "zone=#{@target_host}&submit=",
            headers: {
                Referer: 'https://www.pkey.in/tools-i/search-subdomains'
            },
            method: :post,
            ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
        }

        up_res = Typhoeus::Request.new(@main_host, opt)
        res = up_res.run
        res.code
      end

      def send_request

        res = Typhoeus::Request.new(@main_host, @opt)
        res = res.run
        self.response_parser res.body
      end

      def response_parser response
        html_doc = Nokogiri::HTML(response)

        if pkey_check html_doc
          html_doc.css('table').last.css('tr > td:first-child').each_with_index do |item, index|
            next if index == 0
            subdomain = item.text.split("\n")[0]
            @subdomains.push(subdomain)
          end
        else
          @paint.danger'NO RESULT!'
        end
      end

      def pkey_check string
        !string.css('form > div[id="okmsg"]').empty?
      end

      def get_subdomains
        @subdomains
      end
    end
  end
end
