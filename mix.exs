defmodule Umbrella.MixProject do
  use Mix.Project

  @deploy_path "../local_deploy"

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:distillery, "~> 2.0"}]
  end

  defp aliases do
    [
      release_a: release("a", "0.1.0"),
      release_b: release("b", "0.1.0"),
      upgrade_a: upgrade("a", "0.2.0"),
      upgrade_b: upgrade("b", "0.2.0")
    ]
  end

  defp release(app, vsn) do
    path = deploy_path(app)

    [
      "deps.get --only prod",
      "compile",
      "cmd --app #{app} mix prepare",
      "release --name #{app} --env prod",
      fn _ ->
        System.cmd(
          "mkdir",
          ["-p", path],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "cp",
          ["_build/prod/rel/#{app}/releases/#{vsn}/#{app}.tar.gz", path],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "tar",
          ["xvf", "#{app}.tar.gz"],
          cd: path,
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "sh",
          ["#{path}/bin/#{app}", "console"],
          env: [{"PORT", "4000"}],
          into: IO.stream(:stdio, :line)
        )
      end
    ]
  end

  defp upgrade(app, vsn) do
    path = deploy_path(app)

    [
      "deps.get --only prod",
      "compile",
      "cmd --app #{app} mix prepare",
      "release --name #{app} --env prod --upgrade",
      fn _ ->
        System.cmd(
          "mkdir",
          ["-p", "releases/#{vsn}"],
          cd: path,
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "cp",
          ["_build/prod/rel/#{app}/releases/#{vsn}/#{app}.tar.gz", "#{path}/releases/#{vsn}"],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "sh",
          ["#{path}/bin/#{app}", "upgrade", vsn],
          into: IO.stream(:stdio, :line)
        )
      end
    ]
  end

  defp deploy_path(app), do: @deploy_path <> "/" <> app
end
