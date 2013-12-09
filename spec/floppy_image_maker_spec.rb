# -*- encoding: utf-8 -*-

require "./floppy_image_maker.rb"
require "stringio"

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
    @correct_source_file = "test.cfg"
    @incorrect_source_file = "test.test.cfg"
    @correct_argv = [ "test", "test" ]
    @incorrect_argv1 = [ "test" ]
    @incorrect_argv2 = [ "test", "test", "test"]
  end

  it "ソースファイルがなければエラー" do
    vali = Validator.new(@incorrect_source_file, @correct_argv)
    expect{ vali.source_file_check }.to raise_error(
      StandardError, "Source file not found")
  end

  it "引数が足りなければエラー" do
    vali = Validator.new(@correct_source_file, @incorrect_argv1)
    expect{ vali.argument_number_check }.to raise_error(
      StandardError, "usage ./floppy_image_maker.rb <source_file> <out_put_image>")
  end

  it "引数が多ければエラー" do
    vali = Validator.new(@correct_source_file, @incorrect_argv2)
    expect{ vali.argument_number_check }.to raise_error(
      StandardError, "usage ./floppy_image_maker.rb <source_file> <out_put_image>")
  end
end
    


describe Floppy_Image_Maker do
  before(:all) do
    @fim = fim = Floppy_Image_Maker.new("test.cfg", "/tmp/test.img")
  end

  after(:all) do
    @fim.create_image
  end

  it "イメージファイルの作成されることの確認" do
    capture(:stdout) { @fim.create_image }.should == "イメージ作成の処理が終了しました\n"
  end

  it "フォーマットの確認" do
    capture(:stdout) { @fim.format_image }.should == "イメージフォーマットの処理が終了しました\n"
  end

  it "マウント処理の確認" do
    capture(:stdout) { @fim.mount_image }.should == "/mnt/vfd へのマウントの処理が終了しました\n"
  end

  it "ファイルコピーの確認" do
    capture(:stdout) { @fim.cp_file }.should == "イメージへのファイルのコピーの処理が終了しました\n"
  end

  it "アンマウントの確認" do
    capture(:stdout) { @fim.umount }.should == "アンマウントの処理が終了しました\n"
  end
end
