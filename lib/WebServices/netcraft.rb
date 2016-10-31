module SubdomainFinder
  module WebServices
    class Netcraft

      def initialize target

        @target_host = target
        @base_url = 'https://searchdns.netcraft.com'
        @subdomains = []
        @query = self.set_query
        @paint = SubdomainFinder::Helper::Paint.new

        if self.up_down == 200
          @paint.success "[+] Netcraft is UP!"
           self.send_request
        else
          @paint.danger "[-] Netcraft is DOWN!"
        end
      end
      def up_down
        query = '/?restriction=site+contains&'
        query += "host=*.#{@target_host}"
        query += '&lookup=wait..&position=limited'
        res = Typhoeus.get(@base_url + query, followlocation: true , ssl_verifyhost: 0)
        res.code
      end

      def set_query
        query = '/?restriction=site+contains&'
        query += "host=*.#{@target_host}"
        query += '&lookup=wait..&position=limited'
        query
      end

      def send_request
        res = Typhoeus.get(@base_url + @query, followlocation: true , ssl_verifyhost: 0)
        @sites = []
        html_doc = Nokogiri::HTML(res.body)
        total_sites = html_doc.css('.blogbody > p:first-child').text.scan(/[0-9]+/).first.to_i
        @sites << html_doc.css("table.TBtable > tr > td:nth-child(2) > a").map{ |a| a.attr("href") }
        @sites.flatten!

        if total_sites > 20
          @from = 1
          @last = @sites[-1].gsub!("http://","").gsub!("/","")
          for i in 1..(total_sites/20)
            @from +=  20
            res = Typhoeus.get(@base_url + self.new_query, followlocation: true,ssl_verifyhost: 0)
            html_doc = Nokogiri::HTML(res.body)
            @sites << html_doc.css("table.TBtable > tr > td:nth-child(2) > a").map{ |a| a.attr("href") }
            @sites.flatten!
            @last = @sites[-1].gsub!("http://","").gsub!("/","")
          end
        end

        @sites.each do |line|
          if line.include?("http://")
             line.gsub!("http://","").gsub!("/","")
          end
          @subdomains.push(line)
        end
      end

      def  new_query
          query = "/?host=*.#{@target_host}"
          query += "&last=#{@last}"
          query += "&from=#{@from}"
          query += "&restriction=site%20contains&position=limited"

          query
      end


      def get_subdomains
        @subdomains
      end

    end
  end
end
