require 'file_data'
require 'date'

module AlmondBackup
  class ExifFile
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def creation_date
      raw_tag = FileData::Exif.only_image_tag(@path, [34_665, 36_867])
      DateTime.strptime(raw_tag, '%Y:%m:%d %H:%M:%S') unless raw_tag.nil?
    end
  end
end
