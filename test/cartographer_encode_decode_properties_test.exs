defmodule Cartographer.EncodeDecodeProperties.Test do
  use ExUnit.Case, async: false
  use ExCheck

  @min_lat -90
  @max_lat +90

  @min_lng -180
  @max_lng +180

  @scale   1000

  test "encoding with fixed length should return geohash of that length" do
    assert verify_property(
      for_all {x, y, length} in {lat(), lng(), length()}, do:
        String.length(Cartographer.Encoder.to_base32_geohash(x, y, length)) == length
    )
  end

  test "encoding coordinates and then decoding should return the same coordinates (for integer precision)" do
    assert verify_property(
      for_all {x, y} in {lat(), lng()}, do:
        {x, y} == Cartographer.Decoder.from_geohash(Cartographer.Encoder.to_base32_geohash(x, y), 0)
    )
  end

  test "after increasing precision we should be able to retrieve the same floating-point coordinates" do
    assert verify_property(
      for_all {scaled_x, scaled_y} in {scaled_lat(), scaled_lng()} do
        {x, y} = {scaled_x / @scale, scaled_y / @scale}
        {x, y} == Cartographer.Decoder.from_geohash(Cartographer.Encoder.to_base32_geohash(x, y, 9), 3)
      end
    )
  end

  # Custom generators.

  defp lat do
    int(@min_lat, @max_lat)
  end

  defp lng do
    int(@min_lng, @max_lng)
  end

  defp scaled_lat do
    int(@min_lat * @scale, @max_lat * @scale)
  end

  defp scaled_lng do
    int(@min_lng * @scale, @max_lng * @scale)
  end

  defp length do
    int(1, 9)
  end
end
