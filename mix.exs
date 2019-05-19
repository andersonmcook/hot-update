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

  # this causes everything to hang
  # defp version(app) do
  #   app
  #   |> String.to_atom()
  #   |> Mix.Project.in_project(
  #     project()
  #     |> Keyword.get(:apps_path)
  #     |> Path.join(app),
  #     &Keyword.get(&1.project(), :version)
  #   )
  #   |> IO.inspect()
  # end

  defp release(app, vsn) do
    [
      fn _ -> Mix.env(:prod) end,
      "deps.get --only prod",
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
          ["_build/prod/rel/#{app}/releases/#{vsn}/#{app}.tar.gz", @deploy_path],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "tar",
          ["xvf", "#{app}.tar.gz"],
          cd: @deploy_path,
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "sh",
          ["#{@deploy_path}/bin/#{app}", "console"],
          env: [{"PORT", "4000"}],
          into: IO.stream(:stdio, :line)
        )
      end
    ]
  end

  defp upgrade(app, vsn) do
    [
      fn _ -> Mix.env(:prod) end,
      "deps.get --only prod",
      "compile",
      "cmd --app #{app} mix prepare",
      fn _ ->
        System.cmd(
          "mix",
          ["release", "--name", app, "--env", "prod", "--upgrade"],
          env: [{"MIX_ENV", "prod"}],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "mkdir",
          ["-p", "releases/#{app}/#{vsn}"],
          cd: @deploy_path,
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "cp",
          [
            "_build/prod/rel/#{app}/releases/#{vsn}/#{app}.tar.gz",
            "#{@deploy_path}/releases/#{app}/#{vsn}/"
          ],
          into: IO.stream(:stdio, :line)
        )
      end,
      fn _ ->
        System.cmd(
          "sh",
          ["#{@deploy_path}/bin/#{app}", "upgrade", vsn],
          into: IO.stream(:stdio, :line)
        )
      end
    ]
  end
end
