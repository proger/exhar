# Exhar

Read & process [HAR](http://www.softwareishard.com/blog/har-12-spec/) files easily!

```elixir
iex(15)> Exhar.load("testflightapp.com.har")
Exhar.HAR[version: "1.2",
 creator: Exhar.Browser[name: "WebInspector", version: "537.36", comment: nil],
 browser: Exhar.Browser[name: nil, version: nil, comment: nil],
 pages: [Exhar.Page[startedDateTime: "2013-10-04T20:47:46.003Z", id: "page_1",
   title: "https://testflightapp.com/dashboard/team/",
   pageTimings: Exhar.PageTimings[onContentLoad: 1760, onLoad: 2378,
    comment: nil], comment: nil]],
...
```

Repeating a request:

```elixir
iex(2)> Exhar.load("testflightapp.com.har").entries |> Enum.first |> Exhar.Entry.request |> Exhar.Request.perform
{:ok, 200,
 [{"Server", "nginx"}, {"Date", "Sun, 06 Oct 2013 20:31:17 GMT"},
  {"Content-Type", "text/html; charset=utf-8"}, {"Content-Length", "5716"},
  {"Connection", "keep-alive"}, {"Vary", "Cookie, Accept-Encoding"},
  {"Content-Encoding", "gzip"},
  {"Set-Cookie",
   "yeah right like i'd copy this line :)"}],
 {:client, :hackney_ssl_transport, 'testflightapp.com', 443, :netloc,
  [follow_redirect: true],
  {:sslsocket, {:gen_tcp, #Port<0.4942>}, #PID<0.112.0>}, :infinity, true, 5,
  false, nil, :undefined, :connected, :on_body, nil, :normal,
  &:hackney_request.send/2, :waiting, 4096,
  <<...>>,
  {1, 1}, 5716, nil, "keep-alive", "GET", "text/html; charset=utf-8"}}
```
