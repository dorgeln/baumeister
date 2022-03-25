# Copyright 2017 RedHat, inc
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.
#############################################
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    name: ansible_var_prefix
    version_added: "2.10"
    short_description: In charge of loading group_vars and host_vars
    requirements:
        - Enabled in configuration
    description:
        - Loads YAML vars into corresponding groups/hosts in group_vars/ and host_vars/ directories.
        - Files are restricted by extension to one of .yaml, .json, .yml or no extension.
        - Hidden (starting with '.') and backup (ending with '~') files and directories are ignored.
        - Only applies to inventory sources that are existing paths.
        - Starting in 2.10, this plugin requires enabling and is enabled by default.
    options:
      stage:
        ini:
          - key: stage
            section: vars_host_group_vars
        env:
          - name: ANSIBLE_VARS_PLUGIN_STAGE
      _valid_extensions:
        default: [".yml", ".yaml", ".json"]
        description:
          - "Check all of these extensions when looking for 'variable' files which should be YAML or JSON or vaulted versions of these."
          - 'This affects vars_files, include_vars, inventory and vars plugins among others.'
        env:
          - name: ANSIBLE_YAML_FILENAME_EXT
        ini:
          - key: yaml_valid_extensions
            section: defaults
        type: list
        elements: string
    extends_documentation_fragment:
      - vars_plugin_staging
'''

import os
from ansible import constants as C
from ansible.errors import AnsibleParserError
from ansible.plugins.vars import BaseVarsPlugin


FOUND = {}  # type: dict[str, list[str]]

class VarsModule(BaseVarsPlugin):

    REQUIRES_WHITELIST = True

    def get_vars(self, loader, path, entities, cache=True,prefix="ANSIBLE_VAR_"):
        ''' load all variables from os environment that start with prefix '''

        if not isinstance(entities, list):
            entities = [entities]

        super(VarsModule, self).get_vars(loader, path, entities)

        data = {}

        for env_var, env_value in os.environ.items():
          if env_var.startswith(prefix):
            data[env_var.lstrip(prefix)]=env_value
        
        return data