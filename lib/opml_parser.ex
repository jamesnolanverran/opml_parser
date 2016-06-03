defmodule OPMLParser do
  import SweetXml

  def run(file) do
    node = File.stream!(file) |> xpath(~x"//body/outline"l)
    parse_opml(node)
  end

  defp parse_opml(node) do
    if node |> hasChildren? do
      parse_node(node, :nested)
    else
      parse_node(node)
    end
  end

  defp hasChildren?(node) do
    node |> List.first |> xpath(~x"./outline") != nil
  end

  defp parse_node(node) do
    node
    |> Enum.map(fn (outline_node) ->
        %{
            title:    outline_node |> xpath(~x"./@title"s),
            text:     outline_node |> xpath(~x"./@text"s),
            htmlUrl:  outline_node |> xpath(~x"./@htmlUrl"s),
            url:      outline_node |> xpath(~x"./@url"s),
            type:     outline_node |> xpath(~x"./@type"s)
          }
    end)
  end
  defp parse_node(node, :nested) do
    node
    |> Enum.map(fn (outline_node) ->
        %{
            text:       outline_node |> xpath(~x"./@text"s),
            title:      outline_node |> xpath(~x"./@title"s),
            children:   outline_node |> xpath(~x"./outline"l) |> parse_opml
          }
    end)
  end
end