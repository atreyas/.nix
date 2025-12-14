{ ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    history = {
      size = 20000;
      save = 20000;
      path = "$HOME/.history";
    };

    defaultKeymap = "viins";

    shellAliases = {
      g = "git";
      ls = "eza";
      cat = "bat";
    };

    initContent = ''
      # Completion settings
      zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate _prefix
      zstyle ':completion:*' completions 1
      zstyle ':completion:*' glob 1
      zstyle ':completion:*' list-colors '''
      zstyle ':completion:*' matcher-list ''' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
      zstyle ':completion:*' max-errors 2
      zstyle ':completion:*' menu select=1
      zstyle ':completion:*' prompt 'errors: %e'
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' substitute 1

      # Zellij auto-start
      if [[ -z "$ZELLIJ" ]]; then
          if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
              zellij attach -c
          else
              zellij
          fi

          if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
              exit
          fi
      fi

      # Initialize starship, direnv, zoxide
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh)"
    '';
  };
}
