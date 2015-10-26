#provision_default_states:
#  local.state.sls:
#    - name: provision default states
#    - tgt: {{ data['id'] }}
#    - arg:
#      - repos,git,tools,zsh,users,vim

provision_default_states:
  local.state.highstate:
    - name: provision default states
    - tgt: {{ data['id'] }}
