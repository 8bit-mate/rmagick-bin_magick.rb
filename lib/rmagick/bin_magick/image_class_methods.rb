# frozen_string_literal: true

module Magick
  module BinMagick
    #
    # Image class methods.
    #
    class Image < MagickWrapper
      #
      # Read image from a file.
      #
      # @param [String] filename
      #
      # @return [BinMagick::Image]
      #
      # @raise [BinMagick::IOError]
      #
      def self.from_file(filename)
        image = Magick::Image.read(filename).first
        new(image)
      rescue Magick::ImageMagickError => e
        raise BinMagick::IOError, "Error occurred while reading image from file: #{e.message}"
      end
    end
  end
end
