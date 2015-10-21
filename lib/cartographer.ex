defmodule Cartographer do
  @moduledoc """
  Utility module with all kind of helper functions, e.g. related to encoding to human readable forms
  or storing different popular alphabets and constants related with that.
  """

  @base32_word_size 5
  @base32_alphabet  "0123456789bcdefghjkmnpqrstuvwxyz"

  @doc """
  Returns size of the single character in the `base32` alphabet.
  """
  def base32_size do
    @base32_word_size
  end

  @doc """
  Converts provided bits into a geohash, taking `base32` as a default alphabet.

      iex> Cartographer.to_geohash(<<0::5>>)
      "0"

      iex> Cartographer.to_geohash(<<31::5>>)
      "z"

      iex> Cartographer.to_geohash(<<0::1,0::1,1::1,0::1,1::1>>)
      "5"

      iex> Cartographer.to_geohash(<<>>)
      ""

      iex> Cartographer.to_geohash(<<0::5>>, "ab", 1)
      "aaaaa"

      iex> Cartographer.to_geohash(<<31::5>>, "ab", 1)
      "bbbbb"

      iex> Cartographer.to_geohash(<<10::5>>, "ab", 1)
      "ababa"
  """
  def to_geohash(bits, alphabet \\ @base32_alphabet, word_size \\ @base32_word_size) do
    indexes = for <<x::size(word_size) <- bits>>, do: x
    Enum.join(Enum.map(indexes, &String.at(alphabet, &1)), "")
  end

  @doc """
  Converts provided geohash into a bitstring, taking `base32` as a default alphabet.

      iex> Cartographer.to_bits("0")
      <<0::5>>

      iex> Cartographer.to_bits("z")
      <<31::5>>

      iex> Cartographer.to_bits("5")
      <<0::1, 0::1, 1::1, 0::1, 1::1>>

      iex> Cartographer.to_bits("")
      <<>>

      iex> Cartographer.to_bits("aaaaa", "ab", 1)
      <<0::5>>

      iex> Cartographer.to_bits("bbbbb", "ab", 1)
      <<31::5>>

      iex> Cartographer.to_bits("ababa", "ab", 1)
      <<10::5>>
  """
  def to_bits(geohash, alphabet \\ @base32_alphabet, word_size \\ @base32_word_size) do
    alphabetified = String.codepoints(alphabet)
    characters = String.codepoints(geohash)
    indexes = Enum.map(characters, &Enum.find_index(alphabetified, fn(x) -> x == &1 end))

    for i <- indexes, into: <<>>, do: <<i::size(word_size)>>
  end
end
