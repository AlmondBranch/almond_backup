require 'almond_backup'

Shoes.app width: 320, height: 620 do
  stack margin: 40 do
    stack margin: 10 do
      para 'Source Folder'
      @source = edit_line
    end

    stack margin: 10 do
      para 'Destination Folder'
      @destination = edit_line
    end

    stack margin: 10 do
      button 'Run Backup' do
        begin
        runner = AlmondBackup::BackupRunner.new(AlmondBackup::FileFinder.new)
        runner.run_backup(@source.text, @destination.text, '.m4v', '.m4a', '.jpg', '.mov')
        rescue Exception => e
          @details.text = e.to_s
        end
      end
    end

    stack margin: 10 do
      para 'Exception Details'
      @details = edit_box
      @details.height = 300
    end
  end
end