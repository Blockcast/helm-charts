# Blockcast CDN Gateway — Helm Charts

This repository hosts Helm charts for deploying the Blockcast CDN Gateway on Kubernetes.

There are two release tracks:

| Track | Purpose | Helm repo URL |
|-------|---------|---------------|
| **stable** | Production | `https://blockcast.github.io/helm-charts` |
| **beta** | Staging / early access | `https://blockcast.github.io/helm-charts/beta` |

> **Note:** All chart versions use pre-release SemVer suffixes (e.g., `1.8.8-15529.de614275`). You must pass `--devel` to Helm commands so that Helm includes these versions — without it Helm will find no installable chart.

---

## Prerequisites

- Kubernetes 1.25+
- Helm 3.12+
- Cluster admin credentials for the initial setup step
- [Gateway API CRDs](https://gateway-api.sigs.k8s.io/guides/#install-standard-channel) installed on the cluster:
  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/experimental-install.yaml
  ```

---

## Add the Helm repository

**Stable (production):**
```bash
helm repo add blockcast https://blockcast.github.io/helm-charts
helm repo update
```

**Beta (staging):**
```bash
helm repo add blockcast-beta https://blockcast.github.io/helm-charts/beta
helm repo update
```

---

## Installation

The gateway is split into two charts. The **prereqs** chart must be installed first by a cluster admin. The **gateway** chart is what runs on the node and self-updates.

### Step 1 — Install cluster prerequisites (admin, once per namespace)

This installs the `ClusterRole`, `ClusterRoleBinding`, and `GatewayClass` that the gateway needs. Requires cluster-admin credentials.

**Stable:**
```bash
helm upgrade --install blockcastd-prereqs blockcast/cdn-gateway-orc8r-prereqs \
  -n <your-namespace> \
  --create-namespace \
  --devel
```

**Beta:**
```bash
helm upgrade --install blockcastd-prereqs blockcast-beta/cdn-gateway-orc8r-prereqs \
  -n <your-namespace> \
  --create-namespace \
  --devel
```

> If your gateway release name is not `blockcastd`, pass `--set releaseName=<your-release-name>`.

### Step 2 — Install the gateway

**Stable:**
```bash
helm upgrade --install blockcastd blockcast/cdn-gateway \
  -n <your-namespace> \
  --devel \
  -f my-values.yaml
```

**Beta:**
```bash
helm upgrade --install blockcastd blockcast-beta/cdn-gateway \
  -n <your-namespace> \
  --devel \
  -f my-values.yaml
```

See `helm show values blockcast/cdn-gateway` for all available configuration options.

---

## Upgrades

The gateway upgrades itself automatically once running. To manually upgrade the Helm release:

```bash
helm repo update
helm upgrade blockcastd blockcast/cdn-gateway -n <your-namespace> --devel -f my-values.yaml
```

Use `blockcast-beta/cdn-gateway` instead if you are on the beta track.

The prereqs chart rarely changes. Re-run Step 1 only if instructed in the release notes.

---

## Uninstall

```bash
helm uninstall blockcastd -n <your-namespace>
helm uninstall blockcastd-prereqs -n <your-namespace>
```
