package runner

import (
	"fmt"

	"github.com/kubeshop/testkube/pkg/api/v1/testkube"
	"github.com/kubeshop/testkube/pkg/executor"
	"github.com/kubeshop/testkube/pkg/executor/content"
	"github.com/kubeshop/testkube/pkg/executor/output"
)

func NewRunner() *K6Runner {
	return &K6Runner{
		Fetcher: content.NewFetcher(),
	}
}

type K6Runner struct {
	Fetcher content.ContentFetcher
}

func (r *K6Runner) Run(execution testkube.Execution) (result testkube.ExecutionResult, err error) {
	path, err := r.Fetcher.Fetch(execution.Content)
	if err != nil {
		output.PrintError(err)
		return result, err
	}

	if !execution.Content.IsFile() {
		output.PrintLog("Execution script content not a file.")
		return result, testkube.ErrScriptContentTypeNotFile
	}

	args := []string{"run"}
	for key, value := range execution.Params {
		flag := fmt.Sprintf("--%s", key)
		args = append(args, flag, value)
	}
	args = append(args, execution.Args...)
	args = append(args, path)

	output.PrintEvent("Running k6", args)
	output, err := executor.Run("", "k6", args...)
	if err != nil {
		return result.Err(err), nil
	}

	return testkube.ExecutionResult{
		Status: testkube.StatusPtr(testkube.SUCCESS_ExecutionStatus),
		Output: string(output),
	}, nil
}
