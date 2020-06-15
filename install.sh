#!/usr/bin/env bash

VIRTUALENV_DIR=/tmp/ansible

set -e

if [ ! $(command -v python3) ]; then
	echo "we require python3"
	exit 1
else
	echo "we have python3"
fi

if [ ! $(command -v pip) ]; then
	echo "we require pip"
	exit 1
else
	echo "we have pip"
fi

setup_venv() {
	python3 -m pip install virtualenv pexpect
	python3 -m virtualenv "$VIRTUALENV_DIR"
	source "$VIRTUALENV_DIR"/bin/activate
	pip install ansible pexpect
}

usage() {
  echo "./install.sh [options] [roles...]"
  echo "Supported options:"
  echo "  -h/--help"
  echo "  -v/--verbose (repeat up to four times for more verbosity)"
  echo "Other options (passed through to Ansible):"
  echo "  --check"
  echo "  --step"
  echo "  --start-at-task='role | task'"
  echo "Supported roles:"
  for ROLE in $(ls roles); do
	echo "  $ROLE"
	echo "    $(cat roles/$ROLE/description)"
  done
}

EXTRA_ARGS=()
while [ $# -gt 0 ]; do
  if [ "$1" = '--verbose' -o "$1" = '-v' ]; then
	VERBOSE=$((VERBOSE + 1))
  elif [ "$1" = '-vv' ]; then
	VERBOSE=$((VERBOSE + 2))
  elif [ "$1" = '-vvv' ]; then
	VERBOSE=$((VERBOSE + 3))
  elif [ "$1" = '-vvvv' ]; then
	VERBOSE=$((VERBOSE + 4))
  elif [ "$1" = '--help' -o "$1" = '-h' -o "$1" = 'help' ]; then
	usage
	exit
  elif [ -n "$1" ]; then
	if [ -d "roles/$1" ]; then
	  if [ -z "$ROLES" ]; then
		ROLES="--tags $1"
	  else
		ROLES="$ROLES,$1"
	  fi
	elif [[ "$1" == --* ]]; then
	  EXTRA_ARGS+=("$1")
	else
	  echo "Unrecognized argument(s): $*"
	  usage
	  exit 1
	fi
  fi
  shift
done

if [[ $VERBOSE ]]; then
  if [ $VERBOSE -ge 4 ]; then
	echo 'Enabling extremely verbose output'
	set -x
  fi
else
  trap 'echo "Exiting: run with -v/--verbose for more info"' EXIT
fi

# setup install environment
setup_venv

HOST_OS=$(uname)

if [ "$HOST_OS" = 'Linux' ]; then
  ansible-playbook --ask-become-pass -i inventory ${VERBOSE+-$(printf 'v%.0s' $(seq $VERBOSE))} ${ROLES} "${EXTRA_ARGS[@]}" linux.yml
else
  echo "Unknown host OS: $HOST_OS"
  exit 1
fi

# tear down install environment (where ansible is installed)
deactivate
rm -rf $VIRTUALENV_DIR

trap - EXIT
