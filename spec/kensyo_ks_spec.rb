# -*- encoding: utf-8 -*-

require 'stringio'
require "./kensyo_ks.rb"

def capture(stream)
    begin
        stream = stream.to_s
        eval "$#{stream} = StringIO.new"
        yield
        result = eval("$#{stream}").string
    ensure
        eval "$#{stream} = #{stream.upcase}"
    end
    result
end

describe Validator do
  before(:each) do
    @correct_argv = [ "test", "test", "test" ]
    @incorrect_argv1 = [ "test" ]
    @incorrect_argv2 = [ "test", "test" ,"test", "test"]
    @correct_ipaddr = "172.16.62.120"
    @incorrect_ipaddr = "10"
    @correct_template_file = "./ks.cfg.erb"
    @incorrect_template_file = "./dummy.erb"
  end

  it "引数が足りなければエラー" do
    vali = Validator.new(@incorrect_argv1, @correct_ipaddr, @correct_template_file)
    expect{ vali.argument_number }.to raise_error(StandardError,
                                              "usage ./kensyo_ks.rb <hostname> <ip address> <root password>")
  end

  it "引数が多ければエラー" do
    vali = Validator.new(@incorrect_argv2, @correct_ipaddr, @correct_template_file)
    expect{ vali.argument_number }.to raise_error(StandardError,
                                              "usage ./kensyo_ks.rb <hostname> <ip address> <root password>")
  end

  it "引数の2つ目が ip address 形式じゃないとエラー" do
    vali = Validator.new(@correct_argv, @incorrect_ipaddr, @correct_template_file)
    expect{ vali.ipaddress_check }.to raise_error(StandardError,
                                                   "第 2 引数にはIP アドレスを入力してください")
  end

  it "テンプレートファイルが無いとエラー" do
    vali = Validator.new(@correct_argv, @correct_ipaddr, @incorrect_template_file)
    expect{ vali.template_file_check }.to raise_error(StandardError, "テンプレートがありません")
  end
end

describe Ks do
  before(:each) do
    @correct_hostname = "test"
    @correct_ipaddr = "172.16.62.120"
    @correct_password = "password"
    @correct_template_file = "./ks.cfg.erb"
    @correct_outputfile = "/tmp/ks.cfg"
  end

  after(:each) do
    File.delete(@correct_outputfile)
  end

  it "キックスタートファイルが生成される"do
    kick = Ks.new(@correct_hostname, @correct_ipaddr, @correct_password, @correct_template_file, @correct_outputfile)
    kick.ks_create
    kick.ks_file_output
    FileTest.exist?(@correct_outputfile).should be_true
  end

#  it "キックスタートファイルの中身が意図した通りである" do

#  end
end
