module SubdomainFinder
  module WebServices
    class Dnsdumpster

      def initialize target
        @target_host = target
        @subdomains = []
        @paint = SubdomainFinder::Helper::Paint.new
        if self.up_down == 200
          @paint.success "[+] DNSdumpster is UP!"
          self.send_request
        else
          @paint.danger "[-] DNSdumpster is DOWN!"
        end
      end

      def up_down
        @cookie = self.get_token
        @token = @cookie.to_s.scan(/=(.+)[,;]$/)[0][0]
        request = Typhoeus::Request.new(
            "https://dnsdumpster.com/",
            method: :post,
            headers: {
                Cookie: @cookie,
                Referer: 'https://dnsdumpster.com/',
            },
            body: "csrfmiddlewaretoken=#{@token}&targetip=#{@target_host}"
        )
        response =request.run
        response.code
      end


      def send_request
        @cookie = self.get_token
        @token = @cookie.to_s.scan(/=(.+)[,;]$/)[0][0]
        request = Typhoeus::Request.new(
            "https://dnsdumpster.com/",
            method: :post,
            headers: {
                      Cookie: @cookie,
                      Referer: 'https://dnsdumpster.com/',
            },
          body: "csrfmiddlewaretoken=#{@token}&targetip=#{@target_host}"
        )
        response =request.run
        self.response_parser response.body
      end

      def get_token
        res = Typhoeus::Request.get("https://dnsdumpster.com/", ssl_verifyhost: 0, followlocation: true)
        cookie = res.headers_hash["Set-Cookie"].match(/^.*?;/)[0]
        cookie
      end

      def response_parser response

         html_doc = Nokogiri::HTML(response)
         html_doc.css('table').last.css('td[class="col-md-4"]').each do |item|
           subdomain = item.text.split("\n")[0]
           @subdomains.push(subdomain)
         end
      end

      def get_subdomains
        @subdomains
      end

    end
  end
end
