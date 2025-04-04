#!/bin/bash

# === 配置文件列表 ===
CONFIG_FILES=(.zshrc .bashrc .bash_profile .zprofile .vimrc)
DOTFILES_DIR="$HOME/dotfiles"

# === 创建 dotfiles 目录（如果还没有） ===
mkdir -p "$DOTFILES_DIR"

# === 添加提示文件，避免误删 ===
NOTICE_FILE="$DOTFILES_DIR/DO_NOT_DELETE_THIS_FOLDER"
touch "$NOTICE_FILE"

# === 备份并复制配置文件 ===
echo "备份并复制配置文件到 $DOTFILES_DIR"
for file in "${CONFIG_FILES[@]}"; do
  if [ -f "$HOME/$file" ]; then
    if [ ! "$HOME/$file" -ef "$DOTFILES_DIR/$file" ]; then
      echo "  复制 $file → $DOTFILES_DIR/$file"
      cp "$HOME/$file" "$DOTFILES_DIR/$file"
    else
      echo "  无需复制 $file ，因为已位于 $DOTFILES_DIR/$file"
    fi
  fi
    done

# === 添加注释提示（如未包含） ===
echo "添加注释提醒（如缺失）..."
for file in "${CONFIG_FILES[@]}"; do
  target="$DOTFILES_DIR/$file"
  if [ -f "$target" ] && ! grep -q "This file is symlinked from" "$target"; then
    if [[ "$file" == ".vimrc" ]]; then
      comment="\" NOTE: This file is symlinked from ~/dotfiles/$file"
    else
      comment="# NOTE: This file is symlinked from ~/dotfiles/$file"
    fi
    echo "$comment" | cat - "$target" > "$target.tmp" && mv "$target.tmp" "$target"
    echo "  注释添加到 $file"
  fi
    done

# === 创建符号链接 ===
echo "创建配置文件符号链接..."
for file in "${CONFIG_FILES[@]}"; do
  if [ -f "$DOTFILES_DIR/$file" ]; then
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    echo "  链接 $file → $DOTFILES_DIR/$file"
  fi
    done

# === 完成提示 ===
echo "✔️ dotfiles 设置完成。配置文件已链接到 ${DOTFILES_DIR} 。"
