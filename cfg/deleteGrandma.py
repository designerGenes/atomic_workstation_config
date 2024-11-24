#!/Users/jadennation/dev/bin/venv/bin/python

import argparse
import os
import random
import re
import shutil
import string
import subprocess
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed
import shlex

import argcomplete


def is_numeric(val):
    return bool(re.match(r'^-?[0-9]+(\.[0-9]+)?$', val))

def print_with_status(msg, remaining, total):
    msg = msg.ljust(80 - len(f"({remaining} / {total})"))
    print(f"{msg}({remaining} / {total})")



def shred_file(file_path, passes, is_quiet=False, is_secure_quiet=False):
    # Escape the file path
    escaped_file_path = shlex.quote(file_path)
    command = f"gshred -f -n {passes} -z -u {escaped_file_path}"
    if not (is_quiet or is_secure_quiet):
        command += " -v"
    else:
        # make gshred output quiet by piping to /dev/null
        command += " > /dev/null 2>&1"
    subprocess.run(command, shell=True, check=True)
    return file_path

def random_string(length=10):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def delete_files(directory, passes, quiet, dry_run, secure_quiet):
    if not os.path.exists(directory):
        print(f"Error: Directory '{directory}' does not exist.")
        sys.exit(1)

    with ProcessPoolExecutor() as executor:
        futures = []
        for root, dirs, files in os.walk(directory):
            total = len(files)
            remaining = total
            for file in files:
                file_path = os.path.join(root, file)
                if dry_run:
                    print(f"Would delete: {file_path}")
                else:
                    futures.append(executor.submit(shred_file, file_path, passes, quiet, secure_quiet))

        for future in as_completed(futures):
            file_path = future.result()
            remaining -= 1
            if not quiet:
                if secure_quiet:
                    print_with_status("*" * len(file_path), remaining, total)
                else:
                    print_with_status(file_path, remaining, total)

    # Rename and delete subdirectories
    if not dry_run:
        for root, dirs, files in os.walk(directory, topdown=False):
            for dir in dirs:
                dir_path = os.path.join(root, dir)
                new_name = random_string()
                new_path = os.path.join(root, new_name)
                os.rename(dir_path, new_path)
                shutil.rmtree(new_path)

        # print completion once all files and subdirectories have been deleted/shredded
        print(f"Completed deletion of {directory}")

def main():
    parser = argparse.ArgumentParser(description="Securely delete files in a directory.")
    parser.add_argument('directory', nargs='?', default=os.getcwd(), help="Directory to shred files in")
    parser.add_argument('--passes', '-p', type=int, default=10, help="Number of passes for gshred")
    parser.add_argument('--quiet', '-q', action='store_true', help="Suppress output except to acknowledge each file that has been fully deleted")
    parser.add_argument('--dry-run', '-dr', action='store_true', help="List all files that would be deleted, but do not actually delete any files")
    parser.add_argument('--secure-quiet', '-sq', action='store_true', help="Replace all file names in printed output with asterisks")

    argcomplete.autocomplete(parser)
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: Directory '{args.directory}' does not exist.")
        sys.exit(1)

    delete_files(args.directory, args.passes, args.quiet, args.dry_run, args.secure_quiet)

if __name__ == "__main__":
    main()
