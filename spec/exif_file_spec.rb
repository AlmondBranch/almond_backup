require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/exif_file'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::ExifFile do
  extend AlmondBranch::Test::FileSystem

  describe "#creation_date" do
    include FakeFS::SpecHelpers

    def get_stream(bytes)
      StringIO.open(bytes.pack('C*'))
    end

    context 'given an exif file with a creation date' do
      let(:with_creation_date) do
        [255, 216, # JPEG SOI
        [255, 225], [0, 73], # APP1 marker and size
        [69, 120, 105, 102, 0, 0], # Exif\0\0 marker
        [77, 77], [0, 42], # Exif big endian header
        [0, 0, 0, 8], [0, 1], # IFD0 offset and tag count
        [135, 105], [0, 4], [0, 0, 0, 4], [0, 0, 0, 26],
        [0, 0, 0, 0], #No next IFD marker
        [0, 1], #Number of IFD tags
        [144, 3], [0, 2], [0, 0, 0, 19], [0, 0, 0, 44], #Creation Date Tag
        [0, 0, 0, 0], # No next IFD marker
        [50, 48, 49, 56, 58, 48, 49, 58, 50, 48, 32, 49, 50, 58, 48, 48, 58, 48, 48], #Creation Date Value
        [255, 217]].flatten #JPEG EOI
      end

      it 'finds the creation date' do
        expect(AlmondBackup::ExifFile.new(get_stream(with_creation_date)).creation_date).to eq('2018:01:20 12:00:00')
      end
    end
  end
end
