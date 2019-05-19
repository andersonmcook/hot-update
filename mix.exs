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
      release_a: [
        fn _ -> Mix.env(:prod) end,
        "cmd --app a mix prepare",
        fn _ ->
          System.cmd(
            "mix",
            ["release", "--name", "a", "--env", "prod"],
            into: IO.stream(:stdio, :line)
          )
        end,
        fn _ ->
          System.cmd(
            "cp",
            ["_build/prod/rel/a/releases/0.1.0/a.tar.gz", "../local_deploy"],
            into: IO.stream(:stdio, :line)
          )
        end,
        fn _ ->
          System.cmd(
            "tar",
            ["xvf", "a.tar.gz"],
            cd: "../local_deploy",
            into: IO.stream(:stdio, :line)
          )
        end,
        fn _ ->
          System.cmd(
            "sh",
            ["../local_deploy/bin/a", "console"],
            env: [{"PORT", "4000"}],
            into: IO.stream(:stdio, :line)
          )
        end
      ]
    ]
  end
end
