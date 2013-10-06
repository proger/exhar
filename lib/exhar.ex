defmodule Exhar do

  defrecord HAR, version: nil, creator: Exhar.Browser, browser: Exhar.Browser, pages: [Exhar.Page], entries: [Exhar.Entry], comment: nil

  defrecord Browser, name: nil, version: nil, comment: nil
  defrecord Page, startedDateTime: nil, id: nil, title: nil, pageTimings: Exhar.PageTimings, comment: nil

  defrecord Entry, pageref: nil, startedDateTime: nil, time: nil, request: Exhar.Request,
                   response: Exhar.Response, cache: nil, timings: Exhar.PageTimings,
                   serverIPAddress: nil, connection: nil, comment: nil

  defrecord PageTimings, onContentLoad: nil, onLoad: nil, comment: nil
  defrecord Cookie, name: nil, value: nil, path: nil, domain: nil, expires: nil, httpOnly: nil, secure: nil, comment: nil
  defrecord Header, name: nil, value: nil, comment: nil
  defrecord QueryString, name: nil, value: nil, comment: nil
  defrecord PostData, mimeTypes: nil, params: [Exhar.Param], text: nil, comment: nil
  defrecord Param, name: nil, value: nil, fileName: nil, contentType: nil, comment: nil
  defrecord Content, size: nil, compression: nil, mimeType: nil, text: nil, comment: nil

  defrecord Request, method: nil,
                     url: nil,
                     httpVersion: nil,
                     cookies: [Exhar.Cookie],
                     headers: [Exhar.Header],
                     queryString: [Exhar.QueryString],
                     postData: Exhar.PostData,
                     headersSize: nil,
                     bodySize: nil,
                     comment: nil do

    def method_atom(Request[method: method]) do
      String.downcase(method) |> binary_to_atom :utf8
    end

    def header_proplist(Request[headers: headers]) do
      Enum.map headers, fn Header[name: name, value: value] -> {name, value} end
    end

    def payload(Request[postData: nil]), do: ""
    def payload(Request[postData: PostData[text: nil]]), do: ""
    def payload(Request[postData: PostData[text: text]]), do: text

    def perform(req) do
      :hackney.request req.method_atom, req.url, req.header_proplist, req.payload, follow_redirect: true
    end

  end

  defrecord Response, status: nil,
                      statusText: nil,
                      httpVersion: nil,
                      cookies: [Exhar.Cookie],
                      headers: [Exhar.Header],
                      content: Exhar.Content,
                      redirectURL: nil,
                      headersSize: nil,
                      bodySize: nil,
                      comment: nil

  def dict_to_record(nil, record) do
    record.new
  end

  def dict_to_record(dict, record) do
    fields = Enum.map(record.__record__(:fields), fn {atom, default} -> {atom_to_binary(atom), default} end)
    [ record | Enum.map(fields, fn
                    {name, nil} -> Dict.get(dict, name, nil)
                    {name, [rec]} when is_atom(rec) -> Enum.map(Dict.get(dict, name, []), &(dict_to_record(&1, rec)))
                    {name, rec} when is_atom(rec) -> dict_to_record(Dict.get(dict, name, nil), rec)
                    {name, other} -> Dict.get(dict, name, other)
                end)] |> list_to_tuple
  end

  def load(path) do
    har = File.read!(path) |> JSON.decode!
    har = har["log"]

    dict_to_record(har, HAR)
  end

  def test_load do
    #IEx.Options.set :inspect, limit: 3
    load "testflightapp.com.har"
  end

end
