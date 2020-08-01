apiVersion: apps/v1
kind: Deployment
metadata:
  name: "myapp"
  namespace: "myapp"
  labels:
    app: "myapp"
spec:
  selector:
    matchLabels:
      app: "myapp"
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: "myapp"
      annotations:
        prometheus.io/port: "__PROMETHEUS_IO_PORT__"
        prometheus.io/scrape: "__PROMETHEUS_IO_SCRAPE__"
    spec:
      containers:
      - name: "myapp"
        image: "__MYAPP_REPO__:__BUILD_VERSION__"
        envFrom:
        - configMapRef:
            name: "myapp-config"
        - secretRef:
            name: "myapp-secrets"
        ports:
        - containerPort: __HTTP_PORT__
        workingDir: "/opt/myapp"
        volumeMounts:
        - name: "myapp-persistent-storage"
          mountPath: "__MYAPP_PERSISTENT_STORAGE_MOUNTPATH__"
      volumes:
      - name: "myapp-persistent-storage"
        persistentVolumeClaim:
          claimName: "__MYAPP_PERSISTENT_STORAGE_CLAIMNAME__"
