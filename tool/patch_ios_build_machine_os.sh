#!/bin/zsh

set -euo pipefail

archive_path="${1:-build/ios/archive/Runner.xcarchive}"
target_os_build="${2:-25F84}"
app_info_plist="$archive_path/Products/Applications/Runner.app/Info.plist"
plist_buddy="/usr/libexec/PlistBuddy"

if [[ ! -f "$app_info_plist" ]]; then
  print -u2 "Runner Info.plist not found: $app_info_plist"
  exit 1
fi

bundle_id="$("$plist_buddy" -c "Print :CFBundleIdentifier" "$app_info_plist")"
if [[ "$bundle_id" != "com.tropix.codePocket" ]]; then
  print -u2 "Unexpected bundle identifier: $bundle_id"
  exit 1
fi

current_os_build="$("$plist_buddy" -c "Print :BuildMachineOSBuild" "$app_info_plist")"
if [[ "$current_os_build" == "$target_os_build" ]]; then
  print "BuildMachineOSBuild is already $target_os_build"
  exit 0
fi

"$plist_buddy" \
  -c "Set :BuildMachineOSBuild $target_os_build" \
  "$app_info_plist"

patched_os_build="$("$plist_buddy" -c "Print :BuildMachineOSBuild" "$app_info_plist")"
if [[ "$patched_os_build" != "$target_os_build" ]]; then
  print -u2 "Failed to patch BuildMachineOSBuild"
  exit 1
fi

print "BuildMachineOSBuild: $current_os_build -> $patched_os_build"
