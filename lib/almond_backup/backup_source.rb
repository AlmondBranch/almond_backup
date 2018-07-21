require_relative 'backup_folder'

module AlmondBackup
  # Represents the destination where backup files are saved to
  class BackupSource
    attr_reader :folder

    def initialize(folder)
      @folder = folder
      @backup_folders = BackupFolders.new
    end

    def backup_file(file, folder_tag)
      @backup_folders[folder_tag].add_file(file)
    end
  end

  # Helper class only meant to be used by BackupSource
  class BackupFolders
    def initialize()
      @folders = {}
    end

    def [](folder_tag)
      @folders[folder_tag] if @folders.key?(folder_tag)
      @folders[folder_tag] = create_backup_folder(folder_tag)
    end

    def create_backup_folder(tag)
      AlmondBackup::BackupFolder.new(File.join(@folder, tag))
    end
  end
end
