defmodule Cartographer do
  @moduledoc """
  Cartographer is a module which provides way to encode and decode Geohashes.
  """

  @minimalLatitude -90
  @maximalLatitude +90

  @minimalLongitude -180
  @maximalLongitude +180

  @word 5
  @alphabet "0123456789bcdefghjkmnpqrstuvwxyz"

  @doc """
  Encodes provided latitude (as `lat`) and longitude (as `lng`)
  with desired length (in characters) to a geohash, which uses
  standard `base32` alphabet.

      iex> Cartographer.encode(0.0, 0.0)
      "s000"

      iex> Cartographer.encode(10.0, 10.0)
      "s1z0"

      iex> Cartographer.encode(52.2333, 21.0167, 9)
      "u3qcnhzch"
  """
  def encode(lat, lng, length \\ 4) do
    _encode(0, length * @word, @minimalLatitude, @maximalLatitude, @minimalLongitude, @maximalLongitude, lat, lng, <<>>)
  end

  defp _human_friendly_representation(binary) do
    indexes = for <<x::size(@word) <- binary>>, do: x
    Enum.join(Enum.map(indexes, &String.at(@alphabet, &1)), "")
  end

  defp _encode(i, precision, _minLat, _maxLat, _minLng, _maxLng, _lat, _lng, result) when i >= precision do
    _human_friendly_representation(result)
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
