#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

class Floppy_Image_Maker
  require 'systemu'

  def initialize(source_file, out_put_image)
    @source_file = source_file
    @out_put_image = out_put_image
  end

  def create_image_and_format
    dd_command = "dd if=/dev/zero of=" + @out_put_image + " bs=1KiB count=1440"
    mkdosfs_command = "mkdosfs" + @out_put_image
    status, stdout, stderr = systemu dd_command
    status, stdout, stderr = mkdosfs_command
  end

  def mount_cp_umount
    status, stdout, stderr = systemu "mkdir /mnt/vfd"
    mount_command = "mount -o loop " + @out_put_image + " /mnt/vfd"
    status, stdout, stderr = systemu mount_command
    cp_command = "cp " + @source_file + " /mnt/vfd"
    status, stdout, stderr = systemu cp_command
    status, stdout, stderr = systemu "umount /mnt/vfd"
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
    vali.source_file_check
    vali.argument_number_check
  rescue => e
    puts e.message
    exit
  end

  image = Floppy_Image_Maker.new(source_file, out_put_image)
  image.create_image_and_format
  image.mount_cp_umount

end
