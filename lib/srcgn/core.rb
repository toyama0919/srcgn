require 'logger'
require 'parallel'
require "google/cloud/speech"

module Srcgn
  class Core
    def initialize
      @log = Logger.new(STDOUT)
      @speech = Google::Cloud::Speech.new
    end

    def convert_flac(mp3_files)
      mp3_files.map do |mp3_file|
        stat = File.stat(mp3_file)
        splitted = if (stat.size > SPLIT_SIZE) && File::extname(mp3_file) == '.mp3'
          Mp3splt.split_mp3(mp3_file, 'splitted', (stat.size/SPLIT_SIZE) + 1)
        else
          [mp3_file]
        end
        splitted.map do |m|
          flac_file = m.gsub(/#{File::extname(m)}$/, '.flac')
          @log.info("converting flac.. [#{m}] => [#{flac_file}]")
          Sox.convert_mp3_to_flac(m, flac_file)
        end
      end
    end

    def recognize_parallel(config, flac_files, max_alternatives, format)
      Parallel.map(flac_files, :in_processes=>Parallel.processor_count) do |f|
        begin
          output = f.gsub(/#{File::extname(f)}$/, ".#{format}")
          if File.exist?(output) && options[:output] == 'file'
            @log.warn("exist output file. skip recognize [#{f}] => [#{output}]")
            next
          end

          audio  = @speech.audio f, config
          job = audio.recognize_job(max_alternatives: max_alternatives)
          @log.info("recognize.. [#{f}] => [#{output}]")
          job.wait_until_done!
          yield(output, job.results) if block_given?
        rescue => e
          @log.error("[#{f}] #{e.message}\n#{e.backtrace.join("\n")}")
        end
      end
    end

    def get_config(encoding: :flac, sample_rate: SAMPLE_RATE, language: :en, max_alternatives: nil)
      config = {
        language: language,
        encoding: encoding,
        sample_rate: sample_rate
      }
      @log.info("config => #{config}")
      config
    end
  end
end
