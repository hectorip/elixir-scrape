defmodule Scrape.Fetch do

  # http://www.erlang.org/doc/apps/stdlib/unicode_usage.html
  # http://www.erlang.org/doc/man/unicode.html
  # http://www.reddit.com/r/elixir/comments/39azpw/character_encoding_conversion_in_elixir/
  def run(url) do
    response = HTTPoison.get! url
    cs = charset(response.headers)
    if cs do
      encoding = cs
      |> String.replace("-","_")
      |> String.downcase
      |> to_char_list
      |> List.to_atom
      Codepagex.to_string response.body, encoding
    else
      response.body
    end
  end

  defp charset(headers) do
    header = headers
    |> Enum.filter(fn({k,v}) -> k == "Content-Type" end)
    |> List.first
    if header do
      {name, content} = header
      ~r/charset=(ISO-8859-[1-9])/i
      |> Regex.run(content, capture: :all_but_first)
      |> List.first
    else
      nil
    end
  end
end
