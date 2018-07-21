require 'fakefs/spec_helpers'
require 'almond_backup/backup_folder'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::BackupFolder do
  extend AlmondBranch::Test::FileSystem
  include FakeFS::SpecHelpers

  let(:backup_folder) { AlmondBackup::BackupFolder.new(folder_path) }
  let(:folder_path) { nil }

  describe '#get_backup_number' do
    context 'when a backup number is specified' do
      let(:file_name) { 'test Backup_02.txt' }

      it 'returns the backup number' do
        expect(backup_folder.get_backup_number(file_name)).to eq(2)
      end
    end

    context 'when a backup number is not specified' do
      let(:file_name) { 'test.txt' }

      it 'returns 0' do
        expect(backup_folder.get_backup_number(file_name)).to eq(0)
      end
    end
  end

  describe '#add_backup_number' do
    example 'adding a backup number of 2 to test.txt' do
      result = backup_folder.add_backup_number('test.txt', 2)
      expect(result).to eq('test Backup_2.txt')
    end
  end

  describe '#get_hashes' do
    context 'given a folder' do
      let(:folder_path) { '/base' }
      create_directory '/base'

      context 'with two files that do not have backup numbers' do
        create_file '/base/file1.txt'
        create_file '/base/file2.txt'

        it 'returns two hashes' do
          expect(backup_folder.hashes.size).to eq(2)
        end
      end
    end
  end

  describe '#get_max_num' do
    context 'given a folder' do
      let(:folder_path) { '/base' }
      create_directory '/base'

      context 'with two files that do not have backup numbers' do
        create_file '/base/file1.txt'
        create_file '/base/file2.txt'

        it 'returns a max num of 0' do
          expect(backup_folder.max_num).to eq(0)
        end
      end
    end
  end

  describe '#add_file' do
    let(:folder_path) { '/base' }
    create_directory '/base'
    create_file '/other/tobackup.txt'

    it 'backs up the file' do
      backup_folder.add_file('/other/tobackup.txt')
      expect(File.exist?('/base/tobackup.txt')).to eq(true)
    end

    describe 'when a file with the same name already is backed up' do
      create_file '/base/tobackup.txt'

      it 'adds a unique suffix to the end of the backed up file name' do
        backup_folder.add_file('/other/tobackup.txt')
        expect(File.exist?('/base/tobackup Backup_1'))
      end
    end

    it 'incrememts the max num' do
      backup_folder.add_file('/other/tobackup.txt')
      expect(backup_folder.max_num).to eq(1)
    end
  end
end
