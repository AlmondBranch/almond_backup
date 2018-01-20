require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::FileFinder do
  extend AlmondBranch::Test::FileSystem

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'when searching for a single file extension' do
      context 'that is lower case' do
        let(:file_extensions) { '.jpg' }

        context 'and a single file with an identical extension exists' do
          create_file '/base/test.jpg'

          it 'finds the file' do
            files = subject.find('/base', file_extensions)
            expect(files).to eq(['/base/test.jpg'])
          end
        end
        
        context 'and a single file with an extension differing only by case exists' do
          create_file '/base/test.JPG'

          it 'finds the file' do
            files = subject.find('/base', file_extensions)
            expect(files).to eq(['/base/test.JPG'])
          end
        end
      end

      context 'that is upper case' do
        let(:file_extensions) { '.JPG' }

        context 'and a single file with an identical extension exists' do
          create_file '/base/test.JPG'

          it 'finds the file' do
            files = subject.find('/base', file_extensions)
            expect(files).to eq(['/base/test.JPG'])
          end
        end
        
        context 'and a single file with an extension differing only by case exists' do
          create_file '/base/test.jpg'

          it 'finds the file' do
            files = subject.find('/base', file_extensions)
            expect(files).to eq(['/base/test.jpg'])
          end
        end
      end
    end

    context 'when searching for multiple file extensions' do
      let(:file_extensions) { ['.txt', '.JPG'] }

      context 'and two files with identical extensions exist' do
        create_file '/base/test.txt'
        create_file '/base/test.JPG'

        it 'finds the files' do
          files = subject.find('/base', *file_extensions)
          expect(files).to contain_exactly('/base/test.txt', '/base/test.JPG')
        end
      end

      context 'and two files with extensions differing only by case exist' do
        create_file '/base/test.TXT'
        create_file '/base/test.jpg'

        it 'finds the files' do
          files = subject.find('/base', *file_extensions)
          expect(files).to contain_exactly('/base/test.TXT', '/base/test.jpg')
        end
      end
    end
  end
end
