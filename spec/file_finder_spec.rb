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

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'given a root directory to search for .jpg files' do
      create_directory '/base_test_dir/'

      context 'having a file test.jpg' do
        create_file 'test.jpg'
            
        it 'finds test.jpg' do
          jpgs = subject.find(base_directory, '.jpg')
          expect(jpgs).to eq(['/base_test_dir/test.jpg'])
        end

        context 'and having a file test.txt' do
          create_file 'test.txt'

          it 'finds test.jpg and not test.txt' do
            jpgs = subject.find(base_directory, '.jpg')
            expect(jpgs).to eq(['/base_test_dir/test.jpg'])
          end
        end
      end
      
      context 'having a file test.JPG' do
        create_file 'test.JPG'

        it 'finds test.JPG' do
          jpgs = subject.find(base_directory, '.jpg')
          expect(jpgs).to eq(['/base_test_dir/test.JPG'])
        end
      end
    end
  end
end
