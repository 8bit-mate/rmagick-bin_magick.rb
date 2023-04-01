# frozen_string_literal: true

module Magick
  module BinMagick
    N_GRAY_COLORS = 64 # Default number of gray tones when image is being quantized to a grayscale.

    #
    # Image instance methods.
    #
    class Image < MagickWrapper
      #
      # Check if the image has at least one black pixel.
      #
      # @return [Boolean]
      #
      def black_px?
        colors = color_histogram
        colors = colors.transform_keys(&:to_color)

        colors.key?("black")
      end

      #
      # Crop border around the image. If the image is blank: return an unedited copy of the target image.
      #
      # @return [BinMagick::Image]
      #   A cropped image.
      #
      def crop_border
        return copy unless black_px?

        bb = bounding_box

        crop(
          bb.x,
          bb.y,
          bb.width,
          bb.height
        )
      end

      #
      # A bang version of the 'BinMagick::Image#crop_border'.
      #
      def crop_border!
        cropped_img = crop_border
        _replace_pixels(cropped_img)

        self
      end

      #
      # Crop border around the image, but treat a color image like it is already a binary one.
      #
      # See also: 'BinMagick::Image#to_binary' method description.
      #
      # @return [BinMagick::Image]
      #   A cropped image.
      #
      def crop_border_clr(...)
        bin_img = to_binary(...)

        return copy unless bin_img.black_px?

        bb = bin_img.bounding_box

        crop(
          bb.x,
          bb.y,
          bb.width,
          bb.height
        )
      end

      #
      # A bang version of the 'BinMagick::Image#crop_border_clr'.
      #
      def crop_border_clr!(...)
        cropped_img = crop_border_clr(...)
        _replace_pixels(cropped_img)

        self
      end

      #
      # Workaround for the 'Magick::Image#display' method.
      #
      def display
        pixels = @image.dispatch(0, 0, columns, rows, "RGB")
        img = Magick::Image.constitute(columns, rows, "RGB", pixels)
        img.display

        self
      end

      #
      # A bang version of the 'Magick::Image#extent'.
      #
      # @param [Integer] width
      #
      # @param [Integer] height
      #
      # @option [Integer] x (0)
      #
      # @option [Integer] y (0)
      #
      def extent!(width, height, x = 0, y = 0)
        extended_img = @image.extent(width, height, x, y)
        _replace_pixels(extended_img)

        self
      end

      #
      # Scale the image to fit into the size limits *IF* it oversize them.
      #
      # @param [Integer] max_width
      #
      # @param [Integer] max_height
      #
      # @return [BinMagick::Image]
      #   A resized image.
      #
      def fit_to_size(max_width, max_height)
        oversize?(max_width, max_height) ? resize_to_fit(max_width, max_height) : copy
      end

      #
      # A bang version of the 'BinMagick::Image#fit_to_size'.
      #
      def fit_to_size!(...)
        new_img = fit_to_size(...)
        _replace_pixels(new_img)

        self
      end

      #
      # A bang version of the 'Magick::Image#level2'.
      #
      # Note: The 'Magick::Image#level2' method is exactly the same as 'Magick::Image#level' except that it never
      # swaps the arguments.
      #
      def level!(black_point = 0.0, white_point = Magick::QuantumRange, gamma = 1.0)
        new_img = @image.level2(black_point, white_point, gamma)
        _replace_pixels(new_img)

        self
      end

      #
      # A bang version of the 'Magick::Image#ordered_dither'.
      #
      def ordered_dither!(threshold_map = "checks")
        new_img = @image.ordered_dither(threshold_map)
        _replace_pixels(new_img)

        self
      end

      #
      # Check if the image dimensions are larger than the provided height OR width.
      #
      # @return [Boolean]
      #
      def oversize?(max_width, max_height)
        columns > max_width || rows > max_height
      end

      #
      # A bang version of the 'Magick::Image#quantize'.
      #
      def quantize!(
        number_colors = N_GRAY_COLORS,
        colorspace = Magick::GRAYColorspace,
        dither = Magick::NoDitherMethod,
        tree_depth = 0,
        measure_error = false
      )
        new_img = @image.quantize(number_colors, colorspace, dither, tree_depth, measure_error)
        _replace_pixels(new_img)

        self
      end

      #
      # Convert a color image to a binary image.
      #
      # @option [Integer] n_gray_colors (N_GRAY_COLORS)
      #   Number of grayscale colors when image is being quantized.
      #
      # @option [Magick::DitherMethod] quantize_dither (Magick::NoDitherMethod)
      #   Error diffusion dither that will be applied on the color reduction step.
      #
      # @option [String] threshold_map ("checks")
      #   Dither pattern for convertion from grayscale to binary.
      #
      # @return [BinMagick::Image]
      #   Binary version of the image.
      #
      def to_binary(n_gray_colors = N_GRAY_COLORS, quantize_dither = Magick::NoDitherMethod, threshold_map = "checks")
        grayscale_img = quantize(n_gray_colors, Magick::GRAYColorspace, quantize_dither)
        grayscale_img.ordered_dither(threshold_map)
      end

      #
      # A bang version of the 'BinMagick::Image#to_binary'.
      #
      def to_binary!(...)
        bin_img = to_binary(...)
        _replace_pixels(bin_img)

        self
      end

      private

      #
      # Replace pixels in the target image with pixels from the image 'img' that is a result of a BinMagick::Image or
      # a Magick::Image instance method call.
      #
      # Method used to create bang versions of the existing Magick::Image methods that do not have a bang version.
      #
      # @param [Magick::Image] img
      #
      def _replace_pixels(img)
        pixels = img.dispatch(0, 0, img.columns, img.rows, "RGB")
        @image = Magick::Image.constitute(img.columns, img.rows, "RGB", pixels)
      end
    end
  end
end
