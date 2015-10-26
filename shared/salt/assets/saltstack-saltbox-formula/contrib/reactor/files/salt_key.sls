#{% if 'act' in data and data['act'] == 'accept' %}
#bootstrap_minion:
#  local.state.sls:
#    - name: bootstrap minion
#    - tgt: {{ data['id'] }}
#    - arg:
#      - saltbox.orchestration.bootstrap
#{% endif %}
