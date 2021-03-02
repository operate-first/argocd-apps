# Adding ArgoCD Applications

This repo contains all Operate First ArgoCD [Applications](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications).

# Pre-requisites
- You should have [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/) installed
- You should be familiar with [kustomize overlays](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)
- You should be familiar with what an [ArgoCD application](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications) is.

### I want to deploy to ${CLUSTER_NAME}

Where ${CLUSTER_NAME} is any cluster listed [here](https://github.com/operate-first/argocd-apps/tree/main/overlays).

- See Argocd Docs for how to create an ArgoCD `Application` [here](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications).

- Ensure that the `spec.destination` field in your Argocd `Applicaiton` manifest matches the appropriate cluster (e.g. `moc-cnv`, `moc-infra`, etc.), you can get an idea of what to put for this value by inspecting the other application manifests in the respective cluster overlay directory.

- Ensure that your `spec.project` matches your team's ArgoCD project, if you do not have one please request one for your team by filing this [issue here.](https://github.com/operate-first/support/issues/new?assignees=&labels=onboarding&template=onboarding_argocd.md&title=).

- Add your ArgoCD Application to `overlays/${CLUSTER_NAME}/${PROJECT}` where `{$PROJECT}` correlates with your project.

- Add this resource to the `resource` field list in `overlays/${CLUSTER_NAME}/{$PROJECT}/kustomization.yaml`.
