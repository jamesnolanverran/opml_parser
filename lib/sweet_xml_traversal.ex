defmodule SweetXmlTraversal do
  @callback handle_node({atom, any}, list) :: any

  defmacro __using__(_) do
    quote do

      @behaviour SweetXmlTraversal

      import SweetXml
      import unquote(__MODULE__)

      def handle_node({node_name, node}, []), do: {node_name, []} # create nested keyword list by default
      def handle_node({node_name, node}, path), do: {node_name, traverse_node(node, path, __MODULE__)}

      defoverridable [handle_node: 2]
    end
  end

  import SweetXml

  def start_traversal(doc, path, module) do
    [ base_path | rest_of_paths ] = String.split(path, "/")
    base_node = doc |> xpath(~x"//#{base_path}"l)
    traverse_node(base_node, rest_of_paths, module)
  end

  def traverse_node(outer_node, paths, module) do
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


