#!/bin/bash

PARENT_DIR="test"  # Replace with the path to your 'clients' directory
OLD_EMAIL="mrcodblackops10@gmail.com"
CORRECT_NAME="Rim"
CORRECT_EMAIL="anonymous@mail.com"
ORIGINAL_DIR=$(pwd)

rewrite_history() {
    echo "Rewriting history for $1"
    cd "$1" || exit
    git filter-branch --env-filter "
    if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]
    then
        export GIT_COMMITTER_NAME=\"$CORRECT_NAME\"
        export GIT_COMMITTER_EMAIL=\"$CORRECT_EMAIL\"
    fi
    if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]
    then
        export GIT_AUTHOR_NAME=\"$CORRECT_NAME\"
        export GIT_AUTHOR_EMAIL=\"$CORRECT_EMAIL\"
    fi
    " -f --tag-name-filter cat -- --branches --tags
    cd "$ORIGINAL_DIR"
}

force_push() {
    echo "Force pushing for $1"
    cd "$1" || exit
    git push origin --force --all
    git push origin --force --tags
    cd "$ORIGINAL_DIR"
}

for dir in $PARENT_DIR/*; do
    if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
        if [ "$1" = "push" ]; then
            force_push "$dir"
        else
            rewrite_history "$dir"
        fi
    fi
done