# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  # This sets the default release built by `mix release`
  default_release: :default,
  # This sets the default environment used by `mix release`
  default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/config/distillery.html

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  # If you are running Phoenix, you should make sure that
  # server: true is set and the code reloader is disabled,
  # even in dev mode.
  # It is recommended that you build with MIX_ENV=prod and pass
  # the --env flag to Distillery explicitly if you want to use
  # dev mode.
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"319Q&`Og~8nYf::Y<AznwDuC]B$gS^!k>9>7<C6dwmn{SYLbf3:fRT~!ZiUO%&Om")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"8s4!qm*kIGFizar.X_ib2*y:eslb&e*09|tD(FXZhL}m2JE;.9rtl6$v*4JB177x")
  set(vm_args: "rel/vm.args")
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :a do
  set(version: current_version(:a))

  set(
    applications: [
      :a,
      :runtime_tools
    ]
  )
end

release :b do
  set(version: current_version(:b))

  set(
    applications: [
      :b,
      :runtime_tools
    ]
  )
end
