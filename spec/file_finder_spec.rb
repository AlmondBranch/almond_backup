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
  var_name = "#{file_name.gsub('.','_')}_path"
  let(var_name.to_sym) { File.join(base_directory, file_name) }

  before :example do
    FileUtils.touch eval(var_name)
  end
end

RSpec.describe AlmondBackup::FileFinder do

  shared_examples_for 'search for files' do |extension|
create_directory '/base_test_dir/'

      context 'having a file test.jpg' do
        create_file 'test.jpg'
            
        it 'finds test.jpg' do
          jpgs = subject.find(base_directory, extension)
          expect(jpgs).to eq(['/base_test_dir/test.jpg'])
        end

        context 'and having a file test.txt' do
          create_file 'test.txt'

          it 'finds test.jpg and not test.txt' do
            jpgs = subject.find(base_directory, extension)
            expect(jpgs).to eq(['/base_test_dir/test.jpg'])
          end
        end
      end
      
      context 'having a file test.JPG' do
        create_file 'test.JPG'

        it 'finds test.JPG' do
          jpgs = subject.find(base_directory, extension)
          expect(jpgs).to eq(['/base_test_dir/test.JPG'])
        end
      end
  end

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'given a root directory to search for .jpg files' do
      it_behaves_like 'search for files', '.jpg'
    end

    context 'given a root directory to search for .JPG files' do
      it_behaves_like 'search for files', '.JPG'
    end
  end
end
