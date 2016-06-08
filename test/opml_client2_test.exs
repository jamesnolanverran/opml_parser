defmodule OPMLClient2Test do
  use ExUnit.Case
  doctest OPMLClient2
  # these tests aren't useful at all, but I'm trying out elixir testing...
  setup do
    flat = "./test/sample_opml_files/opml_flat.xml"
    nested = "./test/sample_opml_files/opml_nested.xml"
    multi_nested = "./test/sample_opml_files/opml_multi_nested.xml"
    {:ok, [flat: flat, nested: nested, multi_nested: multi_nested]}
  end

  test "flat", %{flat: filename} do
    result = OPMLClient2.run(filename)
    expected = [ %{htmlUrl: "http://news.com.com/", text: "CNET News.com",
                   title: "CNET News.com", type: "rss", url: ""},
                 %{htmlUrl: "http://www.washingtonpost.com/wp-dyn/politics?nav=rss_politics",
                   text: "washingtonpost.com - Politics",
                   title: "washingtonpost.com - Politics", type: "rss", url: ""}
               ]
    assert result == expected
  end
  test "nested", %{nested: filename} do
    result = OPMLClient2.run(filename)
    expected = [ %{children: [%{htmlUrl: "http://www.biology-blog.com/blogs/plant-science-blog.html",
                      text: "Plant Science Blog From Biology-blog.com",
                      title: "Plant Science Blog From Biology-blog.com", type: "rss", url: ""},
                    %{htmlUrl: "http://plantsarethestrangestpeople.blogspot.com/",
                      text: "Plants are the Strangest People",
                      title: "Plants are the Strangest People", type: "rss", url: ""}],
                   text: "botany", title: "botany"},
                 %{children: [%{htmlUrl: "http://www.abc.net.au/newsradio/podcast/newsradio.xml",
                      text: "ABC NewsRadio Shuffle", title: "ABC NewsRadio Shuffle",
                      type: "rss", url: ""},
                    %{htmlUrl: "http://www.astronomycast.com", text: "Astronomy Cast",
                      title: "Astronomy Cast", type: "rss", url: ""}],
                   text: "Listen Subscriptions", title: "Listen Subscriptions"}
               ]
    assert result == expected
  end

  # test "multi_nested", %{multi_nested: filename} do
  #   result = OPMLClient2.run(filename)
  #   expected = [ %{children: [%{children: [%{htmlUrl: "http://www.biology-blog.com/blogs/plant-science-blog.html",
  #                        text: "Plant Science Blog From Biology-blog.com",
  #                        title: "Plant Science Blog From Biology-blog.com", type: "rss",
  #                        url: ""}], text: "inner-botany1", title: "inner-botany1"},
  #                   %{children: [%{htmlUrl: "http://plantsarethestrangestpeople.blogspot.com/",
  #                        text: "Plants are the Strangest People",
  #                        title: "Plants are the Strangest People", type: "rss", url: ""}],
  #                     text: "inner-botany2", title: "inner-botany2"}], text: "botany",
  #                  title: "botany"},
  #                %{children: [%{children: [%{htmlUrl: "http://www.abc.net.au/newsradio/podcast/newsradio.xml",
  #                        text: "ABC NewsRadio Shuffle", title: "ABC NewsRadio Shuffle",
  #                        type: "rss", url: ""},
  #                      %{htmlUrl: "http://www.astronomycast.com", text: "Astronomy Cast",
  #                        title: "Astronomy Cast", type: "rss", url: ""}], text: "inner-listen1",
  #                     title: "inner-listen1"}], text: "Listen Subscriptions",
  #                  title: "Listen Subscriptions"}
  #               ]
  #   assert result == expected
  # end
end