## Fun with xml and elixir

I started to work on a basic opml parser with SweetXml for a personal project, and have been playing and experimenting with xml parsing in elixir, and also elixir in general.

### OPMLParser

A simple example of extracting RSS feed info from OPML files using SweetXml and Elixir. There's a bug in sweet_xml formatting (#31) so I tried something different, still using sweet_xml for now. I used http://www.therssweblog.com/?guid=20051003145153 as a guide

#### Usage:

```elixir
iex(1)> OPMLClient.run("test/sample_opml_files/opml_flat.xml")
```