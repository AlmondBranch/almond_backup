require 'fakefs/spec_helpers'
require 'fileutils'
require 'almond_backup/file_finder'

RSpec.describe AlmondBackup::FileFinder do
  let(:file_finder) { AlmondBackup::FileFinder.new }

  describe "#find" do
    include FakeFS::SpecHelpers

    context 'given a root directory to search' do
      let(:base_directory) { '/base_test_dir/' }

      context 'given a .jpg file located directly in the root directory' do
        let(:jpg_file_name) { 'test.jpg' }
            
        it 'finds the .jpg file located directly in the root directory' do
          file_path = File.join(base_directory, jpg_file_name)
          FileUtils.mkdir_p(File.dirname(file_path))
          FileUtils.touch file_path

          jpgs = file_finder.find(base_directory, '.jpg')
          expect(jpgs).to eq([file_path])
        end
      end
    end
  end
end
