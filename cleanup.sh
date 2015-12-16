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
#!/bin/bash

# pour chaque branche dont le nom matche "origin/fix-*",
# s'il n'existe pas au moins un commit de moins de 3 mois,
# alors la branche est vieille de plus de 3 mois 

for br in $(git branch -r --list "origin/fix-*" --list "origin/feature-*" --list "origin/task-*"); do 
  if [ -z "$(git log -1 --since='3 months ago' --oneline $br)" ]; then
    echo "branch older than 3 months: $br"
  fi
done
