#!/usr/bin/env ruby

# deploy
# rsync . -vru eshepard@slower.net:www/subdomains/eliotshepard.com/

require 'erb'
require 'cgi'

cgi = CGI.new('html3')

basedir = File.dirname(__FILE__);
layout_path = basedir + '/templates/layout.html.erb'
template_path = basedir + '/templates/' + (cgi['t'].empty? ? 'index' : cgi['t']) + '.html.erb'

if (File.exists?(template_path))
	unless cgi['s'].empty?
		set = Dir.new(basedir + "/sets/#{cgi['s']}").reject { |v| v == '.' || v == '..' }.sort.map { |x| "<img src='/sets/#{cgi['s']}/#{x}' />" }.join
	end
	template = ERB.new(File.read(template_path)).result
else
	print cgi.header( {"status" => "MOVED", "location" => '/' }); exit
end

print cgi.header("type" => "text/html")
puts ERB.new(File.read(layout_path)).result(binding())
