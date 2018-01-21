require 'almond_backup/file_to_backup'

RSpec.describe AlmondBackup::FileToBackup do

  describe "#backup_folder" do

    context 'given an file created in June 2017' do
      
      it 'has the backup folder \'2017_06\'' do
        file = double()
        allow(file).to receive(:creation_date).and_return('2017:06:01 12:00:00')

        ftb = AlmondBackup::FileToBackup.new(file)
        expect(ftb.backup_folder).to eq('2017_06')
      end 
    end
  end
end
