module SubdomainFinder
  module Helper
    module SystemDetector

      class WordPress

        @boolean_message = SubdomainFinder::Helper::Paint.new

        def initialize
          @opt  = { ssl_verifyhost:0 , followlocation: true}
        end

        def wp_readme domain
          target = "/readme.html"
          domain = domain + target
          res = Typhoeus::Request.new(domain,@opt)
          res = res.run

          if res.success?
            res.body.include? ("wordpress.org" or "wordpress.org/")
          else
            false
          end

        end

        def wp_robots domain

          target = "/robots.txt"
          domain = domain + target
          res = Typhoeus::Request.new(domain,@opt)
          res = res.run

          if res.success?
            res = res.body
            href = res.include? ("wp-content" or "wp-admin")
            href
          else
            false
          end
        end

        def wp_content domain
          target = "/wp-content/"
          domain = domain + target
          res = Typhoeus::Request.new(domain,@opt)
          res = res.run

          res.success? ? true : false

        end

        def get_result target
          {
              'readme': self.wp_readme(target),
              'robots': self.wp_robots(target),
              'wp_content':self.wp_content(target)
          }
        end

      end
    end
  end
end
