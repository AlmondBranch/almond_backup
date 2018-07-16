require_relative 'file_finder'
require_relative 'backup_source'
require 'pathname'
require 'file_data'

module AlmondBackup
  class BackupRunner

    def initialize(file_finder)
      @file_finder = file_finder
    end

    def run_backup(source_folder, destination_folder, *file_extensions)
      raise ArgumentError, "Source folder does not exist" unless Dir.exist? source_folder
      raise ArgumentError, "Destination folder does not exist" unless Dir.exist? destination_folder

      source_dest = Pathname.new(source_folder)
      destination_dest = Pathname.new(destination_folder)

      begin
        rel_dest = destination_dest.relative_path_from(source_dest).to_path
        if rel_dest == "." or not rel_dest.start_with?('..')
          raise "Destination folder is a subfolder of the source folder"
        end
      rescue ArgumentError
      end

      files = @file_finder.find(source_folder, *file_extensions)
      backup_source = AlmondBackup::BackupSource.new(destination_folder)

      files.each do |f|
        origin_date = FileData::FileInfo.origin_date(f)
        backup_folder = origin_date.nil? ? "" : origin_date.strftime("%Y_%m")

        backup_source.backup_file(f, backup_folder)
      end
    end
  end
end

