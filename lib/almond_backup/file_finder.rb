module AlmondBackup
  # Locates all files with the given extensions in a directory recursively
  class FileFinder
    def find(root_dir, *extensions)
      extensions = extensions.map(&:downcase)
      Dir.glob(File.join(root_dir, '**', '*.*'))
         .select { |f| extensions.include?(File.extname(f).downcase) }
    end
  end
end
