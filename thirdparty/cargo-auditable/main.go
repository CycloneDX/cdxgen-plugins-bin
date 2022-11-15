package main

import (
	"fmt"
	"github.com/microsoft/go-rustaudit"
	"io/fs"
	"os"
	"runtime"
	"strings"
)

func main() {
	os.Exit(run(os.Args[1:]))
}

func run(args []string) int {
	if len(args) == 0 {
		fmt.Printf("cargo-auditable %s %s/%s\n", runtime.Version(), runtime.GOOS, runtime.GOARCH)
		return 0
	}
	exitStatus := 0
	for _, arg := range args {
		info, err := os.Stat(arg)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			exitStatus = 1
			continue
		}
		scanFile(arg, info)
	}
	return exitStatus
}

// isExe reports whether the file should be considered executable.
func isExe(file string, info fs.FileInfo) bool {
	if runtime.GOOS == "windows" {
		return strings.HasSuffix(strings.ToLower(file), ".exe")
	}
	return info.Mode().IsRegular() && info.Mode()&0111 != 0
}

func scanFile(file string, info fs.FileInfo) {
	if info.Mode()&fs.ModeSymlink != 0 {
		// Accept file symlinks only.
		i, err := os.Stat(file)
		if err != nil || !i.Mode().IsRegular() {
			fmt.Fprintf(os.Stderr, "%s: symlink\n", file)
			return
		}
		info = i
	}

	if !isExe(file, info) {
		fmt.Fprintf(os.Stderr, "%s: not executable file\n", file)
		return
	}

	r, err := os.Open(file)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s: not executable file\n", file)
		return
	}
	versionInfo, err := rustaudit.GetDependencyInfo(r)
	for _, dep := range versionInfo.Packages {
		fmt.Printf("%s\t%s\t%s\n", dep.Name, dep.Version, dep.Source)
	}
}
