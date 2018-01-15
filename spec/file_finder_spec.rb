require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'

def create_directory(directory, var_name)
  let(var_name) { directory }

  before :example do
    FileUtils.mkdir_p(eval(var_name.to_s))
  end
end

def create_file(rel_file_path)
  var_name = "#{File.basename(rel_file_path).gsub('.','_')}_path"
  let(var_name.to_sym) { File.join(base_directory, rel_file_path) }

  before :example do
    FileUtils.touch eval(var_name)
  end
end

RSpec.describe AlmondBackup::FileFinder do

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'given a root directory to search' do
      create_directory '/base_test_dir/', :base_directory

      context 'given a .jpg file located directly in the root directory' do
        create_file 'test.jpg'
            
        it 'finds the .jpg file located directly in the root directory' do
          jpgs = subject.find(base_directory, '.jpg')
          expect(jpgs).to eq(['/base_test_dir/test.jpg'])
        end

        context 'given a .txt file located directly in the root directory' do
          create_file 'test.txt'

          it 'finds only the .jpg file located directly in the root directory' do
            jpgs = subject.find(base_directory, '.jpg')
            expect(jpgs).to eq(['/base_test_dir/test.jpg'])
          end
        end
      end
    end
  end
end
