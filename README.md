# BIRD GAME

# Installation
make sure you have git and git lfs installed

```
git clone https://github.com/chrissolanilla/bird-game.git
cd bird-game
git lfs install
```

Now you can open the godot launcher and select the `bird-game` folder.

# Updating
`cd` into the project folder and do `git fetch` and `git pull`

# Contributing
To avoid merge conflicts, try your best to only add new files or edit things like scripts.
If you edit something like a model or a scene it will be harder to merge things.

I reccomend making your own branch so updates wont fuck you. You can also lock files
## making branches
to make a new git branch , first check what branch you are on.

`git branch` should tell you what branch you are on
if we are on the master branch, and we want to make a branch OFF of the master branch, then we can do `git checkout -b <your-new-branch>`

## locking files
If a file is locked, it will prevent you from commiting that file(like a scene(level) you are working on)
we can lock files by doing git lfs lock <path-to-file>

we can see all locked files by doing `git lfs locks`

## checking your local changes
if we want to see what things we have changed in our project, run `git status` and it will show you everything.
we can also do `git diff HEAD` to see a diff of our changes zand the main

## commiting
once we are ready, make sure we close the godot engine fully(save all your scenes) and then we can do `git add .` if you want to add everything.
If you want to only add stuff thats important youc an do `git add <path to your file>`. You can also do `git add -p`
and it will ask you a bunch of yes and no questins on what is good.

## now we are ready to commit
once you have added your changes(check with `git status`) and we have them staged for commit, then we can do `git commit -m "<your message in these qutoes>"`

## pushing it to github now
now we can add our changes for us to pull and check. If you are on branch called "david", then you can do `git push origin david`, if you are on master, then do `git push origin master`

