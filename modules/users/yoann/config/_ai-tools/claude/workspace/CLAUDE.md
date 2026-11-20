# CLAUDE.md

Instructions for Claude Code at the `~/Projets` workspace root.

---

## Language

- **Talk to the user in French.** All exchanges, explanations and summaries.
- **Repository documentation and code comments follow each repo's own
  convention** — stated in that repo's `CLAUDE.md`. Most are French; the NixOS
  config uses English code comments.
- **Model-facing instruction files are written in English** — agent definitions
  under `.claude/agents/`, and this file. They are prompts, not documentation:
  English tokenises more compactly and keeps them portable across assistants.

This is not a contradiction: the language a file is *written in* follows who
reads it. A human reads the docs, a model reads the agents.

---

## Repository layout

This directory is the local root of a multi-repo workspace. Each repo carries
its own `CLAUDE.md` with the context specific to it.

| Repo | Remote | Contents |
|---|---|---|
| `homelab/packer/` | `forge.macopla.com:homelab/packer` | Packer Debian 13 templates for Proxmox VE |
| `homelab/opentofu/` | `forge.macopla.com:homelab/opentofu` | OpenTofu roots `proxmox/`, `openbao/`, `ovh/`, `lldap/` + modules |
| `homelab/ansible/` | `forge.macopla.com:homelab/ansible` | Ansible playbooks/roles, also the `homelab.base` collection |
| `homelab/docker/` | `forge.macopla.com:homelab/docker` | Docker Swarm and compose stacks, deployed by Komodo (GitOps) |
| `homelab/renovate-config/` | `forge.macopla.com:homelab/renovate-config` | Shared Renovate preset |
| `homelab/template/` | `forge.macopla.com:homelab/template` | Repository skeleton: Nix dev shell, pre-commit, CI |
| `homelab/.github/` | `github.com:atilili-homelab/.github` | GitHub organisation profile README |
| `nixos/` | `gitlab.com:atilili/nixos` | Laptop config: NixOS, Hyprland, home-manager |
| `notes/` | `gitlab.com:atilili/notes` | Obsidian vault (working notes) |
| `wiki/` | `gitlab.com:atilili/wiki` | BookStack documentation export |
| `quickdata/` | local | NocoDB infrastructure project |
| `corne/` | local | Corne keyboard QMK firmware + userspace |
| `jellyfin-plugins/` | `github.com:Atilil/jellyfin-plugins` | User's own Jellyfin plugins (WatchSync, JellyTag) |
| `learning/` | local | Course material and exercises |

`homelab/` is a plain directory, not a repo: it groups the infrastructure repos,
which form one chain (Packer → OpenTofu → Ansible → Docker). The Forgejo repos are
push-mirrored to GitHub `atilili-homelab/<repo>` (public showcase for recruiters,
not meant for reuse), and some to GitLab as a private backup. The former
`gitlab.com:atilili/homelab` monorepo is retired.

**Operational documentation** — incident runbooks, project kanban,
troubleshooting notes — lives in `notes/` (Obsidian vault). Query it through
the **obsidian** agent, never by reading vault files directly.

---

## Specialised agents

Agents in `.claude/agents/` are available across every sub-repository.

| Agent | Scope |
|---|---|
| **opentofu** | HCL, modules, plan reading, state safety |
| **ansible** | Playbooks, roles, inventories, idempotency, variable precedence |
| **swarm** | Compose/stack files, placement, overlay networks, secrets, healthchecks |
| **packer** | Image templates, provisioner ordering, image hygiene |
| **nixos** | NixOS/home-manager, flakes, den aspects, SOPS, rebuild safety |
| **infra-reviewer** | Cross-cutting IaC audit — the seams between two tools |
| **obsidian** | Obsidian vault: create, read, search, classify, daily log |
| **factcheck** | One precise verifiable value, against its primary source |
| **research** | Multi-source research when no single source settles the question |

### How the split works

**An agent carries domain expertise. A repository's `CLAUDE.md` carries that
repository's facts.**

The infra agents (`opentofu`, `ansible`, `packer`, `swarm`) are deliberately
generic: they know the tool, not this estate. The estate facts live in the repo
that owns them, and agents look them up there: the repo's `README.md` and
`docs/`, then the code itself (machines in `homelab/opentofu/proxmox/*.tfvars`,
groups in `homelab/ansible/inventory/`, services in
`homelab/docker/komodo/stacks.toml`). There is no central facts file. The
`nixos` agent works the same way and reads `nixos/CLAUDE.md` for the module
layout.

The reason is drift: duplicated facts diverge, and an agent answering from a
stale copy is worse than one that looks the fact up.

`obsidian` is the exception — the vault *is* its subject, so its structure
lives in the agent.

### Delegation rule

Delegate to the specialised agent for the domain at hand. Do not handle inline
a task an agent covers.

| Directory / domain | Agent |
|---|---|
| `homelab/opentofu/` | **opentofu** |
| `homelab/ansible/` | **ansible** |
| `homelab/docker/` | **swarm** |
| `homelab/packer/` | **packer** |
| `nixos/` | **nixos** |
| Multi-file / multi-tool IaC audit | **infra-reviewer** |
| `notes/` — Obsidian vault | **obsidian** |
| A package version or other single verifiable value | **factcheck** |
| External docs, comparisons, state of the art | **research** |

**factcheck vs research:** one exact value with a primary source → factcheck.
An open question needing several sources reconciled → research.

---

**Last updated:** 2026-11-17
