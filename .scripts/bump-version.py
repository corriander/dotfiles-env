import enum
import subprocess

from dunamai import Version

class Increment(enum.Enum):
	patch = 2
	minor = 1
	major = 0

def run(*args):
	return subprocess.check_call(['git'] + list(args))

def tag(v: Version):
	run('tag', '-a',

arg_parser = argparse.ArgumentParser(description='Parse parameters')
arg_parser.add_argument('action', type=str)

current_version = Version.from_git()

if __name__ == '__main__':
	args, unknown_args = arg_parser.parse_known_args()

	if args.verb == 'release':
		new_version = Version(current_version.base, stage=('rc', 0))
	else:
		idx = Increment[args.verb].value
		new_version = current_version.bump(idx)
