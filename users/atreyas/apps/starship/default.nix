{ lib, ... }:
let
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.strings.concatStrings [
        "$nix_shell"
        "$os"
        "$directory"
        "$container"
        "$git_branch $git_status"
        "$git_metrics"
        "$python"
        "$nodejs"
        "$deno"
        "$bun"
        "$lua"
        "$rust"
        "$java"
        "$c"
        "$golang"
        "$zig"
        "$haskell"
        "$ruby"
        "$php"
        "$elixir"
        "$docker_context"
        "$kubernetes"
        "$aws"
        "$gcloud"
        "$package"
        "$memory_usage"
        "$jobs"
        "$battery"
        "$cmd_duration"
        "$status"
        "$time"
        "\n$character"
      ];
      status = {
        symbol = "✗";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:red)";
        map_symbol = true;
        disabled = false;
      };
      cmd_duration = {
        min_time = 1000;
        format = "[$duration ](fg:yellow)";
      };
      character = {
        success_symbol = "[❯](bold purple)";
        error_symbol = "[❯](bold red)";
      };
      nix_shell = {
        disabled = false;
        format = "[](fg:white)[ ](bg:white fg:black)[](fg:white) ";
      };
      container = {
        symbol = " 󰏖";
        format = "[$symbol ](yellow dimmed)";
      };
      directory = {
        format = " [](fg:bright-black)[$path](bg:bright-black fg:white)[](fg:bright-black)";
        truncation_length = 4;
        truncation_symbol = "~/…/";
      };
      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        "Videos" = " ";
        "Projects" = "󱌢 ";
        "School" = "󰑴 ";
        "GitHub" = "";
        ".config" = " ";
        "Vault" = "󱉽 ";
      };
      git_branch = {
        symbol = "";
        style = "";
        format = "[ $symbol $branch](fg:purple)(:$remote_branch)";
      };
      os = {
        disabled = false;
        # format = "[](fg:blue)[$symbol](bg:blue fg:black)[](fg:blue)";
        format = "$symbol";
      };
      os.symbols = {
        Arch = "[ ](fg:bright-blue)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:blue)";
        NixOS = "[ ](fg:blue)";
        openSUSE = "[ ](fg:green)";
        SUSE = "[ ](fg:green)";
        Ubuntu = "[ ](fg:bright-purple)";
      };
      # Additional language modules
      python = lang "" "yellow";
      nodejs = lang " " "yellow";
      lua = lang "󰢱" "blue";
      rust = lang "" "red"; #official: 
      java = lang "" "red";
      c = lang "" "blue";
      golang = lang "" "blue";
      deno = lang "🦕" "green";
      bun = lang "🍞" "yellow";
      zig = lang "↯" "yellow";
      haskell = lang "" "purple";
      ruby = lang "" "red";
      php = lang "" "purple";
      elixir = lang "" "purple";

      # Git metrics - show added/deleted lines
      git_metrics = {
        disabled = false;
        added_style = "fg:green";
        deleted_style = "fg:red";
        format = "[+$added]($added_style) [-$deleted]($deleted_style) ";
        only_nonzero_diffs = true;
      };

      # Enhanced git status
      git_status = {
        disabled = false;
        format = "([$all_status$ahead_behind]($style) )";
        style = "fg:purple";
        conflicted = "🏳";
        up_to_date = "";
        untracked = "";
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
        stashed = "";
        modified = "";
        staged = "[++\\($count\\)](green)";
        renamed = "󰁕";
        deleted = "";
      };

      # Docker context
      docker_context = {
        symbol = " ";
        format = "[$symbol$context](fg:blue) ";
        only_with_files = true;
      };

      # Kubernetes
      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[$symbol$context( \\($namespace\\))](fg:cyan) ";
        detect_files = ["k8s" "Dockerfile" "docker-compose.yml"];
      };

      # AWS
      aws = {
        symbol = " ";
        format = "[$symbol($profile )(\\($region\\) )](fg:yellow)";
      };

      # Google Cloud
      gcloud = {
        symbol = "󱇶 ";
        format = "[$symbol$account(@$domain)(\\($region\\))](fg:blue) ";
      };

      # Package version
      package = {
        symbol = "󰏗 ";
        format = "[$symbol$version](fg:green) ";
      };

      # Memory usage
      memory_usage = {
        disabled = false;
        threshold = 75;
        symbol = "󰍛 ";
        format = "$symbol[$ram_pct](fg:yellow) ";
      };

      # Background jobs
      jobs = {
        symbol = "";
        number_threshold = 1;
        symbol_threshold = 1;
        format = "[$symbol$number](fg:blue) ";
      };

      # Battery
      battery = {
        disabled = false;
        format = "[$symbol$percentage]($style) ";
        display = [
          {
            threshold = 10;
            style = "fg:red";
            charging_symbol = " ";
            discharging_symbol = " ";
          }
          {
            threshold = 30;
            style = "fg:yellow";
            charging_symbol = " ";
            discharging_symbol = " ";
          }
          {
            threshold = 100;
            style = "fg:green";
            charging_symbol = " ";
            discharging_symbol = " ";
          }
        ];
      };

      # Time
      time = {
        disabled = false;
        time_format = "%T";
        format = "[ $time](fg:bright-black) ";
      };
    };
  };
}
