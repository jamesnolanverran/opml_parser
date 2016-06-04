defmodule S do
# defmodule SweetXmlTraversal do
  import SweetXml
  defp traverse_nodes(outer_node, [ path | tail ]) do
    node_name = outer_node |> get_keyword_name
    outer_node
    |> Enum.map(fn (node) ->
      inner_node = node |> xpath(~x"./#{path}"l)
      handle_node({node_name, inner_node}, tail)
    end)
  end
  defp traverse_nodes(outer_node, []) do # no more specified paths - leafy
    node_name = outer_node |> get_keyword_name
    handle_node({node_name, outer_node}, [])
  end

  defp get_keyword_name(node) do
    node |> List.first |> xpath(~x"name(.)"s) |> String.to_atom
  end

  #================================
  def run do
  # def run(filename, path) do
    doc = request_body # doc = File.stream!(filename // "dir/to/page.xml")
    path = "Query/cars/bmw/specs" # travers these paths - all as lists - and a callback will fire for each node
                                  # that will be handled with handle_node
    [ base | paths ] = String.split(path, "/")
    base_node = doc |> xpath(~x"//#{base}"l) # paths need to include a surrounding element -> eg "body"
    traverse_nodes(base_node, paths)
  end

  # Use callbacks to handle specific nodes using :path
  # defp handle_node({:specs, node}, []) do # final traversal for :spec branch
  #   node
  #   |> Enum.map(fn (specs_node) ->
  #     {
  #       :specs,
  #       [
  #         model: specs_node |> xpath(~x"./model/text()"s),
  #         engine: specs_node |> xpath(~x"./engine/text()"s),
  #         doesntexist: specs_node |> xpath(~x"./nonexistent/text()"s)
  #       ]
  #     }
  #   end)
  # end

  # defp handle_node({node_name, node}, paths) do # for all cases but ":specs" in the path I build a nested keyword list
  #   {
  #     node_name,
  #     traverse_nodes(node, paths)
  #   }
  # end
  defp handle_node(_, []), do: [] # default on last node returns empty list
  defp handle_node({_, node}, paths) do # default on all other nodes continue down path -
    traverse_nodes(node, paths)
  end
  defp handle_node(_, _), do: [] # default on last node returns empty list

  defp request_body do
    """
    <Query>
      <cars>
        <bmw>
          <specs>
           <model>5 seriesw</model>
            <engine>4.4</engine>
          </specs>
        </bmw>
        <bmw>
          <specs>
            <model>3 seriesw</model>
            <engine>3.0</engine>
          </specs>
        </bmw>
      </cars>
    </Query>
    """
  end
end
