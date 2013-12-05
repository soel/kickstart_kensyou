# -*- encoding: utf-8 -*-

require "./floppy_image_maker.rb"

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
  after(:each) do
    File.delete("/tmp/test.img")
  end

  it "イメージファイルの作成" do
    fim = Floppy_Image_Maker.new("test.cfg", "/tmp/test.img")
    fim.create_image
    FileTest.exist?("/tmp/test.img").should be_true
  end
end
