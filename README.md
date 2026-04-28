# Blockcast CDN Gateway — Helm Charts

This repository hosts Helm charts for deploying the Blockcast CDN Gateway on Kubernetes.

**Helm repo URL:** `https://blockcast.github.io/helm-charts`

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

```bash
helm repo add blockcast https://blockcast.github.io/helm-charts
helm repo update
```

---

## Installation

The gateway is split into two charts. The **prereqs** chart must be installed first by a cluster admin. The **gateway** chart is what runs on the node and self-updates.

### Step 1 — Install cluster prerequisites (admin, once per namespace)

This installs the `ClusterRole`, `ClusterRoleBinding`, and `GatewayClass` that the gateway needs. Requires cluster-admin credentials.

```bash
helm upgrade --install blockcastd-prereqs blockcast/cdn-gateway-orc8r-prereqs \
  -n <your-namespace> \
  --create-namespace
```

> If your gateway release name is not `blockcastd`, pass `--set releaseName=<your-release-name>`.

### Step 2 — Install the gateway

```bash
helm upgrade --install blockcastd blockcast/cdn-gateway \
  -n <your-namespace> \
  -f my-values.yaml
```

See `helm show values blockcast/cdn-gateway` for all available configuration options.

---

## Upgrades

The gateway upgrades itself automatically once running. To manually upgrade the Helm release:

```bash
helm repo update
helm upgrade blockcastd blockcast/cdn-gateway -n <your-namespace> -f my-values.yaml
```

The prereqs chart rarely changes. Re-run Step 1 only if instructed in the release notes.

---

## Uninstall

```bash
helm uninstall blockcastd -n <your-namespace>
helm uninstall blockcastd-prereqs -n <your-namespace>
```
