require 'fakefs/spec_helpers'
require 'almond_backup/backup_source'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::BackupSource do
  extend AlmondBranch::Test::FileSystem
  include FakeFS::SpecHelpers

  let(:backup_source) { AlmondBackup::BackupSource.new(folder_path) }
  let(:folder_path) { nil }

  describe "#backup_source" do
    let (:folder_path) { '/backup' }
    create_directory '/backup'
    create_file '/other/tobackup.txt'

    it 'backs up the file' do
      backup_source.backup_file('/other/tobackup.txt', 'txt_files')
      expect(File.exist?('/backup/txt_files/tobackup Backup_1.txt')).to eq(true)
    end
  end
end
