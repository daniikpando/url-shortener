defmodule UrlShortenerWeb.Utils.HashAlgorithms do
  @type hash :: :CRC32 | :sha | :md5

  @spec encode(hash, String.t()) :: String.t()
  def encode(:CRC32, value) do
    :erlang.crc32(value) |> to_string() |> Base.encode64(padding: false)
  end

  def encode(hash, value) when hash in [:sha, :md5] do
    hash |> :crypto.hash(value) |> Base.encode64(padding: false)
  end
end
