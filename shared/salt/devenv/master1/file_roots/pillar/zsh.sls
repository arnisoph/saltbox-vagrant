zsh:
  lookup:
    sls_include:
      - users
    ohmyzsh:
      setup: True
      src: https://github.com/robbyrussell/oh-my-zsh
  config:
    manage:
      users:
        root: {}

users:
  manage:
    root:
      shell: /bin/zsh
