#!/usr/bin/env zsh
# Secrets. Nothing secret is stored in this repo -- values are read from the
# macOS Keychain (or libsecret on Linux) at the moment they are needed.
#
# Store a secret once per machine, letting `security` prompt for the value so it
# never lands in argv or in shell history:
#
#   security add-generic-password -s jira-pat -a "$USER" -w
#
# Inspect or replace it later:
#
#   security find-generic-password -s jira-pat -w
#   security delete-generic-password -s jira-pat

# secret <service-name> -> prints the secret, or nothing and returns non-zero.
secret() {
  local name=$1
  [[ -n $name ]] || { print -u2 'usage: secret <service-name>'; return 2; }
  if (( $+commands[security] )); then
    security find-generic-password -s "$name" -w 2>/dev/null
  elif (( $+commands[secret-tool] )); then
    secret-tool lookup service "$name" 2>/dev/null
  else
    print -u2 'secret: no keychain backend (security / secret-tool) available'
    return 1
  fi
}

# ---------------------------------------------------------------------- jira
# jira-cli reads JIRA_API_TOKEN from the environment. The auth type is not a
# secret, so it can be exported eagerly.
export JIRA_AUTH_TYPE=bearer

# Resolve the token on first use only. Doing it at startup would add a Keychain
# read -- and potentially an unlock prompt -- to every single shell.
jira() {
  if [[ -z $JIRA_API_TOKEN ]]; then
    export JIRA_API_TOKEN="$(secret jira-pat)"
    if [[ -z $JIRA_API_TOKEN ]]; then
      print -u2 "jira: no 'jira-pat' in the keychain. Add it with:"
      print -u2 '  security add-generic-password -s jira-pat -a "$USER" -w'
      return 1
    fi
  fi
  command jira "$@"
}
