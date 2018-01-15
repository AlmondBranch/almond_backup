module AlmondBackup
  class FileFinder
    def find(root_dir, *extensions)
      extensions = extensions.map { |ext| ext.downcase }
      Dir.glob(File.join(root_dir, '**', '*.*'))
        .select { |f| extensions.include?(File.extname(f).downcase) }
    end
  end
end
