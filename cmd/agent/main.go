package main

import (
	"os"

	"github.com/kubeshop/testkube/pkg/executor/agent"
	"github.com/lreimer/testkube-executor-k6/pkg/runner"
)

func main() {
	agent.Run(runner.NewRunner(), os.Args)
}
