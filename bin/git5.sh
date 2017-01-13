#! /bin/sh

case $1 in
  export|patch|mail|submit|lint|merge|drop|revert|hint|fix|findreviewers ) git5 "$@" ;;
  sync ) (export BRANCH=$(git rev-parse --abbrev-ref HEAD)\
    && git stash \
    && git checkout master \
    && git5 sync \
    && git checkout "$BRANCH" \
    && git rebase master);;
  track ) (export BRANCH=$(git rev-parse --abbrev-ref HEAD)\
    && git stash \
    && git checkout master \
    && git5 "$@" \
    && git checkout "$BRANCH" \
    && git rebase master);;
  * ) git "$@";;
esac
