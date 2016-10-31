module SubdomainFinder
  module Helper
    module SystemDetector
      class Joomla

        def initialize
          @opt  = { ssl_verifyhost:0 , followlocation: true}
        end

        def joomla_components domain
          target = "/components/"
          domain = domain + target
          res = Typhoeus::Request.new(domain,@opt)
          res = res.run

          res.success? ? true : false

        end

        def joomla_robots domain
          target = "/robots.txt"
          domain = domain + target

          res = Typhoeus::Request.new(domain,@opt)
          res = res.run
          res = res.body
          if res.include? "components"
            return true
          else
            return false
          end

        end

        def get_result target
          {
              'robots': self.joomla_robots(target),
              'components': self.joomla_components(target)
          }
        end

      end
    end
  end
end
