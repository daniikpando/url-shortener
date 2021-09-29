defmodule UrlShortenerWeb.Utils.HashAlgorithms do
  alias UrlShortenerWeb.Utils.Base62

  @spec encode(String.t() | integer(), :CRC32 | :SHA1 | :base62) :: {:ok, String.t()} | {:error, String.t()}
  def encode(elm, hash_algorithm) do
    case encode_by_hash(elm, hash_algorithm) do
      {:ok, elm} = rs when is_binary(elm) -> rs
      {:ok, elm} when is_integer(elm) -> {:ok, elm |> Integer.to_string()}
      {:error, _} = error -> error
    end
  end

  @spec encode_by_hash(String.t(), :CRC32 | :SHA1 | :base62) :: {:ok, any} | {:error, String.t()}
  defp encode_by_hash(elm, :base62) do
    case elm do
      elm when is_integer(elm) ->
        elm |> Integer.to_string() |> Base62.decode()

      elm when is_binary(elm) ->
        elm |> Base62.decode()

      _ ->
        {:error, "Failed to encode url"}
    end
  end

  defp encode_by_hash(elm, :CRC32) do
    {:ok, :erlang.crc32(elm)}
  end

  defp encode_by_hash(elm, :SHA1) do
    {:ok, :crypto.hash(:sha, elm) |> Base.encode16()}
  end
end
