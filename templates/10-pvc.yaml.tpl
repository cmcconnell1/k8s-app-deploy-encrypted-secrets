---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: "__MYAPP_PERSISTENT_STORAGE_CLAIMNAME__"
  labels:
    app: "myapp"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: "__MYAPP_PERSISTENT_STORAGE_VOLSIZE__"
