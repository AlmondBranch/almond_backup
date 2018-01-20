require 'file_data'

module AlmondBackup
  class ExifFile
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def creation_date
      FileData::Exif.only_image_tag(@path, [34_665, 36_867])
    end
  end
end
