defmodule OPMLClient do
  use SweetXmlTraversal

  def run do
    doc = File.stream!("test/sample_opml_files/opml_multi_nested.xml")
    path = "body/outline/outline"
    [ base | rest ] = String.split(path, "/") |> Enum.map(&String.downcase/1)
    base_node = doc |> xpath(~x"//#{base}"l)
    IO.inspect rest
    traverse_nodes(base_node, rest, __MODULE__)
  end

  def handle_node({:outline, node}, []) do
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
  def handle_node({_, node}, paths) do
    node
    |> Enum.map(fn (outline_node) ->
        %{
            text:       outline_node |> xpath(~x"./@text"s),
            title:      outline_node |> xpath(~x"./@title"s),
            children:   traverse_nodes(node, paths, __MODULE__)
          }
    end)
  end

end