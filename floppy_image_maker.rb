#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

class Floppy_Image_Maker
  require 'systemu'

  def initialize(source_file, out_put_image)
    @source_file = source_file
    @out_put_image = out_put_image
  end

  def create_image
    dd_command = "dd if=/dev/zero of=" + @out_put_image + " bs=1KiB count=1440"
    status, stdout, stderr = systemu dd_command
    #puts status
    stdio(status, stderr, "イメージ作成")
  end

  def format_image
    mkdosfs_command = "mkdosfs " + @out_put_image
    status, stdout, stderr = systemu mkdosfs_command
    #puts status
    stdio(status, stderr, "イメージフォーマット")
  end

  def mount_image
    unless Dir.exist?("/mnt/vfd")
      status, stdout, stderr = systemu "sudo mkdir /mnt/vfd"
      #puts status
      stdio(status, stderr, "/mnt/vfd の作成")
    end
    mount_command = "sudo mount -o loop " + @out_put_image + " /mnt/vfd"
    status, stdout, stderr = systemu mount_command
    stdio(status, stderr, "/mnt/vfd へのマウント")
    #puts status
  end

  def cp_file
    cp_command = "sudo cp " + @source_file + " /mnt/vfd"
    status, stdout, stderr = systemu cp_command
    #puts status
    stdio(status, stderr, "イメージへのファイルのコピー")
  end

  def umount
    status, stdout, stderr = systemu "sudo umount /mnt/vfd"
    #puts status
    stdio(status, stderr, "アンマウント")
  end

  def stdio(status, stderr, display)
    if status.success?
      print display
      print "の処理が終了しました\n"
    elsif stderr
      puts stderr
    end
  end

end

class Validator

  def initialize(source_file, *argv)
    @source_file = source_file
    @argv = argv
  end

  def source_file_check
    if File.exist?(@source_file) == false
      raise StandardError, "Source file not found"
    end
  end

  def argument_number_check
    unless @argv.size == 2
       raise StandardError, "usage ./floppy_image_maker.rb <source_file> <out_put_image>"
    end
  end
end

if __FILE__ == $0

  source_file = ARGV[0]
  out_put_image = ARGV[1]

  begin
    vali = Validator.new(source_file, *ARGV)
    vali.argument_number_check
    vali.source_file_check
  rescue => e
    puts e.message
    exit
  end

  image = Floppy_Image_Maker.new(source_file, out_put_image)
  image.create_image
  image.format_image
  image.mount_image
  image.cp_file
  image.umount

end
