#!/bin/bash

# === 配置文件列表 ===
CONFIG_FILES=(.zshrc .bashrc .bash_profile .zprofile .vimrc)
DOTFILES_DIR="$HOME/dotfiles"

# === 创建符号链接 ===
echo "还原配置文件符号链接..."
for file in "${CONFIG_FILES[@]}"; do
  if [ -f "$DOTFILES_DIR/$file" ]; then
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    echo "  链接 $file → $DOTFILES_DIR/$file"
  else
    echo "  跳过 $file （在 dotfiles 中未找到）"
  fi
done

echo "✅ dotfiles 已还原到 $HOME"
