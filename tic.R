add_package_checks()

if (Sys.getenv("id_rsa") != "") {
  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `ci()$is_tag()`: Only for tags, not for branches
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_code_step(
      pkgbuild::compile_dll(),
      prepare_call = remotes::install_github("r-lib/pkgbuild")
    ) %>% 
    add_step(step_build_pkgdown(run_dont_run = TRUE)) %>%
    add_code_step(system('echo "tsibble.tidyverts.org" > docs/CNAME')) %>% 
    add_step(step_push_deploy(path = "docs/", branch = "gh-pages"))
}