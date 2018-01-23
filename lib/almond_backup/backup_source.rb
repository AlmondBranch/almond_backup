require_relative 'backup_folder'

module AlmondBackup
  class BackupSource
    attr_reader :folder

    def initialize(folder)
      @folder = folder
      @backup_folders = {}
    end

    def backup_file(file, folder_tag)      
      if (@backup_folders[backup_folder].nil?)
        @backup_folders.add(folder_tag, AlmondBackup::BackupFolder.new(File.join(@folder, folder_tag)))

      @backup_folders[backup_folder].add_file(file)
    end
  end
end
