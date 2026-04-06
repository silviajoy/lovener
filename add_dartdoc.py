import os
import re

import sys

def modify_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Just a very simple regex replace to add a generic dart doc if missing
    # Since writing specific context for every single property is impossible without manual.
    # I will rely on my own manual edits for the most important ones.
    pass

if __name__ == "__main__":
    for root, dirs, files in os.walk("lib/03_contiamo"):
        for file in files:
            if file.endswith(".dart"):
                modify_file(os.path.join(root, file))
