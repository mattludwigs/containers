use Mix.Config

config :mix_test_watch,
 tasks: [
   "deps.get",
   "docs",
   "test",
   "dialyzer",
 ]
