require 'paperclip'
module Paperclip
  class Ffmpeg < Processor
    attr_accessor :geometry, :format, :whiny, :convert_options

    # Creates a Video object set to work on the +file+ given. It
    # will attempt to transcode the video into one defined by +target_geometry+
    # which is a "WxH"-style string. +format+ should be specified.
    # Video transcoding will raise no errors unless
    # +whiny+ is true (which it is, by default. If +convert_options+ is
    # set, the options will be appended to the convert command upon video transcoding.
    def initialize file, options = {}, attachment = nil
      @convert_options = {
        :input => {},
        :output => { :y => nil }
      }
      unless options[:convert_options].nil? || options[:convert_options].class != Hash
        unless options[:convert_options][:input].nil? || options[:convert_options][:input].class != Hash
          @convert_options[:input].reverse_merge! options[:convert_options][:input]
        end
        unless options[:convert_options][:output].nil? || options[:convert_options][:output].class != Hash
          @convert_options[:output].reverse_merge! options[:convert_options][:output]
        end
      end
      
      @file            = file

      @whiny           = options[:whiny].nil? ? true : options[:whiny]
      @format          = options[:format]
      @time            = options[:time].nil? ? 3 : options[:time]
      @current_format  = File.extname(@file.path)
      @basename        = File.basename(@file.path, @current_format)
    end
    # Performs the transcoding of the +file+ into a thumbnail/video. Returns the Tempfile
    # that contains the new image/video.
    def make
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode
      

      parameters = []
      
      # Add source
      parameters << @convert_options[:input].map { |k,v| "-#{k.to_s} #{v} "}
      parameters << "-f --quiet :source"
      parameters << @convert_options[:output].map { |k,v| "-#{k.to_s} #{v} "}
      parameters << ":dest"

      parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")
      
      Paperclip.log("[lame] #{parameters}")
      begin
        success = Paperclip.run("lame", parameters, :source => "#{File.expand_path(src.path)}", :dest => File.expand_path(dst.path))
      rescue Cocaine::ExitStatusError => e
        raise PaperclipError, "error while processing video for #{@basename}: #{e}" if @whiny
      end

      dst
    end
  end
end