#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
api_script="${script_dir}/docugenius_api.sh"

if [[ ! -x "$api_script" ]]; then
  echo "missing executable helper: $api_script" >&2
  exit 1
fi

command_name="${1:-}"
if [[ -z "$command_name" ]]; then
  echo "usage: $0 <command> [args...]" >&2
  exit 1
fi
shift || true

forward() {
  "$api_script" "$@"
}

case "$command_name" in
  template-create)
    name="${1:?name required}"
    forward create-doc "{\"name\":\"${name}\"}"
    ;;
  template-update)
    doc_id="${1:?docId required}"
    body="${2:?body or @file required}"
    forward update-doc "$doc_id" "$body"
    ;;
  template-get)
    doc_id="${1:?docId required}"
    forward get-doc "$doc_id"
    ;;
  template-delete)
    doc_id="${1:?docId required}"
    forward delete-doc "$doc_id"
    ;;
  editor-url)
    doc_id="${1:?docId required}"
    body="${2:?body or @file required}"
    forward create-editor-url "$doc_id" "$body"
    ;;
  preview-url)
    doc_id="${1:?docId required}"
    body="${2:?body or @file required}"
    forward create-preview-url "$doc_id" "$body"
    ;;
  doc-generate)
    doc_id="${1:?docId required}"
    body="${2:?body or @file required}"
    forward create-export-job "$doc_id" "$body"
    ;;
  doc-job)
    doc_id="${1:?docId required}"
    job_token="${2:?jobToken required}"
    forward get-export-job "$doc_id" "$job_token"
    ;;
  batch-generate)
    doc_id="${1:?docId required}"
    body="${2:?body or @file required}"
    forward create-batch-export-job "$doc_id" "$body"
    ;;
  batch-job)
    doc_id="${1:?docId required}"
    job_token="${2:?jobToken required}"
    forward get-batch-export-job "$doc_id" "$job_token"
    ;;
  templates)
    doc_id="${1:?docId required}"
    forward list-enabled-templates "$doc_id"
    ;;
  template-detail)
    doc_id="${1:?docId required}"
    template_id="${2:?templateId required}"
    forward get-enabled-template "$doc_id" "$template_id"
    ;;
  *)
    cat >&2 <<'EOF'
unknown command

commands:
  template-create <name>
  template-update <docId> <json|@file>
  template-get <docId>
  template-delete <docId>
  editor-url <docId> <json|@file>
  preview-url <docId> <json|@file>
  doc-generate <docId> <json|@file>
  doc-job <docId> <jobToken>
  batch-generate <docId> <json|@file>
  batch-job <docId> <jobToken>
  templates <docId>
  template-detail <docId> <templateId>
EOF
    exit 1
    ;;
esac
