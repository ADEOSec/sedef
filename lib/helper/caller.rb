module SubdomainFinder
  module Helper
    class Caller

      def initialize target
        @target = target
        @sum = []
        @paint = SubdomainFinder::Helper::Paint.new
        self.services_caller

      end

      def services_caller

        t1 = Thread.new do
          tmp = SubdomainFinder::WebServices::Wolframalfa.new(@target).get_subdomains
          @sum += tmp
          if tmp.count > 1
            @paint.info("[*] #{tmp.count} results found by WolframAlpha")
          elsif tmp.count == 1
            @paint.info("[*] #{tmp.count} result found by WolframAlpha")
          else
            @paint.danger("[!] WolframAlpha couldn't find any result")
          end
        end

        t2 = Thread.new do
          tmp = SubdomainFinder::WebServices::Pkey.new(@target).get_subdomains
          @sum += tmp
          if tmp.count > 1
            @paint.info("[*] #{tmp.count} results found by Pkey")
          elsif tmp.count == 1
            @paint.info("[*] #{tmp.count} result found by Pkey")
          else
            @paint.danger("[!] Pkey couldn't find any result")
          end

        end

        t3 = Thread.new do
          tmp = SubdomainFinder::WebServices::Netcraft.new(@target).get_subdomains
          @sum += tmp
          if tmp.count > 1
            @paint.info("[*] #{tmp.count} results found by Netcraft")
          elsif tmp.count == 1
            @paint.info("[*] #{tmp.count} result found by Netcraft")
          else
            @paint.danger("[!] Netcraft couldn't find any result")
          end
        end

        t4=Thread.new do

          tmp= SubdomainFinder::WebServices::Dnsdumpster.new(@target).get_subdomains
          @sum += tmp
          if tmp.count > 1
            @paint.info("[*] #{tmp.count} results found by Dnsdumpster")
          elsif tmp.count == 1
            @paint.info("[*] #{tmp.count} result found by Dnsdumpster")
          else
            @paint.danger("[!] DNSdumpster couldn't find any result")
          end
        end

        @paint.success("[+] TheHarvester is UP!")
        t5=Thread.new do
          tmp = SubdomainFinder::Tools::TheHarvester.new(@target).get_subdomains
          @sum += tmp
        if tmp.count > 1
          @paint.info("[*] #{tmp.count} results found by TheHarvester")
        elsif tmp.count == 1
          @paint.info("[*] #{tmp.count} result found by TheHarvester")
        else
          @paint.danger("[!] TheHarvester couldn't find any result")
        end
        end

        @paint.success("[+] Fierce is UP!")
        t6=Thread.new do
          tmp = SubdomainFinder::Tools::Fierce.new(@target).get_subdomains
          @sum += tmp
        if tmp.count > 1
          @paint.info("[*] #{tmp.count} results found by  Fierce")
        elsif tmp.count == 1
          @paint.info("[*] #{tmp.count} result found by Fierce")
        else
          @paint.danger("[!] Fierce couldn't find any result")
        end
        end

        t8 = Thread.new do
          t1.join
          t2.join
          t3.join
          t4.join
          t5.join
          t6.join
        end
        t8.join


        self.remove_duplicate
      end

      def get_subdomains
        @sum
      end

      def remove_duplicate
        @paint.info "[#] Total Subdomains #{@sum.length}"
        @sum.uniq!
        @paint.info "[#] Uniq Subdomains #{@sum.length}"

      end
    end
  end
end
