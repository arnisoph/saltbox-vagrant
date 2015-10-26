provision_default_states:
  local.state.highstate:
    - name: provision default states
    - tgt: {{ data['id'] }}
