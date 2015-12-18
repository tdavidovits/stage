#!/bin/bash +xe
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the GNU Lesser General Public License
# (LGPL) version 2.1 which accompanies this distribution, and is available at
# http://www.gnu.org/licenses/lgpl-2.1.html
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# Contributors:
#T. Davidovits
#J. Carsique
# implemente NXBT-736: cleanup deprecated branches

#declare -a array

# Output files
FILE_LIST=/tmp/cleanup-complete
FILE_UNKNOWN=/tmp/cleanup-unknown
FILE_DELETE=/tmp/cleanup-delete
FILE_KEEP=/tmp/cleanup-keep

analyze() {
	echo "# Branches analyzed" > $FILE_LIST
	echo "# Unrecognized branch name pattern" > $FILE_UNKNOWN
	echo "# Branches to delete" > $FILE_DELETE
	echo "# Active branches to keep (reason within parenthesis)" > $FILE_KEEP

	complete=`git branch -r`

	echo "Nb branches before cleanup: $(echo $complete|wc -w)"
	git reflog expire --all --expire=now
	git gc --prune=now --aggressive
	echo "Nb commit objects before cleanup: $(git rev-list --objects --all|wc -l)"
	git count-objects -vH

	echo "Looking for branches older than 3 months and which JIRA issue is resolved or closed..."
	for branch in $complete; do
		echo "working on $branch" >> $FILE_LIST
		for pattern in "^origin/master$" "^origin/stable$" "^origin/\d+\.\d+(\.\d+)?-HF\d\d-SNAPSHOT$" "^origin/\d+\.\d+(\.\d+)?$" ; do
			if [[ $branch =~ $pattern ]]; then
				echo "$branch (pattern $pattern)" >> $FILE_KEEP
				continue 2
			fi
		done

		if [ -z "$(git log -1 --since='3 months ago' --oneline $branch)" ]; then
		    jira=$(echo "$branch" | awk 'match($0,"(NXP|NXBT)-[0-9]+") {print substr($0,RSTART,RLENGTH)}')
			if [ -z "$jira" ]; then
				echo $branch >> $FILE_UNKNOWN
				continue
			fi
			# Check JIRA ref exists
			rc=$(curl -I -o /dev/null -w "%{http_code}" -s https://jira.nuxeo.com/rest/api/2/issue/$jira)
			if [ $rc -ne 200 ]; then
				echo "$branch ($jira does not exist)" >> $FILE_UNKNOWN
				continue
			fi
		    status=$(curl -s https://jira.nuxeo.com/rest/api/2/issue/$jira?fields=status|python -c 'import sys, json; print json.load(sys.stdin)["fields"]["status"]["id"]')
		    tags=$(curl -s https://jira.nuxeo.com/rest/api/2/issue/$jira?fields=customfield_10080|python -c 'import sys, json; print json.load(sys.stdin)["fields"]["customfield_10080"]')
			if (echo "$tags"|grep -q 'backport-'); then
				echo "$branch ($jira has a backport tag)" >> $FILE_KEEP
			elif [ $status -eq 5 -o $status -eq 6 ]; then
				echo $branch >> $FILE_DELETE
			else
				echo "$branch ($jira not resolved)" >> $FILE_KEEP
			fi
		else
			echo "$branch (<3 months)" >> $FILE_KEEP
		fi
	done

	echo
	echo "Branches analyzed: $FILE_LIST"
	echo "Unrecognized branch name pattern: $FILE_UNKNOWN"
	echo "Branches to delete: $FILE_DELETE"
	echo "Active branches to keep: $FILE_KEEP"
}

perform() {
	while read branch; do
		[[ $branch =~ "^#" ]] && continue
		git push --delete origin "$branch"
	done < "$FILE_DELETE"
	git reflog expire --all --expire=now
	git gc --prune=now --aggressive
	echo "Nb branches after cleanup: $(git branch -r|wc -l)"
	echo "Nb commit objects after cleanup: $(git rev-list --objects --all|wc -l)"
	git count-objects -vH
}

if [ "$#" -eq 0 ]; then
	echo "Usage: $0 [analyze|perform|full]"
	exit 1
elif [ "$1" = "analyze" ]; then
	analyze
elif [ "$1" = "full" ]; then
	analyze
	perform
elif [ "$1" = "perform" ]; then
	perform
fi
exit 0


