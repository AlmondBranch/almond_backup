require_relative 'file_finder'
require_relative 'file_sorter_factory'
require 'pathname'

module AlmondBackup
  class BackupRunner

    def initialize(file_finder)
      @file_finder = file_finder
    end

    def run_backup(source_folder, destination_folder, *file_extensions)
      raise "Source folder does not exist" unless Dir.exist? source_folder
      raise "Destination folder does not exist" unless Dir.exist? destination_folder

      source_dest = Pathname.new(source_folder)
      destination_dest = Pathname.new(destination_folder)

      begin
        rel_dest = destination_dest.relative_path_from(source_dest)
        if rel_dest.basename == "" or not rel_dest.basename.start_with?('..')
          raise "Destination folder is a subfolder of the source folder"
        end
      rescue ArgumentError
      end

      files = @file_finder.find(source_folder, *file_extensions)

      backup_source = AlmondBackup::BackupSource.new(destination_folder)
      files.each { |f| backup_source.backup_file(f, AlmondBackup::FileSorterFactory.for(f).backup_folder) }
    end
  end
end

