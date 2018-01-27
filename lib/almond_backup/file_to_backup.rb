require 'date'
require 'file_data'

module AlmondBackup
  class FileToBackup
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def backup_folder
      raw_date = creation_date()
      date = DateTime.strptime(raw_date, '%Y:%m:%d %H:%M:%S') unless raw_date.nil?

      date.nil? ? "" : date.strftime("%Y_%m")
    end

    def creation_date
      FileData::Exif.only_image_tag(@file, [34_665, 36_867])
    end
  end
end
