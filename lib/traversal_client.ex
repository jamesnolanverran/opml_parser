defmodule TraversalClient do
  use SweetXmlTraversal
  def run do
  # def run(filename, path) do
    doc = request_body # doc = File.stream!(filename // "dir/to/page.xml")
    path = "Query/cars/bmw/specs" # travers these paths - all as lists - and a callback will fire for each node
                                  # that will be handled with handle_node
    [ base | paths ] = String.split(path, "/")
    base_node = doc |> xpath(~x"//#{base}"l) # paths need to include a surrounding element -> eg "body"
    traverse_nodes(base_node, paths, __MODULE__) # store __MODULE__ in a datastructure so I don't have to pass it to every function
    # start_traversal(__MODULE__, base_node, paths)
  end

  # Use callbacks to handle specific nodes using :path
  def handle_node({:specs, node}, []) do # final traversal for :spec branch
    node
    |> Enum.map(fn (specs_node) ->
      {
        :specs,
        [
          model: specs_node |> xpath(~x"./model/text()"s),
          engine: specs_node |> xpath(~x"./engine/text()"s),
          doesntexist: specs_node |> xpath(~x"./nonexistent/text()"s)
        ]
      }
    end)
  end

  def handle_node({:cars, node}, paths) do
    {
      :yikes,
      traverse_nodes(node, paths, __MODULE__)
    }
  end
  def handle_node({node_name, node, _}, paths) do # for all cases but ":specs" in the path I build a nested keyword list
    {
      node_name,
      traverse_nodes(node, paths, __MODULE__)
    }
  end






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
end