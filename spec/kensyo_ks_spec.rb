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

describe Argument_Validator do
  it "実行した時に引数が足りないとエラーメッセージが表示される" do
    test = ["test", "test"]
    agv = Argument_Validator.new
    expect{ agv.number(*test) }.to raise_error(StandardError,
                                              "usage ./kensyo_ks.rb <hostname> <ip address> <root password>")
  end

  it "引数が正しいと引数が戻り値になる" do
    test = ["test", "test", "test"]
    agv = Argument_Validator.new
    agv.number(*test).should == test
  end
end

describe Ipaddress_Validator do
  it "実行したときの引数の2つ目が ip address 形式じゃないとエラーメッセージが表示される" do
    ipadd_check = Ipaddress_Validator.new
    expect{ ipadd_check.check(10) }.to raise_error(StandardError,
                                                   "第 2 引数にはIP アドレスを入力してください")
  end

  it "引数が ip address 形式の場合引数のip address が戻り値になる" do
    ipadd_check = Ipaddress_Validator.new
    ipadd_check.check("172.16.62.120").should == "172.16.62.120"
  end
end

describe Ks do
  after(:each) do
    File.delete("/tmp/ks.cfg")
  end

  it "テンプレートファイルが無いとエラーになる" do
    kick = Ks.new("test", "172.16.62.120", "test", "./dummy.erb", "/tmp/ks.cfg")
    expect{ kick.ks_create }.to raise_error(StandardError,
                                            "Template file not found")
  end

  it "キックスタートファイルが生成される"do
    kick = Ks.new("test", "172.16.62.120", "test", "./ks.cfg.erb", "/tmp/ks.cfg")
    kick.ks_create
    kick.ks_file_output
    FileTest.exist?("/tmp/ks.cfg").should be_true
  end

#  it "キックスタートファイルの中身が意図した通りである" do

#  end
end
