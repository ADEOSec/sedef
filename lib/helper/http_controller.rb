require 'terminal-table/import'
module SubdomainFinder
  module Helper
    class HttpController
      def initialize subdomains_array
        @subdomains = subdomains_array
        $checked_subdomains = Hash.new
        @paint = SubdomainFinder::Helper::Paint.new
        @wp           = SubdomainFinder::Helper::SystemDetector::WordPress.new
        @joomla       = SubdomainFinder::Helper::SystemDetector::Joomla.new
        @system_check = SubdomainFinder::Helper::SystemDetector::CheckSystem.new
        @shodan_call  = SubdomainFinder::Helper::ScannerCaller::Shodan.new

        self.http_status_control
      end

      def http_status_control

        progressbar_http= ProgressBar.create(title: "Controling (Http || Https) & (Wp || Joomla) ",
                                         starting_at: 0,
                                         total: @subdomains.length,
                                         format: "%a %b\u{15E7}%i %p%% %t",
                                         progress_mark: ' ',
                                         remainder_mark: "\u{FF65}"
        )
        @subdomains.each_with_index do |domain, index|
          subdomain_hash = Hash.new
          t1 = Thread.new do
            subdomain_hash['http_status'] = self.check_status domain, 'http'
          end
          t2 = Thread.new do
            subdomain_hash['https_status'] = self.check_status domain, 'https'
          end
          t3 = Thread.new do
            t1.join
            t2.join
          end
          t3.join

          if subdomain_hash['http_status'] or subdomain_hash['https_status']
            t4 = Thread.new do
              subdomain_hash["wordpress"] = @wp.get_result domain
            end
            t5 = Thread.new do
              subdomain_hash["joomla"] = @joomla.get_result domain
            end

            t6 = Thread.new do
              t4.join
              t5.join
            end
            t6.join
            $checked_subdomains[domain] = subdomain_hash
          end
          progressbar_http.increment
        end
        $checked_subdomains.empty? ? @paint.danger("No Result!") : self.reachable_subdomains_print
      end

      def reachable_subdomains_print
        @paint.info "[#] Reachable Subdomains #{$checked_subdomains.length}"
        rows = []
        rows << [' ', 'SUBDOMAIN', 'HTTP', 'HTTPS', 'README', 'ROBOTS', 'CONTENT', 'ROBOTS', 'COMPONENTS']

         progressbar_wpjoom = ProgressBar.create( title: "Running (Wpscan || Joomlavs) ",
                                                starting_at: 0,
                                                total: $checked_subdomains.length,
                                                format: "%a %b\u{15E7}%i %p%% %t",
                                                progress_mark: ' ',
                                                remainder_mark: "\u{FF65}"
        )

        $checked_subdomains.each_with_index do |subdomain, index|
            t1 = Thread.new do
              @shodan_call.get_info (subdomain.first)
            end
            t2 = Thread.new do
             if (subdomain.last["wordpress"][:readme] ) || (subdomain.last["wordpress"][:robots]) || (subdomain.last["wordpress"][:wp_content])
               @system_check.check_wp (subdomain.first)
             end
            end

            t3 = Thread.new do
              if (subdomain.last["joomla"][:robots] ) || (subdomain.last["joomla"][:components])
                @system_check.check_joomla (subdomain.first)
              end
            end

            t4 = Thread.new do
              t1.join
              t2.join
              t3.join
            end
            t4.join
            progressbar_wpjoom.increment

        end


        $checked_subdomains.each_with_index do |subdomain, index|
            rows << [
                index + 1, subdomain.first, subdomain.last['http_status'].to_s, subdomain.last['https_status'].to_s,
                @paint.boolean_message( subdomain.last['wordpress'][:readme] ),
                @paint.boolean_message( subdomain.last['wordpress'][:robots] ),
                @paint.boolean_message( subdomain.last['wordpress'][:wp_content] ),
                @paint.boolean_message( subdomain.last['joomla'][:robots] ),
                @paint.boolean_message( subdomain.last['joomla'][:components] )
            ]
          end
        table = Terminal::Table.new :headings => [{:value => " ", :colspan => 2 },{:value => 'HTTP/S STATUS',:colspan => 2 }, {:value => '<WORDPRESS>', :colspan => 3},{:value => '<JOOMLA>', :colspan => 2}], :rows => rows
        puts table
      end


      def check_status domain, scheme
        self.check_response Typhoeus::Request.get("#{scheme}://#{domain}", followlocation: true, timeout:3), scheme
      end

      def check_response res, scheme
        if res.success?
         return  URI(res.effective_url).scheme == scheme ?  res.code :  false
        else
          return false
        end
      end
    end
  end
end
