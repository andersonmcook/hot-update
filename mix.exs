defmodule Umbrella.MixProject do
  use Mix.Project

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
      release_a: release("a", "0.1.0", "../local_deploy"),
      release_b: release("b", "0.1.0", "../local_deploy")
    ]
  end

  defp release(app, vsn, path) do
    [
      fn _ -> Mix.env(:prod) end,
      "compile",
      "cmd --app #{app} mix prepare",
      fn _ ->
        System.cmd(
          "mix",
          ["release", "--name", app, "--env", "prod"],
          env: [{"MIX_ENV", "prod"}],
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
end
