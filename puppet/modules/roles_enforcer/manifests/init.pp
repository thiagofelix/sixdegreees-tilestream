class roles_enforcer($valid_roles = []) {
  roles_enforcer::check { $valid_roles: }
}
