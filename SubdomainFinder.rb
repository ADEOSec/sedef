#!/usr/bin/env ruby

require 'net/https'
require 'net/http'
require 'timeout'
require 'colorize'
require 'nokogiri'
require 'fileutils'
require 'resolv'
require 'thread'
require 'typhoeus'
require 'dir'
require 'yaml'
require 'ruby-progressbar'
require 'optparse'
require 'terminal-table'

require_relative 'lib/WebServices/wolframalfa'
require_relative 'lib/WebServices/pkey'
require_relative 'lib/WebServices/dnsdumpster'
require_relative 'lib/WebServices/netcraft'

require_relative 'lib/Tools/tools_public'
require_relative 'lib/Tools/fierce'
require_relative 'lib/Tools/theharvester'

require_relative 'lib/helper/http_controller'
require_relative 'lib/helper/paint'
require_relative 'lib/helper/caller'

require_relative 'lib/helper/SystemDetector/joomla_controller'
require_relative 'lib/helper/SystemDetector/wp_controller'
require_relative 'lib/helper/SystemDetector/check_system'

require_relative 'lib/helper/ScannerCaller/wpscan'
require_relative 'lib/helper/ScannerCaller/joomlavs'
require_relative 'lib/helper/ScannerCaller/shodan'



@paint = SubdomainFinder::Helper::Paint.new

sdf =
"
#  ███████╗███████╗██████╗ ███████╗███████╗
#  ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝
#  ███████╗█████╗  ██║  ██║█████╗  █████╗
#  ╚════██║██╔══╝  ██║  ██║██╔══╝  ██╔══╝
#  ███████║███████╗██████╔╝███████╗██║
#  ╚══════╝╚══════╝╚═════╝ ╚══════╝╚═╝
"
    sdf  = sdf.split("\n")
sdf.each do |line|
  @paint.warning line
  sleep 0.2
 end

MAIN_PATH = File.realdirpath(__dir__)


options = {:domain => nil, :thread => nil}

parser = OptionParser.new do|opts|
  opts.banner = "Usage: SubdomainFinder.rb [options]"
  opts.on('-d', '--domain domain_name', 'Domain Name') do |domain|
    options[:domain] = domain;
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end

end

parser.parse!
if options[:domain].nil?
  puts parser
else


  MAIN_DOMAIN = options[:domain]

  Dir.mkdir("#{MAIN_PATH}/reports/#{MAIN_DOMAIN}") unless File.exists?("#{MAIN_PATH}/reports/#{MAIN_DOMAIN}")

  REPORTS_PATH = MAIN_PATH + "/reports/#{MAIN_DOMAIN}"


  @paint.info "Your target setting #{MAIN_DOMAIN}"

  start_time = Time.now
  @paint.info(Time.at(start_time).utc.strftime "Start time : %d/%m/%Y %H:%M:%S")

  @caller = SubdomainFinder::Helper::Caller.new(MAIN_DOMAIN)

  unless @caller.get_subdomains.empty?
    @http_helper = SubdomainFinder::Helper::HttpController.new(@caller.get_subdomains)
  end

  system("chmod -R 777 #{REPORTS_PATH}")

  finish_time = Time.now
  @paint.info(Time.at(finish_time).utc.strftime "End time : %d/%m/%Y %H:%M:%S")

  time_diff = finish_time - start_time
  @paint.success(Time.at(time_diff.to_i.abs).utc.strftime "Completion Time : %H:%M:%S")
end
