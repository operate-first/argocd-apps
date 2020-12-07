# ArgoCD onboarding procedure

Onboarding a team requires the following steps to be taken.

## Create openshift-group

To add multi-tenancy support, we require the team to have an openshift group on the MOC cluster on which our ArgoCD instance resides.
This openshift group should include all the people belonging to the team that will need write-level access to applications
belonging to the team's ArgoCD Project (explained later). An openshift group needs to be requested by making an issue
[here](https://gitlab.com/open-infrastructure-labs/moc-cnv-sandbox/-/issues).

## Create project directories for this repository
To create the project directories, use the the following script provided:

```bash
./create-project.sh project_name
```

This will create the necessary folders/files that respects the project structure of this repository.

Teams should be directed [here](add_application.md) for instructions on how to structure their ArgoCD Applications.
All Applications should go in the team's [ArgoCD Project](https://argoproj.github.io/argo-cd/user-guide/projects/),
see below for instructions on adding an ArgoCD Project.

## ArgoCD Project
The team will need a dedicated [ArgoCD Project](https://argoproj.github.io/argo-cd/user-guide/projects/) for their
[ArgoCD Applications](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications). The
ArgoCD project should be added [here](https://gitlab.com/open-infrastructure-labs/moc-cnv-sandbox/-/tree/master/manifests/argocd/overlays/prod/projects).

A typical project will look like the following:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: <team-name>
spec:
  destinations:
    - namespace: '<team-namespace-prefix>-*'
      server: 'https://kubernetes.default.svc'
  sourceRepos:
    - '*'
  roles:
    - name: project-admin
      description: Read/Write access to this project only
      policies:
        - p, proj:<team-name>:project-admin, applications, get, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, create, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, update, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, delete, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, sync, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, override, <team-name>/*, allow
        - p, proj:<team-name>:project-admin, applications, action/*, <team-name>/*, allow
      groups:
        - <team-openshift-group>
        - operate-first
  clusterResourceWhitelist:
    - group: ''
      kind: Namespace
  namespaceResourceWhitelist:
  ....
```

Some notes:

* Ensure that the `spec.destinations` field contains a prefix for the team's namespaces. The team will be required to
prefix their namespaces with this attribute if they want ArgoCD to be able to deploy to them, any other namespaces not
following the prefix will need to be added manually under this field. See additional notes for more details.
* Ensure `operate-first` is added into the `roles.groups` for each role. This allows the operate-first team to
help diagnose issues.
* `namespaceResourceWhitelist` generally contains the list of resources a project `admin` has access to. The general idea
is that a team should be able to deploy via ArgoCD what they can deploy using `oc apply`. See other projects for a list of
such resources.
* Ensure that the argocd project is included in the `kustomization.yaml` [here](https://gitlab.com/open-infrastructure-labs/moc-cnv-sandbox/-/blob/master/manifests/argocd/overlays/prod/projects/kustomization.yaml).

## Enable openshift auth to ArgoCD Console
By default all users should be able to see the [ArgoCD console](https://argocd-server-aicoe-argocd.apps.ocp4.prod.psi.redhat.com).
To be able to make changes to applications belonging to the team's ArgoCD Project (via the cli or ui), the team will need
to be able to log into the console with appropriate access. This accomplished by adding the team's openshift group
mentioned in the beginning under the dex config [here](https://gitlab.com/open-infrastructure-labs/moc-cnv-sandbox/-/blob/master/manifests/argocd/overlays/prod/configs/argo_cm/dex.config#L11).

### Additional Notes:

### Namespace Prefix
An ArgoCD project allows us to ensure that a team cannot deploy applications onto another team's namespace via ArgoCD.

We accomplish this by allowing teams to add the namespaces that they will be deploying to in their ArgoCD Project CR under
the `spec.destinations.` field. Example:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: example-project
  namespace: argocd
spec:
  destinations:
  - namespace: guestbook
    server: 'https://kubernetes.default.svc'
...
```

The project above can only deploy into the `guestbook` namespace in the host cluster.

It can get bit tedious having to always require a team to submit a pr updating the `spec.destinations` to include new
namespaces their project applications can deploy onto, so we can use wildcards to include a set of namespaces that
begin with a prefix. For example, the `thoth` team has the following prefix in their `spec.destinations`:

```yaml
spec:
  destinations:
    - namespace: 'thoth-*'
      server: 'https://kubernetes.default.svc'
```

Now, as long as all thoth team's namespaces have `metadata.name` beginning with a `thoth-` prefix, they can deploy
into these namespaces using ArgoCD Applications that are part of the `thoth` project.

### Resources:

- To read more about ArgoCD Declarative setup [see here](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/)
- To understand our authentication setup [see here](https://argoproj.github.io/argo-cd/operator-manual/user-management/#dex)
- To read about ArgoCD Projects [see here](https://argoproj.github.io/argo-cd/user-guide/projects/)
- To learn about Kustomize bases & overlays [see here](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)
