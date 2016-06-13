defmodule OPMLClient do
  use SweetXmlTraversal

  def run(filename) do
    doc = File.stream!(filename)
    path = "body/outline"
    start_traversal(doc, path, __MODULE__)
  end

  def handle_node({:body, inner_node}, paths), do: traverse_node(inner_node, paths, __MODULE__) # ignore <body>

  def handle_node({:outline, inner_node}, []) do
  inner_node
  |> Enum.map(fn (outline_node) ->
    case inner_node |> hasChildren? do # nested outline tags
      true ->
        %{
            text:       outline_node |> xpath(~x"./@text"s),
            title:      outline_node |> xpath(~x"./@title"s),
            children:   outline_node |> xpath(~x"./outline"l) |> traverse_node([], __MODULE__)
         }
      false ->
        %{
          title:    outline_node |> xpath(~x"./@title"s),
          text:     outline_node |> xpath(~x"./@text"s),
          htmlUrl:  outline_node |> xpath(~x"./@htmlUrl"s),
          url:      outline_node |> xpath(~x"./@url"s),
          type:     outline_node |> xpath(~x"./@type"s)
         }
      end
    end)
  end

  defp hasChildren?(node) do
    node |> List.first |> xpath(~x"./outline") != nil
  end
end