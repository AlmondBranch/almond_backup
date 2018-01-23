require_relative 'backup_folder'

module AlmondBackup
  class BackupSource
    attr_reader :folder

    def initialize(folder)
      @folder = folder
      @backup_folders = {}
    end

    def backup_file(file, folder_tag)      
      if (@backup_folders[folder_tag].nil?)
        @backup_folders[folder_tag] = AlmondBackup::BackupFolder.new(File.join(@folder, folder_tag))
      end

      @backup_folders[folder_tag].add_file(file)
    end
  end
end
