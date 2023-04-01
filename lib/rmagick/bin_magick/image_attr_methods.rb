# frozen_string_literal: true

require_relative "magick_wrapper"

module Magick
  module BinMagick
    #
    # Image attribute methods.
    #
    class Image < MagickWrapper
      #
      # Return image height.
      #
      # @return [Integer]
      #
      def height
        rows
      end

      #
      # Return image width.
      #
      # @return [Integer]
      #
      def width
        columns
      end
    end
  end
end
