// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package version implements the “go version” command.
package main

import (
	"debug/buildinfo"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"runtime"
	"strings"

)

func main() {
  os.Exit(runVersion(os.Args[1:]))
}

func runVersion(args []string) int {
	if len(args) == 0 {
		fmt.Printf("go version %s %s/%s\n", runtime.Version(), runtime.GOOS, runtime.GOARCH)
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
		if info.IsDir() {
			scanDir(arg)
		} else {
			scanFile(arg, info)
		}
	}
  return exitStatus
}

// scanDir scans a directory for binary to run scanFile on.
func scanDir(dir string) {
	filepath.WalkDir(dir, func(path string, d fs.DirEntry, err error) error {
		if d.Type().IsRegular() || d.Type()&fs.ModeSymlink != 0 {
			info, err := d.Info()
			if err != nil {
					fmt.Fprintf(os.Stderr, "%s: %v\n", path, err)
				return nil
			}
			scanFile(path, info)
		}
		return nil
	})
}

// isGoBinaryCandidate reports whether the file is a candidate to be a Go binary.
func isGoBinaryCandidate(file string, info fs.FileInfo) bool {
	if info.Mode().IsRegular() && info.Mode()&0111 != 0 {
		return true
	}
	name := strings.ToLower(file)
	switch filepath.Ext(name) {
	case ".so", ".exe", ".dll":
		return true
	default:
		return strings.Contains(name, ".so.")
	}
}

// scanFile scans file to try to report the Go and module versions.
// If mustPrint is true, scanFile will report any error reading file.
// Otherwise (mustPrint is false, because scanFile is being called
// by scanDir) scanFile prints nothing for non-Go binaries.
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

	bi, err := buildinfo.ReadFile(file)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s: %v\n", file, err)
		return
		return
	}

	fmt.Printf("%s: %s\n", file, bi.GoVersion)
	bi.GoVersion = "" // suppress printing go version again
	mod := bi.String()
	if len(mod) > 0 {
		fmt.Printf("\t%s\n", strings.ReplaceAll(mod[:len(mod)-1], "\n", "\n\t"))
	}
}
