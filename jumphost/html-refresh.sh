#!/bin/bash
#########################################################
# Update HTML display					#
#########################################################
echo "html-refresh : Begin html refresh..."
DIR="/opt/ocp/ironic/html/results"

cat >$DIR/index.html <<EOL
<!DOCTYPE html>
<html>
<head>
<style>
table {
  width:100%;
}
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 15px;
  text-align: left;
}
table#t01 tr:nth-child(even) {
  background-color: #eee;
}
table#t01 tr:nth-child(odd) {
 background-color: #fff;
}
table#t01 th {
  background-color: black;
  color: white;
}
</style>
</head>
<body>
<center><h1>Integration Lab Job Completion</h1></center>
<table id="t01">
<tr><th>Completion Date</th><th>Version</th><th>Job State</th><th>Net Type</th><th>CNV</th><th>Pods</th><th>Nodes</th><th>Operators</th><th>Raw Logs</th></tr>
EOL

for f in `ls -1t $DIR`; do
  if [ "$f" != "index.html" ]; then
  source $DIR/$f/vars-env
  RUNTIME=`date -d @$EPOCH`
  echo "<tr><td>$RUNTIME</th><td>$VERSION</td><td>$JOBSTATE</td><td>IPv$NET</td><td>$CNV</td><td><a href="$f/ocgetpods.log">Link</a></td><td><a href="$f/ocgetnodes.log">Link</a></td><td><a href="$f/ocgetclustero
perators.log">Link</a></td><td><a href="$f">Link</a></td></tr>">>$DIR/index.html
  fi
done

cat >>$DIR/index.html <<EOL
</table>
</body>
</html>
EOL

echo "html-refresh : Completed html refresh"
