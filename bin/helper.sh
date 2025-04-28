#!/usr/bin/env bash
set -eu

DATABASE=postgres
PGHOST=postgres-pgcluster-cluster-rw.postgres.svc
NAMESPACE=${NAMESPACE:-postgres}
PASSWORD=postgres
PORT=5432
PGUSER=postgres

CMD=apply

while [[ $# > 0 ]]; do
  key="$1"
  case $key in
    start)
      CMD=apply
      ;;
    stop)
      CMD=delete
      ;;
    -d|--database)
      DATABASE="$2"
      shift
      ;;
    -h|--host)
      PGHOST="$2"
      shift
      ;;
    -n|--namespace)
      NAMESPACE="$2"
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      ;;
    -P|--port)
      PORT="$2"
      shift
      ;;
    -u|--user)
      PGUSER="$2"
      shift
      ;;
    *)
      echo "Unknown option: $key"
      exit 1
  esac
  shift
done

kubectl $CMD -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: psql
  namespace: $NAMESPACE
spec:
  containers:
  - name: postgres-client
    image: postgres:17.2  # Use the same PostgreSQL version as your CNPG cluster
    command: ["sleep", "infinity"]  # Keep the pod running
    env:
    - name: PGHOST
      value: $PGHOST
    - name: PGPORT
      value: "$PORT"
    - name: PGDATABASE
      value: $DATABASE
    - name: PGUSER
      value: $PGUSER
    - name: PGPASSWORD
      value: $PASSWORD
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "200m"
#    volumeMounts:
#      - name: pgdata
#        mountPath: /var/lib/postgresql/data
#  volumes:
#    - name: pgdata
#      persistentVolumeClaim:
#        claimName: postgres-pgcluster-cluster-1
  restartPolicy: Never
EOF
if [[ $CMD = apply ]]; then
  echo "Waiting for pod psql to be ready..."
  kubectl wait --for=condition=Ready pod/psql -n $NAMESPACE --timeout=300s
  kubectl exec -itn $NAMESPACE psql -- bash
fi