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

class Validator

  def initialize(*argv, ipaddr, template_file)
    @argv = argv
    @ipaddr = ipaddr
    @template_file = template_file
  end

  def argument_number
    unless @argv.size == 3
      raise StandardError, "usage ./kensyo_ks.rb <hostname> <ip address> <root password>"
    end
  end

  def ipaddress_check
    ipaddr_regexp = /^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/

    unless ipaddr_regexp === @ipaddr
      raise StandardError, "第 2 引数にはIP アドレスを入力してください"
    end
  end

  def template_file_check
    if File.exist?(@template_file) == false
      raise StandardError, "テンプレートがありません"
    end
  end
end

if __FILE__ == $0

  host = ARGV[0]
  ipaddr = ARGV[1]
  password = ARGV[2]
  template_file = './ks.cfg.erb'
  ks_file = 'ks.cfg'

  begin
    vali = Validator.new(*ARGV, ipaddr, template_file)
    vali.argument_number
    vali.ipaddress_check
    vali.template_file_check
  rescue => e
    puts e.message
    exit
  end

  kickstart_file = Ks.new(host, ipaddr, password, template_file, ks_file)
  kickstart_file.ks_create
  kickstart_file.ks_file_output
  puts ks_file + "  ファイルを作成しました"
end
