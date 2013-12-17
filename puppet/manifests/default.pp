node default {
  class { 'roles_enforcer':
    valid_roles => ['tilestream']
  }
}