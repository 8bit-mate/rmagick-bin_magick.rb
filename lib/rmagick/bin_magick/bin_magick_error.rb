# frozen_string_literal: true

module Magick
  module BinMagick
    #
    # Base error class.
    #
    class BinMagickError < ::StandardError
      attr_reader :message

      def initialize(message)
        @message = message
        super
      end
    end

    #
    # Raises on an I/O operation fail.
    #
    class IOError < BinMagickError
      attr_reader :message

      def initialize(message)
        @message = message
        super
      end
    end

    #
    # Raises when an Magick::BinMagick::Image instance is being initialized with a destroyed image.
    #
    class DestroyedImageError < BinMagickError
      attr_reader :message

      def initialize(message)
        @message = message
        super
      end
    end
  end
end
