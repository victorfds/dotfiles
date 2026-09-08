# Oh My Zsh git shortcuts, as fish abbreviations (Kitty default shell).
# Same names as plugins/git: gst, gp, gl, gco, gcmsg, ...
status is-interactive; or return

function git_current_branch
    command git symbolic-ref --quiet --short HEAD 2>/dev/null
    or command git rev-parse --short HEAD 2>/dev/null
end

function git_main_branch
    command git rev-parse --git-dir >/dev/null 2>&1; or return
    for ref in refs/heads/{main,trunk,mainline,default,stable,master} \
               refs/remotes/{origin,upstream}/{main,trunk,mainline,default,stable,master}
        if command git show-ref -q --verify $ref
            basename $ref
            return 0
        end
    end
    echo master
    return 1
end

function git_develop_branch
    command git rev-parse --git-dir >/dev/null 2>&1; or return
    for branch in dev devel develop development
        if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return 0
        end
    end
    echo develop
    return 1
end

abbr -a g git
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gapa 'git add --patch'
abbr -a gau 'git add --update'
abbr -a gb 'git branch'
abbr -a gba 'git branch --all'
abbr -a gbd 'git branch --delete'
abbr -a gbD 'git branch --delete --force'
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gcp 'git cherry-pick'
abbr -a gcpa 'git cherry-pick --abort'
abbr -a gcpc 'git cherry-pick --continue'
abbr -a gcl 'git clone --recurse-submodules'
abbr -a gc 'git commit --verbose'
abbr -a gca 'git commit --verbose --all'
abbr -a gcmsg 'git commit --message'
abbr -a gcam 'git commit --all --message'
abbr -a gd 'git diff'
abbr -a gdca 'git diff --cached'
abbr -a gds 'git diff --staged'
abbr -a gf 'git fetch'
abbr -a gfa 'git fetch --all --tags --prune --jobs=10'
abbr -a gfo 'git fetch origin'
abbr -a glo 'git log --oneline --decorate'
abbr -a glog 'git log --oneline --decorate --graph'
abbr -a gloga 'git log --oneline --decorate --graph --all'
abbr -a glg 'git log --stat'
abbr -a gl 'git pull'
abbr -a gpr 'git pull --rebase'
abbr -a gp 'git push'
abbr -a gpf 'git push --force-with-lease --force-if-includes'
abbr -a gpf! 'git push --force'
abbr -a gm 'git merge'
abbr -a gma 'git merge --abort'
abbr -a gmc 'git merge --continue'
abbr -a grb 'git rebase'
abbr -a grba 'git rebase --abort'
abbr -a grbc 'git rebase --continue'
abbr -a grbi 'git rebase --interactive'
abbr -a gr 'git remote'
abbr -a grv 'git remote --verbose'
abbr -a grh 'git reset'
abbr -a grhh 'git reset --hard'
abbr -a grs 'git restore'
abbr -a grst 'git restore --staged'
abbr -a grm 'git rm'
abbr -a gsh 'git show'
abbr -a gsta 'git stash push'
abbr -a gstaa 'git stash apply'
abbr -a gstp 'git stash pop'
abbr -a gstl 'git stash list'
abbr -a gst 'git status'
abbr -a gss 'git status --short'
abbr -a gsb 'git status --short --branch'
abbr -a gsw 'git switch'
abbr -a gswc 'git switch --create'
abbr -a gsu 'git submodule update'
abbr -a gsi 'git submodule init'

function gcm
    git checkout (git_main_branch)
end

function gcd
    git checkout (git_develop_branch)
end

function gswm
    git switch (git_main_branch)
end

function gpsup
    git push --set-upstream origin (git_current_branch)
end

function ggpull
    git pull origin (git_current_branch)
end

function ggpush
    git push origin (git_current_branch)
end

function ggl
    if test (count $argv) -eq 0
        git pull origin (git_current_branch)
    else
        git pull origin $argv
    end
end

function ggp
    if test (count $argv) -eq 0
        git push origin (git_current_branch)
    else
        git push origin $argv
    end
end
