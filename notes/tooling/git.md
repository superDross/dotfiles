# Git Notes

There are three of the same branches at any given time:

1. Branch on the remote repo (synonym for an remote url; 'origin' by default) (`bugfix`)
2. Local snapshot of the remote branch (AKA remote tracking branch) (`origin/bugfix`)
3. Local branch, tracking the remote branch (`bugfix`)

## Cherry-Picking Commits

Get a specific commit from one branch and applying it to another branch.

This is useful when:
  - a team member added a specific commit with a feature you would like to use in a different branch
  - hotfixes, if a bug is fixed in a pre-existing feature branch we can pick the commit with the fix and place it directly into master

Use sparingly as it can cause some serious 

### Example

We are going to cherrypick a specific bug fix from a feature branch and merge it into master.

Check master branches logs:

```
$ git checkout master
$ git log --oneline

    d2cdb98 (HEAD -> master) first dice implementation
    d77e384 first
```

Find the commit that implements the bug fix:

```
$ git log --oneline feature/double-roll

    ae073c2 (feature/double-roll) Add double roll test
    acf38d5 Fix serious bug
    112e4bf add double rolling feature
    d2cdb98 (HEAD -> master) first dice implementation
    d77e384 first
```

Merge the change into the master branch:

```
$ git cherry-pick acf38d5
```

Check to ensure the commit message of interest is present:

```
$ git log --oneline

    f7b5964 (HEAD -> master) Fix serious bug
    d2cdb98 first dice implementation
    d77e384 first
```

If you find merge conflicts along the way, resolve and add them then:

```
git cherry-pick --continue
```



## Interactive Rebase

Take commits from a branch and replay them at the end of another branch, useful to integrate
without merging.

Rebasing is a destructive process so don't rebase on a public branch (e.g. master) only
do so on a local private branch that you are using exclusively.

### Merging Vs Rebasing

Traditional merging creates unwanted merge commits that are very noisey:

```
$ git checkout feature/double-roll
$ git merge master
$ git log --oneline -n 3

    1500230 (HEAD -> feature/double-roll) Merge branch 'master' into feature/double-roll
    f7b5964 (master) Fix serious bug
    ae073c2 Add double roll test

                         (master)
84c46 -> ce678 -> c69ba -> 923ea
           \                |
            \               V
             ---> 7b21a -> 8df32
                         (feature)
```

After rebasing the merging becomes very clean and straightforward. It shows our feature branch
commits as the most recent commits.

```
$ git checkout feature/double-roll
$ git rebase master
$ git log --oneline -n 3

    ead8591 (HEAD -> feature/double-roll) Add double roll test
    18598e4 add double rolling feature
    f7b5964 (master) Fix serious bug

                         (master)
84c46 -> ce678 -> c69ba -> 923ea
                             \                
                              \               
                               ---> 7b21a -> 8df32
                                         (feature)
```

**Warning** rebasing is a destructive process while merging is not.

### Undo Simple Rebase

This only works if the very last git operation performed was the rebase we
want to revert, other wise the previous `HEAD` (`ORIG_HEAD`) will have moved
on and the previous state will be lost.

```
git reset --hard ORIG_HEAD
```

Another method is to rebase to a specific SHA that was present before you rebased.

Example: 

```
$ git rebase merge
$ git log --oneline -n 4

    dcea909 (HEAD -> feature/double-roll) Add double roll test
    66f7256 add double rolling feature
    f7b5964 (master) Fix serious bug
    d2cdb98 first dice implementation

$ git rebase --onto f7b5964 master feature/double-roll

    dde675d (HEAD -> feature/double-roll) Add double roll test
    9b63a59 add double rolling feature
    d2cdb98 first dice implementation
    d77e384 first
```

### Squashing Example

Useful for when you have a bunch of junk commits that need to merged into one neat
commit message; squashing commits.

```
$ git log --oneline

    2cec8ce (HEAD -> master) Add test
    77172ae Better implementation
    aec6a59 first dice implementation
    d77e384 first
```

Pick the commit before the one you want to squash (the first commit in this case)

```
$ git rebase -i d77e384

    pick aec6a59 first dice implementation
    pick 77172ae Better implementation
    pick 2cec8ce Add test
```

Squash all the commits of interest and :wq. All the commits will be combined now.

```
pick aec6a59 first dice implementation
squash 77172ae Better implementation
squash 2cec8ce Add test
```


## List Branches

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

Resource can be found [here](https://longair.net/blog/2009/04/16/git-fetch-and-merge/)

Both download the branches most recent commits.

Fetch only downloads new data from the remote repo and updates your remote tracking branches.

It does not merge the remote tracking branches into your local branches.

```
git fetch origin

git merge origin/master
```

Pull downloads and merges the remote changes from the remote server to your current HEAD branch.

```
git pull origin master
```

It download

## Syncing Forked Repo

https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork

Add remote to original:

```
git remote add upstream https://github.com/WeblateOrg/wlc
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

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


## Tags

A named reference to a commit, most often used to mark releases.

### Create

```
# lightweight: no comment
git tag <tag-name> <commit-sha>

# annotated tag
git tag -a <tag-name> -m <tag-message> <commit-sha>

# push to repo
git push origin <tag-name>

# push all tags
git push origin --tags
```

### List

```
# list all tags
git tag -l

# list all tags and the annotations
git tag -l -n

# list all v2.x tags
git tag -l "v2*"

# see changes made between versions?
git show v1.1

# diff between tags
git diff v1.0..v1.1
```

### Delete

```
# delete tag locally
git tag -d v1.1

# delete tag remotely
git push -d origin v1.1
```

### Checkout

Cannot just checkout the tag as you will be checking out a previous commit,
better to create a branch then checkout to the tag/sha

```
# right way; not tested this.
git checkout -b new_branch v1.1
git checkout v1.1
```

## Show

Shows the diff between a given commit and the previous one

```
# shows the difference
git show <commit-sha>
```

## Diff

```
# diff between current branch and master
git diff master...
```

## Log

```
# git log with diffs

git log -p

git log --author "David Ross"

git log --until "1 week ago" --since "5 months ago"

git log --after "2020-01-01" --before "2020-06-01"

git log --after "today"

git log -i --grep "dra-350"

git log setup.py

git log -S "def main()"

git log master..develop

git log --merges

# show commits by John between Jan -> June 2020
# that altered the main function and a commit message
# with the word 'delete' in it in main.py

git log \
  --author "John Hancock" \
  --after "2020-01-01" \
  --before "2020-06-01" \
  -i --grep "delete" \
  -S "def main()" \
  main.py
```


## Apply a Patch

Create a patch:

```sh
git diff > my.patch
```

Apply the patch to a different machine (this can be shared amongst devs):

```sh
git apply my.patch
```
