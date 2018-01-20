module AlmondBranch
  module Test
    module FileSystem
      def create_directory(path)
        before :example do
          FileUtils.mkdir_p(path)
        end
      end

      def create_file(file_path)
        create_directory(File.dirname(file_path))

        before :example do
          FileUtils.touch file_path
        end
      end
    end
  end
end
