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
      num = max_num + 1

      save_path = File.join(folder, File.basename(path))
      FileUtils.mkdir_p folder

      save_path = add_backup_number(save_path, num) if File.exist?(save_path)

      FileUtils.cp path, save_path

      hashes.add(get_file_hash(save_path))
      @max_num = num
    end

    def get_file_hash(path)
      Digest::SHA256.file(path)
    end

    def get_backup_number(file_name)
      match = file_name.match(BACKUP_REGEX)
      match.nil? ? 0 : match[1].to_i
    end

    def add_backup_number(path, num)
      marker_index = path.index('.', 1) || path.size
      path.insert(marker_index, BACKUP_MARKER.sub(DIGITS_CAPTURE, num.to_s))
    end
  end
end
