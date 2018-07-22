require 'fakefs/spec_helpers'
require 'almond_backup/backup_runner'
require 'almond_backup/file_finder'
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

      context 'and there are no other files backed up in that folder yet' do
        it 'backups up the single file in the 2018_01 folder' do
          backup_runner.run_backup('/source', '/destination', '.jpg')
          expect(File.file?('/destination/2018_01/test.jpg')).to be true
        end
      end

      context 'and there is a second file with the same creation date and the same name in a subfolder' do
        create_file '/source/subfolder/test.jpg'

        before :example do
          File.open('/source/subfolder/test.jpg', 'w') do |output|
            jpg_contents.each do |byte|
              output.print byte.chr
            end
          end
        end

        it 'backs adds a backup number to one of the file names so that they are both backed up' do
          backup_runner.run_backup('/source', '/destination', '.jpg')

          expect(File.file?('/destination/2018_01/test.jpg')).to be true
          expect(File.file?('/destination/2018_01/test Backup_1.jpg')).to be true
        end
      end
    end

    context 'when there is a file that does not have an origin date' do
      create_directory '/source'
      create_directory '/destination'
      create_file '/source/test.mov'

      let(:mov_contents) do
        [[0, 0, 0, 24], # Box size
         [109, 111, 111, 118], # Box type of moov
         [0, 0, 0, 16], # Size
         [109, 118, 104, 100], # Box type of mvhd
         [2], # Version
         [0, 0, 0], # Flags
         [210, 234, 90, 151]].flatten # creation time of 2016-02-17 17:12:55
      end

      before :example do
        File.open('/source/test.mov', 'w') do |output|
          mov_contents.each do |byte|
            output.print byte.chr
          end
        end
      end

      it 'backs up the file directly into the destination folder' do
        backup_runner.run_backup('/source', '/destination', '.mov')
        expect(File.file?('/destination/test.mov'))
      end
    end
  end
end
