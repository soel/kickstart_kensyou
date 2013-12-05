#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

class Ks
  require 'erb'

  def initialize(host, ipaddr,
                 password, template_file, ks_file)
    @host = host
    @ipaddr = ipaddr
    @password = password
    @template_file = template_file
    @ks_file = ks_file

  end

  def ks_create
    if File.exist?(@template_file) == false
      #puts "Template file not found"
      #exit 1
      raise StandardError, "Template file not found"
    end

    #@erb = ERB.new(File.read(@template_file),nil,"-")
    @erb = ERB.new(File.read(@template_file))
  end

  def ks_file_output
    File.open(@ks_file, "w") do |file|
      file.puts @erb.result(binding)
    end
    #File.write(@ks_file, @erb.result(binding))

    #puts "ファイルを作成しました"
    #puts @ks_file + "  ファイルを作成しました"
  end
end

class Argument_Validator

  def number(*argv)
    unless argv.size == 3
      raise StandardError, "usage ./kensyo_ks.rb <hostname> <ip address> <root password>"
    end

    return *argv
  end
end

class Ipaddress_Validator

  def check(ipaddr)
    ipaddr_regexp = /^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/

    unless ipaddr_regexp === ipaddr
      raise StandardError, "第 2 引数にはIP アドレスを入力してください"
    end

    return ipaddr
  end
end

if __FILE__ == $0

  begin
    agv = Argument_Validator.new
    agv.number(*ARGV)
  rescue => e
    puts e.message
    exit
  end

  begin
    ipadd_check = Ipaddress_Validator.new
    ipadd_check.check(ARGV[1])
  rescue => e
    puts e.message
    exit
  end

  host = ARGV[0]
  ipaddr = ARGV[1]
  password = ARGV[2]
  template_file = './ks.cfg.erb'
  ks_file = 'ks.cfg'


  kickstart_file = Ks.new(host, ipaddr, password, template_file, ks_file)
  #puts kickstart_file.instance_variable_get(:@host)

  begin
    kickstart_file.ks_create
  rescue => e
    puts e.message
    exit
  end

  kickstart_file.ks_file_output
  puts ks_file + "  ファイルを作成しました"
end
