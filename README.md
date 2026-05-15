# Blockcast CDN Gateway — Helm Charts

This repository hosts Helm charts for deploying the Blockcast CDN Gateway on Kubernetes.

There are two release tracks:

| Track | Purpose | Helm repo URL |
|-------|---------|---------------|
| **stable** | Production | `https://blockcast.github.io/helm-charts/stable` |
| **beta** | Staging / early access | `https://blockcast.github.io/helm-charts/beta` |

> **Note:** All chart versions use pre-release SemVer suffixes (e.g., `1.8.8-15529.de614275`). You must pass `--devel` to Helm commands so that Helm includes these versions — without it Helm will find no installable chart.

---

## Prerequisites

- Kubernetes 1.25+
- Helm 3.12+
- Cluster admin credentials for the initial setup step
- [Gateway API CRDs](https://gateway-api.sigs.k8s.io/guides/#install-standard-channel) — the **experimental channel** is required because the relay uses `TCPRoute` and `UDPRoute`, which are not in the standard channel:
  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/experimental-install.yaml
  ```
- **Release name alignment** — the prereqs chart's `ClusterRoleBinding` subjects must match the gateway release's `ServiceAccount`. The prereqs `releaseName` value **must** match the gateway release name used in Step 2. The default `blockcastd` works as long as you don't override the gateway release name.

---

## Add the Helm repository

**Stable (production):**
```bash
helm repo add blockcast https://blockcast.github.io/helm-charts/stable
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

#### Verify Step 1 landed

The cluster-scoped resources are installed independently of the gateway release. The most common cause of a broken install is silently skipping this step. Confirm before continuing:

```bash
helm list -n <your-namespace> | grep blockcastd-prereqs
kubectl get gatewayclass ats-<your-namespace>
```

Both should return non-empty results. If the `GatewayClass` is `NotFound` or the gateway is later stuck on `PROGRAMMED=Unknown` ("Waiting for controller"), Step 1 was skipped or used the wrong namespace — re-run it.

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

## Post-installation

### 1. Register the gateway

Once the pods are running, get the registration URL:

```bash
kubectl exec -n <your-namespace> deploy/blockcastd-blockcastd -- blockcastd -s
```

Copy the printed URL and register the gateway in the Blockcast portal. Until registered, `blockcastd` will not receive a configuration and no dynamic services will start.

### 2. Verify registration

After registering, `blockcastd` will connect to the controller and pull its configuration. Check the logs to confirm:

```bash
kubectl logs -n <your-namespace> deploy/blockcastd-blockcastd -f
```

Look for the configuration received and dynamic services starting up (e.g. `beacond`).

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

## Troubleshooting

### Gateway stuck on `PROGRAMMED=Unknown` ("Waiting for controller")

```bash
kubectl get gateway -n <your-namespace>
# NAME              CLASS                ADDRESS  PROGRAMMED  AGE
# blockcastd-relay  ats-<namespace>               Unknown     5d
```

Almost always means the prereqs chart was skipped for this namespace. Check:

```bash
helm list -n <your-namespace> | grep blockcastd-prereqs
kubectl get gatewayclass ats-<your-namespace>
```

If either is empty, re-run [Step 1](#step-1--install-cluster-prerequisites-admin-once-per-namespace). The relay controller will pick up the new `GatewayClass` on its next reconcile, or you can force it with:

```bash
kubectl rollout restart deployment/blockcastd-relay -n <your-namespace>
```

### `helm search repo` returns no results

Pre-release chart versions require `--devel`:

```bash
helm search repo blockcast/cdn-gateway --devel
```

---

## Uninstall

```bash
helm uninstall blockcastd -n <your-namespace>
helm uninstall blockcastd-prereqs -n <your-namespace>
```

PVCs (`blockcastd-certs` and the snowflake PVC) are retained by default due to the resource policy annotation. Delete them manually if needed — otherwise reinstalling in the same namespace will reuse the existing certificate and snowflake state.
