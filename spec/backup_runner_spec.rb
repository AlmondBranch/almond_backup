require 'almond_backup/backup_runner'
require 'almond_backup/file_finder'
require 'fakefs/spec_helpers'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::BackupRunner do
  extend AlmondBranch::Test::FileSystem
  include FakeFS::SpecHelpers

  let(:backup_runner) { AlmondBackup::BackupRunner.new(AlmondBackup::FileFinder.new) }

  describe '#run_backup' do
    context 'when the destination folder exists' do
      create_directory '/dest'

      it 'throws an exception because the source folder does not exist' do
        expect { backup_runner.run_backup('/source', '/dest', '.jpg') }.to raise_error(ArgumentError)
      end
    end

    context 'when the source folder exists' do
      create_directory '/source'

      it 'throws an exception because the destination folder does not exist' do
        expect { backup_runner.run_backup('/source', '/dest', '.jpg') }.to raise_error(ArgumentError)
      end
    end

    context 'when the source and destination folder exist and are the same' do
      create_directory '/source'

      it 'throws an exception because the folders are the same' do
        expect { backup_runner.run_backup('/source', '/source', '.jpg') }.to raise_error(StandardError)
      end
    end

    context 'when the destination folder is a subfolder of the source folder' do
      create_directory '/source'
      create_directory '/source/dest'

      it 'throws an exception because the destination is a sub folder of the source' do
        expect { backup_runner.run_backup('/source', '/source/dest', '.jpg') }.to raise_error(StandardError)
      end
    end

    context 'when there is a file created in Januray 2018' do
      create_directory '/source'
      create_directory '/destination'
      create_file '/source/test.jpg'

      let(:jpg_contents) do
        [255, 216, # JPEG SOI
         [255, 225], [0, 73], # APP1 marker and size
         [69, 120, 105, 102, 0, 0], # Exif\0\0 marker
         [77, 77], [0, 42], # Exif big endian header
         [0, 0, 0, 8], [0, 1], # IFD0 offset and tag count
         [135, 105], [0, 4], [0, 0, 0, 4], [0, 0, 0, 26],
         [0, 0, 0, 0], # No next IFD marker
         [0, 1], # Number of IFD tags
         [144, 3], [0, 2], [0, 0, 0, 19], [0, 0, 0, 44], # Creation Date Tag
         [0, 0, 0, 0], # No next IFD marker
         [50, 48, 49, 56, 58, 48, 49, 58, 50, 48, 32, 49, 50, 58, 48, 48, 58, 48, 48], # Creation Date Value '2018:01:20 12:00:00'
         [255, 217]].flatten # JPEG EOI
      end

      before :example do
        File.open('/source/test.jpg', 'w') do |output|
          jpg_contents.each do |byte|
            output.print byte.chr
          end
        end
      end

      it 'backups up the single file in the 2018_01 folder' do
        backup_runner.run_backup('/source', '/destination', '.jpg')
        expect(File.file?('/destination/2018_01/test Backup_1.jpg'))
      end
    end
  end
end
