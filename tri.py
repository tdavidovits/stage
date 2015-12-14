#
# (C) Copyright 2015 Nuxeo SA (http://nuxeo.com/) and others.
#
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
#     T. Davidovits
#!/bin/python

import sys
print sys.argv[1:]

#t = [5, 7, 13, 8, 9, 34]
t = sys.argv[1:]
#print t
r = list(t)
for i in range(0, len(t)):
  a=int(t[i])
  idx = i
#  print 'idx %s'%idx
  for j in range(i+1, len(t)):
    b=int(t[j])
#    print b
    if a>b:
      a=b
      idx = j
#      print 'idx %s'%idx
#  print 'choix %s'%a
#  print 'permut t[%s] = %s'%(idx,t[i])
  r[i]=a
  t[idx]=str(t[i])

print r
