module AlmondBranch
  module Test
    module FileSystem
      def create_directory(full_dir_path)
        let(:base_directory) { full_dir_path }

        before :example do
        FileUtils.mkdir_p(base_directory)
      end
    end

      def create_file(file_name)
        before :example do
          FileUtils.touch File.join(base_directory, file_name)
        end
      end
    end
  end
end
