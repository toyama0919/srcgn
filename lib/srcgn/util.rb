module Srcgn
  class Util
    class << self
      def paths_with_globs(globs)
        globs.map { |glob|
          Dir.glob(glob)
        }.flatten.uniq
      end
    end
  end
end
