# OPMLParser

A basic example of extracting RSS feed info from OPML files using SweetXml and Elixir.

### Usage:

```elixir
iex(1)> OPMLParser.run("test/sample_opml_files/opml_flat.xml")

[%{htmlUrl: "http://news.com.com/", text: "CNET News.com",
   title: "CNET News.com", type: "rss", url: ""},
 %{htmlUrl: "http://www.washingtonpost.com/wp-dyn/politics?nav=rss_politics",
   text: "washingtonpost.com - Politics",
   title: "washingtonpost.com - Politics", type: "rss", url: ""}]


iex(3)> OPMLParser.run("test/sample_opml_files/opml_nested.xml")

[%{children: [%{htmlUrl: "http://www.biology-blog.com/blogs/plant-science-blog.html",
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
   text: "Listen Subscriptions", title: "Listen Subscriptions"}]
```