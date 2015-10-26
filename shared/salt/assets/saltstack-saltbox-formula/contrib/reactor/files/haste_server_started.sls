update_haproxy_config:
  local.state.sls:
    - name: update haproxy config
    - tgt: fe*
    - arg:
      - saltbox.orchestration.haproxy
