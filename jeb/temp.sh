git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch opencv2.framework' \
--prune-empty --tag-name-filter cat -- --all
