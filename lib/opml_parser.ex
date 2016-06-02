defmodule OPMLParser do
  import SweetXml

  def run(file) do
    doc = File.stream!(file) |> xpath(~x"//body/outline"l)
    if doc |> List.first |> xpath(~x"./outline") == nil do
      parse_opml(doc)
    else
      parse_opml(doc, :nested)
    end
  end

  defp parse_opml(doc) do
    doc
    |> Enum.map(fn (outline_node) ->
        %{
            title: outline_node |> xpath(~x"./@title"s),
            text: outline_node |> xpath(~x"./@text"s),
            htmlUrl: outline_node |> xpath(~x"./@htmlUrl"s),
            url: outline_node |> xpath(~x"./@url"s),
            type: outline_node |> xpath(~x"./@type"s)
          }
    end)
  end
  defp parse_opml(doc, :nested) do
    doc
    |> Enum.map(fn (outline_node) ->
        %{
            text:       outline_node |> xpath(~x"./@text"s),
            title:      outline_node |> xpath(~x"./@title"s),
            children:      outline_node |> xpath(~x"./outline"l,
                                                title:    ~x"./@title"s,
                                                text:     ~x"./@text"s,
                                                htmlUrl:  ~x"./@htmlUrl"s,
                                                url:      ~x"./@url"s,
                                                type:     ~x"./@type"s
                                             )
        }
    end)
  end
end