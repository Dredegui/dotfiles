import json
import os
import sys

generated_file_colors = os.path.expanduser("~/.cache/m3-colors/vscode-settings.json")
target_file = os.path.expanduser("~/.config/Code/User/settings.json")

def update_vscode_settings():
    if not os.path.exists(generated_file_colors):
        print(f"Generated colors file not found: {generated_file_colors}")
        return

    with open(generated_file_colors, 'r') as f:
        generated_colors = json.load(f)

    if not os.path.exists(target_file):
        print(f"VSCode settings file not found: {target_file}")
        return

    with open(target_file, 'r') as f:
        try:
            vscode_settings = json.load(f)
        except json.JSONDecodeError:
            vscode_settings = {}

    vscode_settings['workbench.colorCustomizations'] = generated_colors['workbench.colorCustomizations']
    
    with open(target_file, 'w') as f:
        json.dump(vscode_settings, f, indent=4)

if __name__ == "__main__":
    update_vscode_settings()
