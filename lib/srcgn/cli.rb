require "thor"
require "logger"

module Srcgn
  class CLI < Thor

    include Thor::Actions
    map '-r' => :recognize
    default_task :recognize

    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @class_options = config[:shell].base.options
      @log = Logger.new(STDERR)
      @core = Core.new
    end

    desc "recognize", "recognize"
    option :language, aliases: '-l', type: :string, desc: 'language'
    option :max_alternatives, aliases: '--max_alternatives', type: :numeric, desc: 'max_alternatives'
    option :flac_files, aliases: '-f', type: :array, default: [], desc: 'flac file'
    option :mp3_files, aliases: '-m', type: :array, default: [], desc: 'mp3 file'
    option :format, type: :string, default: 'txt', enum: ['json', 'txt'],desc: 'mp3 file'
    option :output, aliases: '-o', type: :string, default: 'stdout', enum: ['stdout', 'file'],desc: 'output'
    def recognize
      mp3_files = Util.paths_with_globs(options[:mp3_files])
      flac_files = Util.paths_with_globs(options[:flac_files])

      if flac_files.empty? && !mp3_files.empty?
        flac_files = @core.convert_flac(mp3_files)
      end

      config = @core.get_config(
        language: options[:language]
      )
      @log.info("config => #{config}")
      @core.recognize_parallel(config, flac_files.flatten, options[:max_alternatives], options[:format]) { |output, results|
        output_proc(output, results)
      }
    end

    private

    def output_proc(file_path, results)
      buf = if options[:format] == 'json'
        Oj.dump(results, mode: :compat, indent: 2)
      elsif options[:format] == 'txt'
        lines = results.map do |result|
          result.transcript
        end
        lines.join("\n")
      end

      if options[:output] == 'stdout'
        puts buf
      elsif options[:output] == 'file'
        File.write(file_path, buf)
      end
    end
  end
end
