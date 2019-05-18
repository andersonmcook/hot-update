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
        "deps.get --only prod",
        "compile",
        "cmd --app a mix prepare",
        fn _ ->
          System.cmd(
            "mix",
            ["release", "--name", "a", "--env", "prod"],
            env: [{"MIX_ENV", "prod"}],
            into: IO.stream(:stdio, :line)
          )
        end,
        fn _ ->
          System.cmd(
            "sh",
            ["_build/prod/rel/a/bin/a", "foreground"],
            env: [{"PORT", "4000"}],
            into: IO.stream(:stdio, :line)
          )
        end
      ]
    ]
  end
end
