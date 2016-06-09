defmodule SweetXmlTraversal do
  @callback handle_node(any, any) :: any

  defmacro __using__(_) do
    quote do

      @behaviour SweetXmlTraversal

      import SweetXml
      import SweetXmlTraversal

      def handle_node(_, _), do: [] # default gets an empty list

      defoverridable [handle_node: 2]
    end
  end
  import SweetXml

  def traverse_nodes(outer_node, paths, module) do
    case paths do
      [path | tail] ->
        node_name = outer_node |> get_keyword_name
        outer_node
        |> Enum.map(fn (node) ->
          inner_node = node |> xpath(~x"./#{path}"l)
          module.handle_node({node_name, inner_node}, tail)
        end)
        |> List.flatten
      [] ->
        node_name = outer_node |> get_keyword_name
        module.handle_node({node_name, outer_node}, [])
    end
  end

  def get_keyword_name(node) do
    node |> List.first |> xpath(~x"name(.)"s) |> String.to_atom
  end
end


