# frozen_string_literal: true

module Magick
  module BinMagick
    #
    # A wrapper around the "Magick::Image" class, providing a dynamic interface for forwarding method calls to the
    # underlying "Magick::Image" object. When a method is called on "MagickWrapper", it first checks if the
    # underlying "Magick::Image" object responds to that method, and if so, it invokes the method on the object and
    # returns the result.
    #
    # If the result is another "Magick::Image" object, it wraps it in a new "MagickWrapper" object, allowing chaining
    # of method calls.
    #
    # If the result is not a "Magick::Image" object, it returns the result as is.
    #
    # If the underlying "Magick::Image" object does not respond to the method, it raises a "NoMethodError".
    #
    class MagickWrapper
      attr_reader :image

      def initialize(image)
        raise BinMagick::DestroyedImageError, "Destroyed image" if image.destroyed?

        @image = image
      end

      def method_missing(method_name, *args, &block)
        if @image.respond_to?(method_name)
          result = @image.send(method_name, *args, &block)
          if result.is_a?(Magick::Image)
            self.class.new(result)
          else
            result
          end
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @image.respond_to?(method_name) || super
      end
    end
  end
end
