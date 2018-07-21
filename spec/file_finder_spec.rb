require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::FileFinder do
  extend AlmondBranch::Test::FileSystem

  describe '#find' do
    include FakeFS::SpecHelpers

    context 'when a matching file exists in a subdirectory' do
      create_file '/base/sub/test.jpg'

      it 'finds the file' do
        files = subject.find('/base', '.jpg')
        expect(files).to eq(['/base/sub/test.jpg'])
      end
    end

    context 'when a file not being searched for exists' do
      create_file '/base/test.png'

      it 'does not find the file' do
        files = subject.find('/base', '.jpg')
        expect(files).to be_empty
      end
    end

    context 'when an upper case file extension is being searched for' do
      let(:file_extensions) { '.JPG' }

      context 'and a file with an identical extension exists' do
        create_file '/base/test.JPG'

        it 'finds the file' do
          files = subject.find('/base', file_extensions)
          expect(files).to eq(['/base/test.JPG'])
        end
      end

      context 'and a file with an extension differing only by case exists' do
        create_file '/base/test.jpg'

        it 'finds the file' do
          files = subject.find('/base', file_extensions)
          expect(files).to eq(['/base/test.jpg'])
        end
      end
    end

    context 'when a lower case file extension is being searched for' do
      let(:file_extensions) { '.jpg' }

      context 'and a file with an identical extension exists' do
        create_file '/base/test.jpg'

        it 'finds the file' do
          files = subject.find('/base', file_extensions)
          expect(files).to eq(['/base/test.jpg'])
        end
      end

      context 'and a file with an extension differing only by case exists' do
        create_file '/base/test.JPG'

        it 'finds the file' do
          files = subject.find('/base', file_extensions)
          expect(files).to eq(['/base/test.JPG'])
        end
      end
    end

    context 'when searching for multiple file extensions' do
      context 'and a single matching file exists for each extension' do
        create_file '/base/sub/test.jpg'
        create_file '/base/sub/sub/test.TXT'
        create_file '/base/test.png'

        it 'finds the files' do
          files = subject.find('/base', '.jpg', '.txt')
          expect(files).to contain_exactly('/base/sub/test.jpg', '/base/sub/sub/test.TXT')
        end
      end
    end

    context 'when searching for a single file extension' do
      context 'and a single matching file exists' do
        create_file '/base/sub/test.txt'
        create_file '/base/sub/test.jpg'

        it 'finds the file' do
          files = subject.find('/base', '.JPG')
          expect(files).to eq(['/base/sub/test.jpg'])
        end
      end
    end
  end
end
