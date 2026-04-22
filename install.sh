#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${HOME}/.dotfiles-backup/${TIMESTAMP}"

mkdir -p "${BACKUP_DIR}"
mkdir -p "${HOME}/.config"

copied_items=()
skipped_items=()

backup_if_exists() {
    local target="$1"
    if [ -e "${target}" ] || [ -L "${target}" ]; then
        local rel="${target#${HOME}/}"
        mkdir -p "${BACKUP_DIR}/$(dirname "${rel}")"
        cp -a "${target}" "${BACKUP_DIR}/${rel}"
    fi
}

install_config_dir() {
    local name="$1"
    local src="${DOTFILES_DIR}/${name}"
    local dst="${HOME}/.config/${name}"

    if [ -d "${src}" ]; then
        backup_if_exists "${dst}"
        rm -rf "${dst}"
        cp -a "${src}" "${dst}"
        copied_items+=("~/.config/${name}")
    else
        skipped_items+=("${name} (missing in dotfiles root)")
    fi
}

install_config_file() {
    local name="$1"
    local src="${DOTFILES_DIR}/${name}"
    local dst="${HOME}/.config/${name}"

    if [ -f "${src}" ]; then
        backup_if_exists "${dst}"
        cp -a "${src}" "${dst}"
        copied_items+=("~/.config/${name}")
    else
        skipped_items+=("${name} (missing in dotfiles root)")
    fi
}

install_home_file() {
    local name="$1"
    local src="${DOTFILES_DIR}/${name}"
    local dst="${HOME}/${name}"

    if [ -f "${src}" ]; then
        backup_if_exists "${dst}"
        cp -a "${src}" "${dst}"
        copied_items+=("~/${name}")
    else
        skipped_items+=("${name} (missing in dotfiles root)")
    fi
}

install_home_dir() {
    local name="$1"
    local src="${DOTFILES_DIR}/${name}"
    local dst="${HOME}/${name}"

    if [ -d "${src}" ]; then
        backup_if_exists "${dst}"
        rm -rf "${dst}"
        cp -a "${src}" "${dst}"
        copied_items+=("~/${name}")
    else
        skipped_items+=("${name} (missing in dotfiles root)")
    fi
}

for dir in i3 polybar picom dunst kitty scripts gtk-2.0 gtk-3.0 gtk-4.0; do
    install_config_dir "${dir}"
done

for file in mimeapps.list xdg-terminals.list GNOME-xdg-terminals.list ubuntu-xdg-terminals.list; do
    install_config_file "${file}"
done

for file in .zshrc .zshenv .p10k.zsh .zshrc.pre-oh-my-zsh .shell.pre-oh-my-zsh; do
    install_home_file "${file}"
done

install_home_dir ".oh-my-zsh"

if [ -d "${DOTFILES_DIR}/fonts" ]; then
    mkdir -p "${HOME}/.local/share/fonts"
    while IFS= read -r -d '' font_file; do
        cp -a "${font_file}" "${HOME}/.local/share/fonts/"
    done < <(find "${DOTFILES_DIR}/fonts" -maxdepth 1 -type f \( -iname "*.ttf" -o -iname "*.otf" \) -print0)

    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "${HOME}/.local/share/fonts" >/dev/null 2>&1 || true
    fi
    copied_items+=("~/.local/share/fonts (from dotfiles/fonts)")
else
    skipped_items+=("fonts (missing in dotfiles root)")
fi

echo "Install complete."
echo "Backup directory: ${BACKUP_DIR}"

if [ "${#copied_items[@]}" -gt 0 ]; then
    echo
    echo "Installed items:"
    for item in "${copied_items[@]}"; do
        echo "  - ${item}"
    done
fi

if [ "${#skipped_items[@]}" -gt 0 ]; then
    echo
    echo "Skipped items:"
    for item in "${skipped_items[@]}"; do
        echo "  - ${item}"
    done
fi

echo
echo "Reload i3:"
echo "  i3-msg reload && i3-msg restart"
