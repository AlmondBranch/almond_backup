require 'almond_backup/backup_runner'
require 'almond_backup/file_finder'
require 'fakefs/spec_helpers'
require 'support/file_system_spec_utils'

RSpec.describe AlmondBackup::BackupRunner do
  extend AlmondBranch::Test::FileSystem
  include FakeFS::SpecHelpers

  let(:backup_runner) { AlmondBackup::BackupRunner.new(AlmondBackup::FileFinder.new) }

  describe "#run_backup" do
    context 'when the destination folder exists' do
      create_directory '/dest'

      it 'throws an exception because the source folder does not exist' do
        expect { backup_runner.run_backup('/source', '/dest', '.jpg') }.to raise_error
      end
    end

    context 'when the source folder exists' do
      create_directory '/source'

      it 'throws an exception because the destination folder does not exist' do
        expect { backup_runner.run_backup('/source', '/dest', '.jpg') }.to raise_error
      end
    end
  end
end
