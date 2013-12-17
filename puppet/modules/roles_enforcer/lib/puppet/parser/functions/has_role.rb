# -*- encoding : utf-8 -*-
module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
    current_roles = lookupvar('roles')
    current_roles.split(',').include? args.first
  end
end
