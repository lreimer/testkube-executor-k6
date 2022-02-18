![Testkube Logo](https://raw.githubusercontent.com/kubeshop/testkube/main/assets/logo-dark-text.png)

# Welcome to TestKube K6 Executor

TestKube k6 Executor is a test executor to run k6 load tests with [TestKube](https://testkube.io).  
This repository is based on the [executor template](https://github.com/kubeshop/testkube-executor-template).

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
kubectl testkube scripts create --file k6-test-script.js --type "k6/script" --name k6-test-script
kubectl testkube scripts start k6-test-script
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.