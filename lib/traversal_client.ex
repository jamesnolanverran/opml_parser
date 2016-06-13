defmodule TraversalClient do
  use SweetXmlTraversal
  def run do
    path = "Query/cars/bmw/specs"
    start_traversal(request_body, path, __MODULE__)
  end

  def handle_node({:specs, node}, []) do
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
  def handle_node({node_name, node}, paths) do
    {
      node_name,
      traverse_node(node, paths, __MODULE__)
    }
  end
  def request_body do
    """
      <Query><cars>
        <bmw>
          <specs>
           <model>5 seriesw</model>
            <engine>4.4</engine>
          </specs>
          <specs>
           <model>8 seriesw</model>
            <engine>9.9</engine>
          </specs>
        </bmw>
        <bmw>
          <specs>
            <model>3 seriesw</model>
            <engine>3.0</engine>
          </specs>
        </bmw>
        <porche>
          <specs>
            <model>911</model>
            <engine>3.3</engine>
          </specs>
          <specs>
            <model>914</model>
            <engine>5.0</engine>
          </specs>
        </porche>
        <porche>
          <specs>
            <model>some other model</model>
            <engine>3.2</engine>
          </specs>
        </porche>
      </cars></Query>
    """
  end
  def run2 do
    request_body |> xpath(
      ~x"//Query"l,
        cars: [
          ~x"./cars"l,
            bmw: [
              ~x"./bmw"l,
              specs: [
                ~x"./specs"l,
                  model: ~x"./model/text()"s,
                  engine: ~x"./engine/text()"s
            ]
          ],
            porche: [
              ~x"./porche"l,
              specs: [
                ~x"./specs"l,
                  model: ~x"./model/text()"s,
                  engine: ~x"./engine/text()"s
              ]
            ]
          ]
    )
  end
# OUTPUT:
# [[cars: [[bmw: [[specs: [[model: "5 seriesw", engine: "4.4"],
#        [model: "8 seriesw", engine: "9.9"]]],
#      [specs: [[model: "3 seriesw", engine: "3.0"]]]],
#     porche: [[specs: [[model: "911", engine: "3.3"],
#        [model: "914", engine: "5.0"]]],
#      [specs: [[model: "some other model", engine: "3.2"]]]]]]]]

end