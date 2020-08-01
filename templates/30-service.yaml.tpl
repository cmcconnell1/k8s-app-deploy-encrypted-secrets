apiVersion: v1
kind: Service
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  ports:
    - port: __HTTP_PORT__
  selector:
    app: myapp
