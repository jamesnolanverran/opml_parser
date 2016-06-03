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
    query_node = request_body |> xpath(~x"//Query/cars"l)
    get_brand(query_node)
    # n = query_node |> get_node_names
    # n2 = n |> List.first
    # request_body |> xpath(~x"name(.)")
    # request_body |> xpath(~x"//Query/#{n2}"k)
  end

  def get_node_names(outer_node) do
    outer_node
    |> Enum.map(fn (node) ->
      node |> xpath(~x"name(.)"s)
    end)
  end
################
  def get_cars_node(query_node) do
    query_node
    |> Enum.map(fn (node) ->
      node_name = node |> xpath(~x"name(.)"l)
      node_name
    end)
  end
  ###########################
  def get_cars(cars_node) do
    brand_node = request_body |> xpath(~x"//Query/cars"l)
    cars_node
    |> Enum.map(fn (cars) ->
      [ cars |> xpath(~x"name(.)"s),
        get_brand(brand_node)
      ]
    end)
  end
  def get_brand(brand_node) do
    specs_node = request_body |> xpath(~x"//Query/cars/bmw"l)
    brand_node
    |> Enum.map(fn (cars) ->
      { cars |> xpath(~x"name(.)"s) |> String.to_atom,
        get_specs(specs_node)
      }
    end)
  end
  def get_specs(brand_node) do
    brand_node
    |> Enum.map(fn (brand) ->
      { brand |> xpath(~x"name(.)"s) |> String.to_atom,
        [specs: brand |> xpath(~x"./specs"l) |> spec_details |> List.flatten]
      }
    end)
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