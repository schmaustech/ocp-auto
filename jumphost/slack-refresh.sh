#!/bin/bash
#########################################################
# Notify Slack of Job Completion #DCI			#
#########################################################
echo "slack-refresh : Begin Slack notification..."
export LASTRUN=`ls -1artd  /opt/ocp/ironic/html/results/*/|tail -1`
source $LASTRUN/vars-env
curl -X POST -H 'Content-type: application/json' --data '{"text" : "'"RNA1 Integration Lab $VERSION IPv$NET $JOBSTATE"'"}' https://hooks.slack.com/services/hook-string
echo "slack-refresh : Completed Slack notification!"
