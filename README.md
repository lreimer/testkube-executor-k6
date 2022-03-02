:information_source: This repository has been archived on favour of the now official [TestKube K6 Executor](https://github.com/testkube/testkube-executor-k6)

# Welcome to TestKube K6 Executor

TestKube k6 Executor is a test executor to run k6 load tests with [TestKube](https://testkube.io).

## Usage

First, you need to register and deploy the executor in your cluster. Additionally, you may deploy InfluxDB as well as Grafana if you need detailed performance data from your tests.
```bash
kubectl apply -f k8s/k6-executor.yaml
kubectl apply -f k8s/k6-influxdb.yaml
kubectl apply -f k8s/k6-grafana.yaml
```

Now we're ready to create and run your K6 scripts by passing as a file. Have a look at the [k6 documentation](https://k6.io/docs/getting-started/running-k6/) for details. Here is an example
load script.
```javascript
import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('https://test.k6.io');
  sleep(1);
}
```

Issue the following commands to create and start the script:
```bash
kubectl testkube scripts create --file examples/k6-test-script.js --type "k6/script" --name k6-test-script

# this will basically run 'k6 run k6-test-script.js'
kubectl testkube scripts start k6-test-script

# this will basically run 'k6 run --vus 2 --duration 10s k6-test-script.js'
kubectl testkube scripts start k6-test-script -p vus=2 -p duration=10s

# this will basically run 'k6 run --out influxdb=http://influxdb-service:8086/k6 k6-test-script.js'
# make sure you have the k6 influxdb deployed
kubectl testkube scripts start k6-test-script -p out=influxdb=http://influxdb-service:8086/k6

# alternatively, the performance metrics can be published to Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -n testkube

# also, we need to compile a special k6 binary, will be part of the runner image
# see https://k6.io/docs/results-visualization/prometheus/

```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.
