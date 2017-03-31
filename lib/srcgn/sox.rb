module Srcgn
  class Sox
    class << self
      def convert_mp3_to_flac(mp3_file, flac_file)
        command = [
          SOX,
          mp3_file,
          '--rate',
          '16k',
          '--bits',
          '16',
          '--channels',
          '1',
          flac_file
        ]
        system(*command)
        flac_file
      end
    end
  end
end
