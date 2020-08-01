# * * * * *  command to execute
# │ │ │ │ │
# │ │ │ │ │
# │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# │ │ │ └────────── month (1 - 12)
# │ │ └─────────────── day of month (1 - 31)
# │ └──────────────────── hour (0 - 23)
# └───────────────────────── min (0 - 59)
#
# Note: change the command and the args for whatever is needed for myapp curl tests.
# ref: https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/#creating-a-cron-job
# ref: https://crontab-generator.org

#apiVersion: batch/v1beta1
#kind: CronJob
#metadata:
#  name: myapp-cronjob
#  namespace: myapp
#spec:
#  # run at 4:30, 5:30, 6:30, 7:30 every day
#  schedule: "30 16,17,18,19 * * *"
#  concurrencyPolicy: "Forbid"
#  failedJobsHistoryLimit: 10
#  successfulJobsHistoryLimit: 5
#  startingDeadlineSeconds: 600 # 10 min
#  jobTemplate:
#    spec:
#      backoffLimit: 0
#      activeDeadlineSeconds: 3300 # 55min
#      template:
#        spec:
#          containers:
#          - name: myapp-cronjob 
#            image: nicolaka/netshoot
#            command: ["uptime"]
#            args: [""]
#          restartPolicy: Never
