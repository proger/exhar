# Exhar

Read & process [HAR](http://www.softwareishard.com/blog/har-12-spec/) files easily!

```elixir
iex(4)> inspect Exhar.load("testflightapp.com.har"), limit: 3
"Exhar.HAR[version: \"1.2\", creator: Exhar.Browser[name: \"WebInspector\", version: \"537.36\", comment: nil], browser: Exhar.Browser[name: nil, version: nil, comment: nil], ...]"
```

### Upcoming stuff:

* request mocking based on HAR data
