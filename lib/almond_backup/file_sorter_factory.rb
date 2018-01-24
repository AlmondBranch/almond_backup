require_relative 'file_to_backup'

module AlmondBackup
  class FileSorterFactory
    def self.for(file_path)
      #For now just return the class that assumes an exif file
      AlmondBackup::FileToBackup.new(file_path)
    end
  end
end
