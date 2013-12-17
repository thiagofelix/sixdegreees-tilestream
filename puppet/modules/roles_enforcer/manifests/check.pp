define roles_enforcer::check() {
  if has_role($name) {
    include "${name}::install"
  } else {
    include "${name}::remove"
  }
}
