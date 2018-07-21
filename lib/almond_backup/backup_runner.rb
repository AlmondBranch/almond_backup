require_relative 'file_finder'
require_relative 'backup_source'
require 'pathname'
require 'file_data'

module AlmondBackup
  # Executes a backup
  class BackupRunner
    INVALID_DEST_FOLDER_MSG =
      'Destination folder is a subfolder of the source folder'.freeze

    def initialize(file_finder)
      @file_finder = file_finder
    end

    def run_backup(source_folder, destination_folder, *file_extensions)
      verify_folders source_folder, destination_folder

      files = @file_finder.find(source_folder, *file_extensions)
      backup_files(files, destination_folder)
    end

    private

    def backup_files(files, destination_folder)
      backup_source = AlmondBackup::BackupSource.new(destination_folder)

      files.each do |f|
        origin_date = FileData::FileInfo.origin_date(f)
        backup_folder = origin_date.nil? ? '' : origin_date.strftime('%Y_%m')

        backup_source.backup_file(f, backup_folder)
      end
    end

    def verify_folders(source_folder, destination_folder)
      src_exists = Dir.exist? source_folder
      raise ArgumentError, 'Source folder does not exist' unless src_exists

      dest_exists = Dir.exist? destination_folder
      raise ArgumentError, 'Destination folder does not exist' unless dest_exists

      verify_dest_not_subfolder_of_source source_folder, destination_folder
    end

    def verify_dest_not_subfolder_of_source(source_folder, destination_folder)
      source_dest = Pathname.new(source_folder)
      destination_dest = Pathname.new(destination_folder)

      rel_dest = destination_dest.relative_path_from(source_dest).to_path
      is_subfolder = (rel_dest == '.' || !rel_dest.start_with?('..'))

      raise INVALID_DEST_FOLDER_MSG if is_subfolder
    end
  end
end
