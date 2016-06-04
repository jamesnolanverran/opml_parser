defmodule S do
  import SweetXml
  def run(base_node, path) do
    paths = String.split(path, "/")
    process_node(base_node, paths)
  end
  def process_node(outer_node, [ path | tail ]) do
    outer_node
    |> Enum.map(fn (node) ->
      inner_node = node |> xpath(~x"./#{path}"l)
      node_name = node |> get_keyword_name
      {
        node_name,
        callback({node_name, inner_node}, tail)
      }
    end)
  end
  def process_node(outer_node, []) do
    outer_node
    |> Enum.map(fn (node) ->
      node_name = node |> get_keyword_name
      {
        node_name,
        outer_node
      } |> callback([]) #indicates an outer leaf - combine both process_node functions? they are different
    end)
    |> List.flatten
  end
  defp get_keyword_name(node) do
    node |> xpath(~x"name(.)"s) |> String.to_atom
  end



  #================================
  def request_body do
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
  def run2 do
    base_node = request_body |> xpath(~x"//Query"l)
    path = "cars/bmw/specs"
    S.run(base_node, path)
  end


  def callback({:specs, node}, []) do # an outer leaf
    node
    |> Enum.map(fn (specs_node) ->
      node_name = specs_node |> get_keyword_name
      {
        node_name,
        [
          model: specs_node |> xpath(~x"./model/text()"s),
          engine: specs_node |> xpath(~x"./engine/text()"s),
          doesntexist: specs_node |> xpath(~x"./nonexistent/text()"s)
        ]
      }
    end)
  end

# do something with nodes --- I will have to generalize the default behaviour so it can be structured explicitly
# no more keyword lists ---


  def callback({_, node}, paths) do
    S.process_node(node, paths)
  end

  def callback(_, _) do
    []
  end

end
