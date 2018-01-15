require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'

def create_file(rel_file_path)
  var_name = "#{File.basename(rel_file_path).gsub('.','_')}_path"
  let(var_name) { File.join(base_directory, rel_file_path) }

  before :example do
    FileUtils.mkdir_p(File.dirname(eval(var_name)))
    FileUtils.touch eval(var_name)
  end
end

RSpec.describe AlmondBackup::FileFinder do

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'given a root directory to search' do
      let(:base_directory) { '/base_test_dir/' }

      context 'given a .jpg file located directly in the root directory' do
        create_file 'test.jpg'
            
        it 'finds the .jpg file located directly in the root directory' do
          jpgs = subject.find(base_directory, '.jpg')
          expect(jpgs).to eq([test_jpg_path])
        end

        context 'given a .txt file located directly in the root directory' do
          let(:txt_rel_path) { 'test.txt' }
          let(:txt_path) { File.join(base_directory, txt_rel_path) }

          before :example do
            FileUtils.mkdir_p(File.dirname(txt_path))
            FileUtils.touch txt_path
          end

          it 'finds only the .jpg file located directly in the root directory' do
            jpgs = subject.find(base_directory, '.jpg')
            expect(jpgs).to eq([test_jpg_path])
          end
        end
      end
    end
  end
end
