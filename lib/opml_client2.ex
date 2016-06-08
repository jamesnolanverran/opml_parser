defmodule OPMLClient2 do
  use SweetXmlTraversal

  def run(filename) do
    doc = File.stream!(filename)
    path = "body/outline"
    [ base | rest ] = String.split(path, "/")
    base_node = doc |> xpath(~x"//#{base}"l)
    traverse_nodes(base_node, rest, __MODULE__)

  end

  def handle_node({:outline, inner_node}, []) do
    inner_node
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

  def handle_node({:body, inner_node, outer_node}, paths), do: traverse_nodes(inner_node, paths, __MODULE__)

end