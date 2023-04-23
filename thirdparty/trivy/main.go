package main

import (
	"github.com/aquasecurity/trivy/pkg/commands"
	"os"

	_ "modernc.org/sqlite" // sqlite driver for RPM DB and Java DB
)

var (
	version = "dev"
)

func main() {
	os.Exit(run())
}

func run() int {
	exitStatus := 0
	app := commands.NewApp(version)
	if err := app.Execute(); err != nil {
		exitStatus = 1
	}
	return exitStatus
}
