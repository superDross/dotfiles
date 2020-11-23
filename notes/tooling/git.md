# Git Notes

There are three of the same branches at any given time:

1. Branch on the remote repo (`bugfix`)
2. Local snapshot of the remote branch (AKA remote tracking branch) (`origin/bugfix`)
3. Local branch, tracking the remote branch (`bugfix`)

## Branch Management

List branches that have been merged into a branch

Good for knowing what feature branches have been merged, before deleting them.

Uses the current branch by default (HEAD).

```sh
# check what has been merged in the current branch
git branch --merged

# remote
git branch -r --merged

# check what has been merged in the feature branch
git branch --merged feature/cool-new-api
```

Branches not merged

```sh
git branch --no-merged

# remote
git branch -r --no-merged
```

## Pull vs Fetch

Both download the branches most recent commits.

Fetch only downloads new data from the remote repo, but does not merge in the data to your local version.
Instead it downloads the data to the remote tracking branch.

```
git fetch origin
```

Pull downloads and merges the remote changes from the remote server to your current HEAD branch.

```
git pull origin master
```

It download

## Deleting

```
# local
git branch -d feature/login

# local force delete
git branch -D feature/login

# remove local remote tracking branch if not present in remote
git remote prune origin --dry-run  # safety first
git remote prune origin

# remote
git push origin --delete feature/login
```

## Patch Staging

Allows you to `git add` portions of a changed file; a hunk.
