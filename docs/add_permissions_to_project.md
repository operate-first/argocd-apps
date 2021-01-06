# Requesting more permissions for an ArgoCD Project (MOC)

Once a team has been onboarded to ArgoCD on MOC. They may request additional permissions for their ArgoCD Project. For example, a team
may request permissions to deploy a custom resource, but lack the permissions to do so.

Permissions for all projects can be found [here](https://github.com/open-infrastructure-labs/moc-cnv-sandbox/tree/master/manifests/argocd/overlays/prod/projects).

In order to add more permissions, find your project yaml in the location above and add the resource under `namespaceResourceWhitelist`.

For example, to give a project permissions to deploy Argo `Workflows` to the `thoth` project we would add the following to `thoth.yaml` located [here](https://github.com/open-infrastructure-labs/moc-cnv-sandbox/blob/master/manifests/argocd/overlays/prod/projects/thoth.yaml):

```yaml
namespaceResourceWhitelist:
    - group: argoproj.io
      kind: CronWorkflow
    - group: argoproj.io
      kind: Workflow
    - group: argoproj.io
      kind: WorkflowTemplate
```
