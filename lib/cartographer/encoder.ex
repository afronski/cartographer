defmodule Cartographer.Encoder do
  @moduledoc """
  Cartographer.Encoder is a module which provides way to encode coordinates into
  a geohash with given precision measured by amount of characters.

  It uses a finite alphabet to present geocoordinates in human readable form.
  """

  @min_lat -90
  @max_lat +90

  @min_lng -180
  @max_lng +180

  @doc """
  Encodes provided latitude (as `lat`) and longitude (as `lng`)
  with desired length (in characters) to a geohash, which uses
  standard `base32` alphabet.

      iex> Cartographer.Encoder.to_base32_geohash(0.0, 0.0, -1)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(0.0, 0.0, 0)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(-90.1, 0.0, 0)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(90.1, 0.0, 0)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(0, -180.1, 0)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(0, 180.1, 0)
      ** (FunctionClauseError) no function clause matching in Cartographer.Encoder.to_base32_geohash/3

      iex> Cartographer.Encoder.to_base32_geohash(0.0, 0.0)
      "s000"

      iex> Cartographer.Encoder.to_base32_geohash(-1.0, -1.0)
      "7zz6"

      iex> Cartographer.Encoder.to_base32_geohash(1.0, 1.0)
      "s00t"

      iex> Cartographer.Encoder.to_base32_geohash(90.0, 180.0)
      "zzzz"

      iex> Cartographer.Encoder.to_base32_geohash(-90.0, -180.0)
      "0000"

      iex> Cartographer.Encoder.to_base32_geohash(10.0, 10.0)
      "s1z0"

      iex> Cartographer.Encoder.to_base32_geohash(52.2333, 21.0167, 9)
      "u3qcnhzch"

      iex> Cartographer.Encoder.to_base32_geohash(57.64911, 10.40744, 11)
      "u4pruydqqvj"
  """
  def to_base32_geohash(lat, lng, length \\ 4)
    when length > 0 and
         lat >= @min_lat and
         lat <= @max_lat and
         lng >= @min_lng and
         lng <= @max_lng
  do
    result = _encode(0, length * Cartographer.base32_size, @min_lat, @max_lat, @min_lng, @max_lng, lat, lng, <<>>)
    Cartographer.to_geohash(result)
  end

  defp _encode(i, precision, _minLat, _maxLat, _minLng, _maxLng, _lat, _lng, result) when i >= precision do
    result
  end

  defp _encode(i, precision, minLat, maxLat, minLng, maxLng, lat, lng, result) when rem(i, 2) == 0 do
    midpoint = (minLng + maxLng) / 2

    if lng < midpoint do
      _encode(i + 1, precision, minLat, maxLat, minLng, midpoint, lat, lng, <<result::bitstring, 0::1>>)
    else
      _encode(i + 1, precision, minLat, maxLat, midpoint, maxLng, lat, lng, <<result::bitstring, 1::1>>)
    end
  end

  defp _encode(i, precision, minLat, maxLat, minLng, maxLng, lat, lng, result) when rem(i, 2) == 1 do
    midpoint = (minLat + maxLat) / 2

    if lat < midpoint do
      _encode(i + 1, precision, minLat, midpoint, minLng, maxLng, lat, lng, <<result::bitstring, 0::1>>)
    else
      _encode(i + 1, precision, midpoint, maxLat, minLng, maxLng, lat, lng, <<result::bitstring, 1::1>>)
    end
  end
end
