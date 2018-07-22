require 'set'
require 'digest'
require 'fileutils'

module AlmondBackup
  # Container for backed up files
  class BackupFolder
    attr_reader :folder

    DIGITS_CAPTURE = '(\d+)'.freeze
    BACKUP_MARKER = " Backup_#{DIGITS_CAPTURE}".freeze
    BACKUP_REGEX = Regexp.new(/#{BACKUP_MARKER}\./i).freeze

    def initialize(folder)
      @folder = folder
      @max_num = 0
    end

    def hashes
      @hashes ||= Dir.glob(File.join(folder, '**', '*.*'))
                     .each_with_object(Set.new) do |f, set|
                       set.add(get_file_hash(f))

                       num = get_backup_number(f)
                       @max_num = num if num > @max_num
                     end
    end

    def max_num
      @hashes ||= hashes
      @max_num
    end

    def add_file(path)
      save_path = File.join(folder, File.basename(path))
      FileUtils.mkdir_p folder

      if File.exist? save_path
        backup_num = max_num + 1
        save_path = add_backup_number(save_path, backup_num)
        @max_num = backup_num
      end

      FileUtils.cp path, save_path
      hashes.add(get_file_hash(save_path))
    end

    def get_file_hash(path)
      Digest::SHA256.file(path)
    end

    def get_backup_number(file_name)
      match = file_name.match(BACKUP_REGEX)
      match.nil? ? 0 : match[1].to_i
    end

    def add_backup_number(path, num)
      marker_index = path.index('.', 1)
      path.insert(marker_index, BACKUP_MARKER.sub(DIGITS_CAPTURE, num.to_s))
    end
  end
end
