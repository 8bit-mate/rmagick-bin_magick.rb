# rmagick/bin_magick

[![Gem Version](https://badge.fury.io/rb/rmagick-bin_magick.svg)](https://badge.fury.io/rb/rmagick-bin_magick)

## Description

**rmagick/bin_magick** is an extension of the popular **[rmagick](https://github.com/rmagick/rmagick)** image processing gem. The extension provides custom methods for easy conversion of color images to binary (monochrome) format. It also introduces in-place versions of some existing *Magick::Image* methods that, by default, lack an in-place version

The *Image* class of bin_magick inherits from the *Magick::Image* class, which allows both *Magick::Image* and *Magick::BinMagick::Image* instance methods to be called on a *BinMagick::Image* object.

bin_magick was developed for the [img_to_MK90_bas](https://github.com/8bit-mate/img_to_MK90_bas.rb) project, which converts images to [Elektronika MK90](https://museum.dataart.com/en/artifacts/portativnaya-evm-elektronika-mk-90) executable BASIC scripts, but it may also be useful for similar applications.

## Prerequisites

- Ruby ver. >= 3.0.0;
- RMagick ver. >= 5.2.0.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rmagick-bin_magick'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bin_magick

## Usage

1. Add **rmagick-bin_magick** to the list of required modules:

  ```ruby
  require "rmagick/bin_magick"
  ```

2. Read an image from a file:

  ```ruby
  image = Magick::BinMagick::Image.from_file("filename.png")
  ```

  Or initialize an instance based on the existing Magick::Image instance:

  ```ruby
  image = Magick::BinMagick::Image.new(magick_image_object)
  ```

3. Call Magick::BinMagick::Image or Magick::Image attribute and instance methods (see the examples section and the reference section for more details).

### Examples

#### Method chaining ####

This example shows how different *Magick::BinMagick::Image* and *Magick::Image* instance methods may be combined in one method call chain:

```ruby
require "rmagick/bin_magick"

# Read an image from a file:
begin
  image = Magick::BinMagick::Image.from_file("./data/test_0.png")
rescue Magick::BinMagick::BinMagickError => e
  puts e.message
  exit
end

image
  .level(0, Magick::QuantumRange * 0.95, 0.4) # Adjust levels (a RMagick method).
  .crop_border_clr # Crop white border (a BinMagick method).
  .fit_to_size!(192, 192) # Resize to fit a 192 x 192 square (a BinMagick method).
  .to_binary(64, Magick::NoDitherMethod, "o2x2") # Convert to binary (a BinMagick method).
  .write("./data/test_0_result.png") # Save result to a file (a RMagick method).
```

The code above will produce the following result:

| Original image | Result image |
| --- | --- |
| ![Alt text](data/test_0.png?raw=true "Original image") | ![Alt text](data/test_0_result.png?raw=true "Result image") |

#### In-place methods usage ####

You can also use in-place methods:

```ruby
require "rmagick/bin_magick"

# Read an image from the file './data/test_1.png'
# ...

# Adjust levels (a BinMagick method):
image.level!(0, Magick::QuantumRange, 0.5)

# Crop white border (a BinMagick method):
image.crop_border_clr!

# Resize to fit a 64 x 64 square (a BinMagick method):
image.fit_to_size!(64, 64)

# Convert to binary (a BinMagick method):
image.to_binary!(16)

# Extent to a 120 x 64 rectangle, put image in the center (a BinMagick method):
x_offset = - (120 / 2 - image.width / 2)
y_offset = - (64 - image.height)
image.extent!(120, 64, x_offset, y_offset)

# Save result to a file (a RMagick method):
image.write("./data/test_1_result.png")
```

The code above will produce the following result:

| Original image | Result image |
| --- | --- |
| ![Alt text](data/test_1.png?raw=true "Original image") | ![Alt text](data/test_1_result.png?raw=true "Result image") |

## Reference

### Class Magick::BinMagick::Image: attribute methods (get only)

- **height**

  *img*.height -> *integer*

  The height of the image in pixels. An alias of the Magick::Image#[rows](https://rmagick.github.io/imageattrs.html#rows).

***

- **width**

  *img*.width -> *integer*

  The width of the image in pixels. An alias of the Magick::Image#[columns](https://rmagick.github.io/imageattrs.html#columns).

***

### Class Magick::BinMagick::Image: class methods

- **from_file**

  Magick::BinMagick::Image.from_file(*filename*) -> *image*

  Reads the first image from the file *filename*.

  **Note**: an image file can contain multiple images or multiple image layers, but the method always returns the first one. To load a specific image from a file (e.g. a specific frame from an animated GIF), you can use the Magick::Image#read method, and then initialize a BinMagick::Image instance with the BinMagick::Image#new method.

  **Arguments**:

  - filename

    An image file name.

  **Returns**: a new image.

***

- **new**

  Magick::BinMagick::Image.new(*magick_image*) -> *image*

  Creates a new Magick::BinMagick::Image instance from a Magick::Image object. The source Magick::Image object should not be a destroyed image, otherwise the Magick::BinMagickError::DestroyedImageError exception is raised.

  **Arguments**:

  - magick_image

    A Magick::Image object.

  **Returns**: a new image.

  **Raises**: Magick::BinMagickError::DestroyedImageError.

***

### Class Magick::BinMagick::Image: instance methods

- **black_px?**

  *img*.black_px? -> *boolean*

  Checks if the image has at least one black pixel.

  **Returns**: a boolean value.

***

- **crop_border**

  *img*.crop_border -> *image*

  Crop border around the image. If the image is blank (has all pixels of white color): returns an unedited copy of the target image.

  Methods calculates a bounding box value for the target image (see Magick::Image#[bounding_box](https://rmagick.github.io/image1.html#bounding_box)), and uses that value to crop a copy of the target image.

  Works best with binary images. For color images you might want to use the *crop_border_clr* version of the method.

  **Returns**: a new image.

***

- **crop_border!**

  *img*.crop_border! -> *self*

  In-place form of **crop_border**.

  **Returns**: self.

***

- **crop_border_clr**

  *img*.crop_border_clr(n_gray_colors = 64, quantize_dither = Magick::NoDitherMethod, threshold_map = "checks") -> *image*

  Same as *crop_border*, but treats a color image like it is already a binary one. The bounding box value is being calculated for a binary version of the target image, then a copy of the target image is being cropped used that value.

  Method **does not** convert the target image to a binary, but uses a binary version only to calculate the bounding box value. For that purpose it accepts and utilizes all *to_binary* arguments.

  **Arguments**: see *to_binary* arguments description.

  **Returns**: a new image.

***

- **crop_border_clr!**

  *img*.crop_border_clr!(n_gray_colors = 64, quantize_dither = Magick::NoDitherMethod, threshold_map = "checks") -> *self*

  In-place form of **crop_border_clr**.

  **Returns**: self.

***

- **extent!**

  *img*.extent!(width, height, x = 0, y = 0) -> *self*

  In-place form of Magick::Image#[extent](https://rmagick.github.io/image2.html#extent).

  If width or height is greater than the target image's width or height, extends the width and height of the target image to the specified values. The new pixels are set to the background color. If width or height is less than the target image's width or height, crops the target image.

  **Arguments**:

  - width

   The width of the new image.

  - height

   The height of the new image.

  - x, y

   The upper-left corner of the new image is positioned at -x, -y.

  **Returns**: self.

***

- **fit_to_size**

  *img*.fit_to_size(max_width, max_height) -> *image*

  Scales down the image to fit within the specified dimensions while retaining the original aspect ratio, but only if the image is larger than provided *max_width*, *max_height* dimensions.

  **Arguments**:

  - max_width, max_height

    Maximum allowed image dimension.

  **Returns**: a new image.

***

- **fit_to_size!**

  *img*.fit_to_size(max_width, max_height) -> *self*

  In-place form of **fit_to_size**.

  **Returns**: self.

***

- **level!**

  *img*.level!(black_point = 0.0, white_point = Magick::QuantumRange, gamma = 1.0) -> *self*

  In-place form of Magick::Image#[level2](https://rmagick.github.io/image2.html#level).

  Adjusts the levels of an image by scaling the colors falling between specified white and black points to the full available quantum range.

  **Arguments**:

  - black_point

    A black point level in the range 0..QuantumRange. The default is 0.0.

  - white_point

    A white point level in the range 0..QuantumRange. The default is QuantumRange.

  - gamma

    A gamma correction in the range 0.0..10.0 The default is 1.0.

  **Returns**: self.

***

- **ordered_dither!**

  *img*.ordered_dither!(threshold_map = "checks") -> *self*

  In-place form of Magick::Image#[ordered_dither](https://rmagick.github.io/image2.html#ordered_dither).

  **Note**: the default value of the *threshold_map* option is "checks" rather than "2x2" used in the Magick::Image#ordered_dither method.

  **Arguments**:

  - threshold_map

    A dither pattern to use. Available options depend on the used ImageMagick implementation. To print a complete list of the thresholds that have been defined, run the ImageMagick with the `-list threshold` option.

    Some common options (from the ImageMagick [documentation](https://imagemagick.org/script/command-line-options.php?#ordered-dither)):
    ```
    threshold   1x1   Threshold 1x1 (non-dither)
    checks      2x1   Checkerboard 2x1 (dither)
    o2x2        2x2   Ordered 2x2 (dispersed)
    o3x3        3x3   Ordered 3x3 (dispersed)
    o4x4        4x4   Ordered 4x4 (dispersed)
    o8x8        8x8   Ordered 8x8 (dispersed)
    h4x4a       4x1   Halftone 4x4 (angled)
    h6x6a       6x1   Halftone 6x6 (angled)
    h8x8a       8x1   Halftone 8x8 (angled)
    h4x4o             Halftone 4x4 (orthogonal)
    h6x6o             Halftone 6x6 (orthogonal)
    h8x8o             Halftone 8x8 (orthogonal)
    h16x16o           Halftone 16x16 (orthogonal)
    c5x5b       c5x5  Circles 5x5 (black)
    c5x5w             Circles 5x5 (white)
    c6x6b       c6x6  Circles 6x6 (black)
    c6x6w             Circles 6x6 (white)
    c7x7b       c7x7  Circles 7x7 (black)
    c7x7w             Circles 7x7 (white)
    ```

  **Returns**: self.

***

- **oversize?**

  *img*.oversize?(max_width, max_height) -> *boolean*

  Checks if the target image dimensions exceed provided height **or** width.

  **Returns**: a boolean value.

***

- **quantize!**

  *img*.quantize!(number_colors = 64, colorspace = Magick::GRAYColorspace, dither = Magick::NoDitherMethod, tree_depth = 0, measure_error = false) -> *self*

  In-place form of Magick::Image#[quantize](https://rmagick.github.io/image3.html#quantize).

  **Notes**:

    - the default value of the *number_colors* option is 64 rather than 256 used in the Magick::Image#quantize method;

    - the default value of the *colorspace* option is Magick::GRAYColorspace rather than Magick::RGBColorspace used in the Magick::Image#quantize method;

    - the default value of the *dither* option is Magick::NoDitherMethod rather than Magick::RiemersmaDitherMethod used in the Magick::Image#quantize method;

  **Arguments**:

  - number_colors

    The maximum number of colors in the result image.

  - colorspace

    The colorspace to quantize in.

  - dither

    Error diffusion dither that will be applied on the color reduction. A Magick::DitherMethod value.

  - tree_depth

    The tree depth to use while quantizing

  - measure_error

    Set to true to calculate quantization errors when quantizing the image.

  **Returns**: self.

***

- **to_binary**

  *img*.to_binary(n_gray_colors = 64, quantize_dither = Magick::NoDitherMethod, threshold_map = "checks") -> *image*

  Converts a color image to a binary (monochrome) image.

  Combines two RMagick methods:

  1. Magick::Image#[quantize](https://rmagick.github.io/image3.html#quantize) (color reducing step);

  2. Magick::Image#[ordered_dither](https://rmagick.github.io/image2.html#ordered_dither) (ordered dither filter).

  The first step converts image to a grayscale format with limited number of gray tones (specified by the *n_gray_colors* option). The second step applies the ordered dither filter to the grayscale image, resulting a binary image.

  **Arguments**:

  - n_gray_colors

    Maximum number of gray tones in the quantized image.

  - quantize_dither

    Error diffusion dither that will be applied on the color reduction step. A Magick::[DitherMethod](https://rmagick.github.io/constants.html#DitherMethod) value.

  - threshold_map

    A dither pattern to use.

  **Returns**: a new image.

***

- **to_binary!**

  *img*.to_binary!(n_gray_colors = 64, quantize_dither = Magick::NoDitherMethod, threshold_map = "checks") -> *self*

  The in-place form of **to_binary!**.

  **Returns**: self.

***

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/8bit-mate/bin_magick.rb.

## Acknowledge

Test images were generated with the https://make.girls.moe/ project.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
