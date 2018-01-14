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
        let(:jpg_rel_path) { 'test.jpg' }
        let(:jpg_path) { File.join(base_directory, jpg_rel_path) }

        before :example do
          FileUtils.mkdir_p(File.dirname(jpg_path))
          FileUtils.touch jpg_path
        end
            
        it 'finds the .jpg file located directly in the root directory' do
          jpgs = file_finder.find(base_directory, '.jpg')
          expect(jpgs).to eq([jpg_path])
        end

        context 'given a .txt file located directly in the root directory' do
          let(:txt_rel_path) { 'test.txt' }
          let(:txt_path) { File.join(base_directory, txt_rel_path) }

          before :example do
            FileUtils.mkdir_p(File.dirname(txt_path))
            FileUtils.touch txt_path
          end

          it 'finds only the .jpg file located directly in the root directory' do
            jpgs = file_finder.find(base_directory, '.jpg')
            expect(jpgs).to eq([jpg_path])
          end
        end
      end
    end
  end
end
