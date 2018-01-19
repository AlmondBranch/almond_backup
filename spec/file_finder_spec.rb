require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'

def create_directory(full_dir_path)
  let(:base_directory) { full_dir_path }

  before :example do
    FileUtils.mkdir_p(base_directory)
  end
end

def create_file(file_name)
  before :example do
    FileUtils.touch File.join(base_directory, file_name)
  end
end

RSpec.describe AlmondBackup::FileFinder do
  describe "#find" do
    include FakeFS::SpecHelpers

    shared_examples 'finds a single matching file' do |file|
      create_file file

      it 'finds that file' do
        files = subject.find(base_directory, file_extensions)
        expect(files).to eq([File.join(base_directory, file)])
      end
    end

    context 'when searching for a single file extension' do
      create_directory '/base'

      context 'that is lower case' do
        let(:file_extensions) { '.jpg' }

        context 'and a single file with an identical extension exists' do
          include_examples 'finds a single matching file', 'test.jpg'
        end
        
        context 'and a single file with an extension differing only by case exists' do
          include_examples 'finds a single matching file', 'test.JPG'
        end
      end

      context 'that is upper case' do
        let(:file_extensions) { '.JPG' }

        context 'and a single file with an identical extension exists' do
          include_examples 'finds a single matching file', 'test.JPG'
        end
        
        context 'and a single file with an extension differing only by case exists' do
          include_examples 'finds a single matching file', 'test.jpg'
        end
      end
    end
  end
end
