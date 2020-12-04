# Adding ArgoCD Applications

This repo contains all operate-first ArgoCD [Applications](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications).

Please see the use-cases below and follow the instructions that best fit your application's needs.

# Pre-requisites
- You should have [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/) installed
- You should be familiar with [kustomize ovelrays](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)
- You should be familiar with what an [ArgoCD application](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications) is.

# I only want to Deploy to MOC

Add your ArgoCD Application to `overlays/moc/$PROJECT` where `$PROJECT` correlates with your project.
Add this resource to the `resource` field list in `overlays/moc/$PROJECT/kustomization.yaml`.

# I only want to Deploy to Quicklab

Add your ArgoCD Application to `overlays/quicklab/$PROJECT` where `$PROJECT` correlates with your project.
Add this resource to the `resource` field list in `overlays/quicklab/$PROJECT/kustomization.yaml`.

# I want to be able to deploy to MOC and Quicklab

There are 2 sub use-cases here:

## I don't use overlays (one set of manifests)

Add your ArgoCD Application to `base/$PROJECT` where `$PROJECT` correlates with your project. It will be auto consumed
by `moc` and `quicklab` overlays. The `path` should point to the path in your repo that contains the manifests.

## I use overlays for moc and quicklab that inherit from a base

The assumption here is that your manifest repository follows this structure:
```
.
├──base
├──overlays
│   ├── quicklab
│   └── moc
```
This use case is essentially a combination of the above and requires a couple of steps:

1. Add your ArgoCD Application to `base/$PROJECT` where `$PROJECT` correlates with your project like in above. The `path`
should point to the path in your repo that contains the `base` folder.
2. Add a [strategic patch file](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md#inline-patch-for-patchesstrategicmerge)
to `overlays/moc/$PROJECT` that updates the `path` field to point to the `overlays/moc` folder in your repository.
3. Add this resource to the `patchesStrategicMerge` field list in `overlays/moc/$PROJECT/kustomization.yaml`.
4. Repeat 2) and 3) for `quicklab` but use `overlays/quicklab` instead of `overlays/moc`.
