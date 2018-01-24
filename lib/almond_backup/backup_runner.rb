require_relative 'file_finder'
require_relative 'file_sorter_factory'

module AlmondBackup
  class BackupRunner

    def initialize(file_finder)
      @file_finder = file_finder
    end

    def run_backup(source_folder, destination_folder, *file_extensions)
      files = @file_finder.find(source_folder, *file_extensions)

      backup_source = AlmondBackup::BackupSource.new(destination_folder)
      files.each { |f| backup_source.backup_file(f, AlmondBackup::FileSorterFactory.for(f).backup_folder) }
    end
  end
end

