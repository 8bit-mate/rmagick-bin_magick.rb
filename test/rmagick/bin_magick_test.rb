# frozen_string_literal: true

require "test_helper"

class Magick::BinMagickTest < Minitest::Test
  def bin_magick_from_file(filename)
    Magick::BinMagick::Image.from_file(filename)
  end

  def magick_read(filename)
    Magick::Image.read(filename).first
  end

  def test_init_from_file
    b_magick_image = bin_magick_from_file("./data/test_0.png")

    assert_kind_of Magick::BinMagick::Image, b_magick_image
  end

  def test_init_from_rmagick
    magic_image = magick_read("./data/test_1.png")
    b_magick_image = Magick::BinMagick::Image.new(magic_image)

    assert_kind_of Magick::BinMagick::Image, b_magick_image
  end
end
