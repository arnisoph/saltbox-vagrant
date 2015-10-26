sync_custom_modules:
  local.saltutil.sync_all:
    - name: sync custom modules
    - tgt: {{ data['id'] }}

bootstrap_minion:
  local.state.sls:
    - name: bootstrap minion
    - tgt: {{ data['id'] }}
    - arg:
      - saltbox.orchestration.bootstrap
