#!/usr/bin/env bash

set -euo pipefail

readonly BLUE='\033[34m' GREEN='\033[32m' YELLOW='\033[33m' RED='\033[31m' RESET='\033[0m'

info() { printf "${BLUE}•${RESET} %s\n" "$1" >&2; }
success() { printf "${GREEN}✓${RESET} %s\n" "$1" >&2; }
warn() { printf "${YELLOW}!${RESET} %s\n" "$1" >&2; }
error() { printf "${RED}x${RESET} %s\n" "$1" >&2; }

[[ $# -lt 3 ]] && {
	error "Missing parameters"
	exit 2
}

readonly WORKER_INDEX="$1" TOTAL_WORKERS="$2" APPS_INPUT="$3" ENVIRONMENT="${4:-}" REGION="${5:-fra}"

[[ "$WORKER_INDEX" =~ ^[1-9][0-9]*$ ]] && [[ "$TOTAL_WORKERS" =~ ^[1-9][0-9]*$ ]] && [[ $WORKER_INDEX -le $TOTAL_WORKERS ]] || {
	error "Invalid worker parameters"
	exit 2
}

info "Worker $WORKER_INDEX/$TOTAL_WORKERS: ${APPS_INPUT} (${ENVIRONMENT:-default}@${REGION})"

for tool in make jq; do
	command -v "$tool" &>/dev/null || {
		error "Missing tool: $tool"
		exit 1
	}
done

MATRIX_OUTPUT=$(make matrix apps="$APPS_INPUT" 2>/dev/null) || {
	error "Failed to get apps"
	exit 1
}
APPS=$(printf '%s' "$MATRIX_OUTPUT" | jq -r '.[]' 2>/dev/null) || {
	error "Failed to parse apps"
	exit 1
}
[[ -n "$APPS" ]] || {
	warn "No apps found"
	exit 0
}

mapfile -t APP_ARRAY <<<"$APPS"
readonly TOTAL_APPS=${#APP_ARRAY[@]}
readonly APPS_PER_WORKER=$(((TOTAL_APPS + TOTAL_WORKERS - 1) / TOTAL_WORKERS))
readonly START=$(((WORKER_INDEX - 1) * APPS_PER_WORKER))
readonly END=$((START + APPS_PER_WORKER > TOTAL_APPS ? TOTAL_APPS : START + APPS_PER_WORKER))

[[ $START -lt $TOTAL_APPS ]] || {
	warn "No apps assigned"
	exit 0
}

readonly WORKER_APPS=("${APP_ARRAY[@]:$START:$((END - START))}")
info "Deploying ${#WORKER_APPS[@]}/${TOTAL_APPS}: ${WORKER_APPS[*]}"

{
	printf "# 🚀 Worker %s/%s\n\n" "$WORKER_INDEX" "$TOTAL_WORKERS"
	printf "## Apps\n\n"
	for app in "${WORKER_APPS[@]}"; do
		printf "- \`%s%s\`\n" "$app" "${ENVIRONMENT:+-$ENVIRONMENT}"
	done
	printf "\n_Deploy started at %s_\n\n" "$(date '+%Y-%m-%d %H:%M:%S')"
	printf "**Environment:** %s\n" "${ENVIRONMENT:-default}"
	printf "**Region:** %s\n" "$REGION"
} >>"$GITHUB_STEP_SUMMARY"

failed_apps=()
for app in "${WORKER_APPS[@]}"; do
	info "Deploying $app${ENVIRONMENT:+-$ENVIRONMENT}"
	deploy_cmd="make deploy app=$app${ENVIRONMENT:+ environment=$ENVIRONMENT} region=$REGION"
	printf "${BLUE}+ %s${RESET}\n" "$deploy_cmd" >&2

	if eval "$deploy_cmd"; then
		success "$app deployed"
	else
		error "Failed: $app"
		failed_apps+=("$app")
	fi
done

if [[ ${#failed_apps[@]} -eq 0 ]]; then
	success "Worker $WORKER_INDEX completed"
else
	error "Worker $WORKER_INDEX failed: ${failed_apps[*]}"
	exit 1
fi
