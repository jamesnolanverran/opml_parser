defmodule S do
  import SweetXml
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
  def run do
    base_node = request_body |> xpath(~x"//Query/cars"l)
    paths = ["bmw", "specs"]
    process_node(base_node, paths)
  end
  def process_node(node, [ path | tail ]) do
    node
    |> Enum.map(fn (node) ->
      child_node = node |> xpath(~x"./#{path}"l)
      { node |> xpath(~x"name(.)"s) |> String.to_atom,
        process_node(child_node, tail)
      }
    end)
  end
  def process_node(node, []) do
    [ specs: node |> spec_details |> List.flatten ]
  end

  def spec_details(spec_info) do
    spec_info
    |> Enum.map(fn (spec) ->
        [
        model: spec |> xpath(~x"./model/text()"s),
        engine: spec |> xpath(~x"./engine/text()"s)
      ]
    end)
  end
end