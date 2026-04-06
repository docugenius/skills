#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DOCUGENIUS_BASE_URL:-}" ]]; then
  echo "DOCUGENIUS_BASE_URL is required" >&2
  exit 1
fi

if [[ -z "${DOCUGENIUS_APP_TOKEN:-}" ]]; then
  echo "DOCUGENIUS_APP_TOKEN is required" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

operation="${1:-}"
if [[ -z "$operation" ]]; then
  echo "usage: $0 <operation> [args...]" >&2
  exit 1
fi
shift || true

api() {
  local method="$1"
  local path="$2"
  local body="${3:-}"

  local url="${DOCUGENIUS_BASE_URL%/}${path}"
  local curl_args=(
    --silent
    --show-error
    --fail-with-body
    -X "$method"
    -H "Authorization: Bearer ${DOCUGENIUS_APP_TOKEN}"
    -H "Content-Type: application/json"
    "$url"
  )

  if [[ -n "$body" ]]; then
    curl_args+=(-d "$body")
  fi

  curl "${curl_args[@]}"
}

read_body_arg() {
  local arg="${1:-}"
  if [[ -z "$arg" ]]; then
    echo ""
    return
  fi

  if [[ "$arg" == @* ]]; then
    cat "${arg#@}"
  else
    printf '%s' "$arg"
  fi
}

case "$operation" in
  create-doc)
    body="$(read_body_arg "${1:-}")"
    api POST "/api/docs" "$body"
    ;;
  update-doc)
    doc_id="${1:?docId required}"
    body="$(read_body_arg "${2:-}")"
    api PUT "/api/docs/${doc_id}" "$body"
    ;;
  get-doc)
    doc_id="${1:?docId required}"
    api GET "/api/docs/${doc_id}"
    ;;
  delete-doc)
    doc_id="${1:?docId required}"
    api DELETE "/api/docs/${doc_id}"
    ;;
  create-editor-url)
    doc_id="${1:?docId required}"
    body="$(read_body_arg "${2:-}")"
    api POST "/api/docs/${doc_id}/create-editor-url" "$body"
    ;;
  create-preview-url)
    doc_id="${1:?docId required}"
    body="$(read_body_arg "${2:-}")"
    api POST "/api/docs/${doc_id}/create-preview-url" "$body"
    ;;
  create-export-job)
    doc_id="${1:?docId required}"
    body="$(read_body_arg "${2:-}")"
    api POST "/api/docs/${doc_id}/export-jobs" "$body"
    ;;
  get-export-job)
    doc_id="${1:?docId required}"
    job_token="${2:?jobToken required}"
    api GET "/api/docs/${doc_id}/export-jobs/${job_token}"
    ;;
  create-batch-export-job)
    doc_id="${1:?docId required}"
    body="$(read_body_arg "${2:-}")"
    api POST "/api/docs/${doc_id}/batch-export-jobs" "$body"
    ;;
  get-batch-export-job)
    doc_id="${1:?docId required}"
    job_token="${2:?jobToken required}"
    api GET "/api/docs/${doc_id}/batch-export-jobs/${job_token}"
    ;;
  list-enabled-templates)
    doc_id="${1:?docId required}"
    api GET "/api/docs/${doc_id}/enabled-templates"
    ;;
  get-enabled-template)
    doc_id="${1:?docId required}"
    template_id="${2:?templateId required}"
    api GET "/api/docs/${doc_id}/enabled-templates/${template_id}"
    ;;
  *)
    echo "unknown operation: $operation" >&2
    exit 1
    ;;
esac
