#!/usr/bin/env elixir

# For the --url, choose an image path relative to REMOTE_HOST_FILESYSTEM_ROOT
# bin/imgproxy-url --prefix "https://$APP_DOMAIN" --key "$IMGPROXY_KEY" --salt "$IMGPROXY_SALT" --path "/path/to/image.jpg"

Mix.install([
  {:helpful_options, "~> 0.3"},
  {:imgproxy, "~> 3.1",
   git: "https://github.com/bmuller/imgproxy.git", ref: "b181f2932b2f7f2448a3ff873d9b2b105d9a32ba"},
  {:req, "~> 0.4"}
])

defmodule CheckImgproxyUrl do
  @moduledoc false

  @options_switches [
    path: %{type: :string, required: true},
    prefix: %{type: :string, required: true},
    key: %{type: :string},
    salt: %{type: :string},
    width: %{type: :integer}
  ]

  def run(args) do
    {:ok, options} = parse_args(args)
    url = build_url(options)
    :ok = check_url(url)
  end

  def parse_args(args) do
    case HelpfulOptions.parse(args, switches: @options_switches) do
      {:ok, options, []} ->
        {:ok, options}

      {:error, reason} ->
        raise "Error: #{reason}"
    end
  end

  defp build_url(options) do
    source_url = source_url(options.path)

    %Imgproxy{
      source_url: source_url,
      prefix: options.prefix
    }
    |> optionally_set_key(options[:key])
    |> optionally_set_salt(options[:salt])
    |> optionally_set_width(options[:width])
    |> Imgproxy.set_source_url_encoding(:plain)
    |> Imgproxy.to_string()
  end

  defp optionally_set_key(img, nil) do
    if System.get_env("IMGPROXY_KEY") do
      %{img | key: System.get_env("IMGPROXY_KEY")}
    else
      img
    end
  end

  defp optionally_set_key(img, key), do: %{img | key: key}

  defp optionally_set_salt(img, nil) do
    if System.get_env("IMGPROXY_SALT") do
      %{img | salt: System.get_env("IMGPROXY_SALT")}
    else
      img
    end
  end

  defp optionally_set_salt(img, salt), do: %{img | salt: salt}

  defp optionally_set_width(img, nil), do: img

  defp optionally_set_width(img, width) do
    Imgproxy.resize(img, width, 0)
  end

  defp source_url("/" <> path) do
    base = URI.new!("local://")
    uri = %{base | path: "/#{path}"}
    to_string(uri)
  end

  defp source_url(path), do: source_url("/#{path}")

  def check_url(url) do
    IO.puts("Checking URL: #{inspect(url)}")

    case Req.get!(url) do
      %Req.Response{status: 200} ->
        IO.puts("URL is valid and accessible")
        :ok

      %Req.Response{} = response ->
        raise "Unexpected response: #{inspect(response)}"
    end
  end
end

CheckImgproxyUrl.run(System.argv())
System.halt(0)
