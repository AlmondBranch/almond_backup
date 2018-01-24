require 'almond_backup/file_sorter_factory'

RSpec.describe AlmondBackup::FileSorterFactory do
  describe ".for" do
    it 'does not return nil' do
      expect(AlmondBackup::FileSorterFactory.for('/some/path')).not_to eq(nil)
    end
  end
end
