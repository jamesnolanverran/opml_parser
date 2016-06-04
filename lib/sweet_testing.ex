defmodule S do
# defmodule S weetXmlTraversal do
  defmacro __using__(_) do
    quote do
      # Define implementation for user modules to use
      import SweetXml
      import S
      def handle_node(_, _), do: []

      # Defoverridable makes the given functions in the current module overridable
      # Without defoverridable, new definitions of greet will not be picked up
      defoverridable [handle_node: 2]
    end
  end
  import SweetXml
  def traverse_nodes(outer_node, [ path | tail ], x) do
    node_name = outer_node |> get_keyword_name
    outer_node
    |> Enum.map(fn (node) ->
      inner_node = node |> xpath(~x"./#{path}"l)
      x.handle_node({node_name, inner_node}, tail)
    end)
  end
  def traverse_nodes(outer_node, [], x) do # no more specified paths - leafy
    node_name = outer_node |> get_keyword_name
    X.handle_node({node_name, outer_node}, [])
  end

  def get_keyword_name(node) do
    node |> List.first |> xpath(~x"name(.)"s) |> String.to_atom
  end
end
  #================================
defmodule X do
  use S
  def run do
  # def run(filename, path) do
    doc = request_body # doc = File.stream!(filename // "dir/to/page.xml")
    path = "Query/cars/bmw/specs" # travers these paths - all as lists - and a callback will fire for each node
                                  # that will be handled with handle_node
    [ base | paths ] = String.split(path, "/")
    base_node = doc |> xpath(~x"//#{base}"l) # paths need to include a surrounding element -> eg "body"
    traverse_nodes(base_node, paths, __MODULE__)
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

  def handle_node({node_name, node}, paths) do # for all cases but ":specs" in the path I build a nested keyword list
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
