#!/usr/bin/env bash
#
# Show version info (version name, version code, SDKs, install dates, …) for an
# app installed on a connected Android device.
#
#   android_app_info.sh                  # pick device + package interactively
#   android_app_info.sh com.foo.bar      # exact package name
#   android_app_info.sh foo              # fragment: narrows the package picker
#   android_app_info.sh -s <serial> foo  # skip the device prompt
#
# fzf is used for the pickers when present, otherwise a numbered menu is shown.

set -uo pipefail

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
  sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

serial=${ANDROID_SERIAL:-}
filter=""

while (( $# )); do
  case $1 in
    -s|--serial) serial=${2:-}; [[ -n $serial ]] || die "-s needs a serial"; shift 2 ;;
    -h|--help)   usage 0 ;;
    -*)          die "unknown option: $1 (try --help)" ;;
    *)           filter=$1; shift ;;
  esac
done

# adb is not always on $PATH (zshrc only adds it when the SDK exists).
if ! command -v adb >/dev/null 2>&1; then
  for dir in "${ANDROID_HOME:-}/platform-tools" "$HOME/Library/Android/sdk/platform-tools"; do
    [[ -x $dir/adb ]] && { PATH=$dir:$PATH; break; }
  done
fi
command -v adb >/dev/null 2>&1 || die "adb not found on \$PATH nor in \$ANDROID_HOME/platform-tools"

# pick <prompt>  — reads candidate lines on stdin, echoes the chosen one.
# A single candidate is returned without asking.
pick() {
  local prompt=$1 lines
  lines=$(cat)
  [[ -n $lines ]] || return 1
  if [[ $(grep -c '' <<<"$lines") -eq 1 ]]; then printf '%s\n' "$lines"; return 0; fi
  if command -v fzf >/dev/null 2>&1; then
    fzf --prompt="$prompt > " --height=40% --reverse --select-1 --exit-0 <<<"$lines"
    return
  fi
  local -a items=()
  while IFS= read -r l; do items+=("$l"); done <<<"$lines"
  local i
  for i in "${!items[@]}"; do printf '%3d) %s\n' $((i + 1)) "${items[i]}" >&2; done
  local choice
  read -r -p "$prompt [1-${#items[@]}]: " choice < /dev/tty || return 1
  [[ $choice =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#items[@]} )) \
    || die "invalid choice: $choice"
  printf '%s\n' "${items[choice - 1]}"
}

# ---------------------------------------------------------------- device ------
# Every adb call reads from /dev/null: `adb shell` otherwise swallows the tty
# input the pickers below are about to read.

# device_info <serial> — sets dev_name/dev_release/dev_sdk in one adb round trip.
# `adb devices -l` only knows the model code (CTR-L81, sdk_gphone64_arm64), which
# is useless for telling two phones apart, so ask the device what it calls itself.
device_info() {
  local props avd avd_legacy mkt vendor_mkt manufacturer model
  props=$(adb -s "$1" shell 'getprop ro.boot.qemu.avd_name; getprop ro.kernel.qemu.avd_name; getprop ro.config.marketing_name; getprop ro.product.vendor.marketname; getprop ro.product.manufacturer; getprop ro.product.model; getprop ro.build.version.release; getprop ro.build.version.sdk' </dev/null 2>/dev/null | tr -d '\r')
  # getprop prints an empty line for an unset property, so the fields stay aligned
  # with the order above — one read per getprop, no more, no less.
  { IFS= read -r avd; IFS= read -r avd_legacy; IFS= read -r mkt; IFS= read -r vendor_mkt
    IFS= read -r manufacturer; IFS= read -r model; IFS= read -r dev_release; IFS= read -r dev_sdk; } <<<"$props"
  [[ -n $avd ]] || avd=$avd_legacy   # older emulators expose the AVD under ro.kernel.*

  if [[ -n $avd ]]; then
    dev_name="${avd//_/ } (emulator)"
  else
    dev_name=${mkt:-$vendor_mkt}
    # Not every vendor ships a marketing name; fall back to what adb can see.
    [[ -n $dev_name ]] || dev_name="$manufacturer $model"
    # Keep the model alongside a marketing name ("HUAWEI nova 12i (CTR-L81)") so
    # the device is still identifiable by the code adb and gradle report.
    [[ -n $model && $dev_name != *"$model"* ]] && dev_name="$dev_name ($model)"
  fi
  dev_name=$(sed -e 's/^ *//' -e 's/ *$//' <<<"$dev_name")
  [[ -n $dev_name ]] || dev_name="unknown device"
}

if [[ -z $serial ]]; then
  devices=$(adb devices -l </dev/null | tr -d '\r' | sed -e '1d' -e '/^$/d')
  [[ -n $devices ]] || die "no android device detected (is it plugged in / an emulator running?)"

  # Warn about devices we cannot query instead of silently dropping them.
  while IFS= read -r l; do
    printf 'warning: skipping %s (%s)\n' "${l%% *}" "$(awk '{print $2}' <<<"$l")" >&2
  done < <(awk '$2 != "device"' <<<"$devices")

  candidates=""
  while IFS= read -r s; do
    [[ -n $s ]] || continue
    device_info "$s"
    candidates+="$dev_name · Android $dev_release"$'\t'"$s"$'\n'
  done < <(awk '$2 == "device" {print $1}' <<<"$devices")

  choice=$(printf '%s' "$candidates" | pick "device") || die "no device selected"
  serial=${choice##*$'\t'}
fi
[[ -n $serial ]] || die "no device selected"

adb -s "$serial" get-state </dev/null >/dev/null 2>&1 || die "device '$serial' is not available"
device_info "$serial"

# --------------------------------------------------------------- package ------
packages=$(adb -s "$serial" shell pm list packages </dev/null 2>/dev/null | tr -d '\r' | sed 's/^package://' | sort)
[[ -n $packages ]] || die "could not list packages on '$serial'"

if [[ -n $filter ]]; then
  # An exact package name wins outright, so `com.android.chrome` does not open a
  # picker just because `com.android.chrome.beta` is installed too.
  if grep -qxF -- "$filter" <<<"$packages"; then
    matches=$filter
  else
    matches=$(grep -iF -- "$filter" <<<"$packages")
    [[ -n $matches ]] || die "no installed package matches '$filter' on $serial"
  fi
else
  matches=$packages
fi

pkg=$(pick "package" <<<"$matches") || die "no package selected"
[[ -n $pkg ]] || die "no package selected"

# ------------------------------------------------------------------ dump ------
dump=$(adb -s "$serial" shell dumpsys package "$pkg" </dev/null 2>/dev/null | tr -d '\r')
grep -q "Package \[$pkg\]" <<<"$dump" || die "'$pkg' is not installed on $serial"

# Rest of the line after `key=` (values may contain spaces, e.g. install dates).
line_val() { sed -n "s/^[[:space:]]*$1=\(.*\)$/\1/p" <<<"$dump" | head -1; }
# Single token, for keys that share a line (versionCode=1 minSdk=24 targetSdk=34).
tok_val()  { grep -m1 -oE "(^|[[:space:]])$1=[^[:space:]]+" <<<"$dump" | sed "s/.*$1=//"; }

version_name=$(line_val versionName)
version_code=$(tok_val versionCode)
min_sdk=$(tok_val minSdk)
target_sdk=$(tok_val targetSdk)
installer=$(line_val installerPackageName)
first_install=$(line_val firstInstallTime)
last_update=$(line_val lastUpdateTime)
flags=$(grep -m1 -E '^[[:space:]]*(pkg)?[Ff]lags=\[' <<<"$dump" | sed 's/^[[:space:]]*//')

row() { [[ -n ${2:-} ]] && printf '  %-14s %s\n' "$1" "$2"; }

printf '\n%s\n\n' "$pkg"
row "Version name"  "${version_name:-<none>}"
row "Version code"  "${version_code:-<none>}"
row "minSdk"        "$min_sdk"
row "targetSdk"     "$target_sdk"
row "Installer"     "$installer"
row "Installed"     "$first_install"
row "Updated"       "$last_update"
row "Debuggable"    "$([[ $flags == *DEBUGGABLE* ]] && echo yes || echo no)"
row "Device"        "$dev_name"
row "Android"       "${dev_release:-?} (API ${dev_sdk:-?})"
row "Serial"        "$serial"
printf '\n'
