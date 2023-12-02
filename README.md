# Personal Setup

This repository contains the development environment and tools I like to use. It also
contains common configurations I'll use on code repositories.

## Generative AI Helpers

Unless otherwise specified, all of these tools require you have environment variable
set containing your OpenAI API key called `OPENAI_API_KEY`.

- `zsh-autosuggestions`: my personal fork of the zsh plugin:
  https://github.com/Thomas-McKanna/zsh-autosuggestions. Instructions for setup are in
  the readme. This fork will try to predict your next command using GPT, in addition to
  the normal autosuggestions of this plugin.
- `pyhowdoi`: a simple CLI tool I made to construct bash commands. It can be installed
  with `pip install pyhowdoi` and used like `howdoi recursively search for foobar.txt`.
  See https://github.com/Thomas-McKanna/pyhowdoi.
- `chatgpt-pre-commit-hooks`: a pre-commit hook to automatically generate a commit
  message based on the Git diff. See
  https://github.com/DariuszPorowski/chatgpt-pre-commit-hooks#-hooks for setup
  instructions.

## Dotfiles

These are configuration files that I use for:

  - [zshrc](https://ohmyz.sh/)
  - [tmux](https://github.com/tmux/tmux)
