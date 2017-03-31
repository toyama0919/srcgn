module Srcgn
  class Mp3splt
    class << self
      def split_mp3(mp3_file, output_dir, split_size)
        command = [
          MP3SPLT,
          '-d',
          output_dir,
          '-S',
          split_size.to_s,
          mp3_file
        ]
        system(*command)
        Dir.glob(output_dir + '/' + File::basename(mp3_file, '.*') + '*.mp3')
      end
    end
  end
end
