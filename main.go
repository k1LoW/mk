package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

const version = "0.2.0"

func main() {
	args := os.Args

	dir, err := os.Getwd()
	if err != nil {
		_, _ = os.Stderr.WriteString(fmt.Sprintf("%s", err))
		os.Exit(1)
	}
	makefileDir, err := findUpMakefileDir(dir)
	if err != nil {
		_, _ = os.Stderr.WriteString(fmt.Sprintf("%s", err))
		os.Exit(1)
	}
	cmd := exec.Command("make", args[1:]...)
	cmd.Dir = makefileDir
	if !contains(args, []string{"-s", "--silent", "--quiet"}) {
		fmt.Printf("(in %s)\n", makefileDir)
	}
	cmd.Env = os.Environ()
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		os.Exit(1)
	}
}

func findUpMakefileDir(dir string) (string, error) {
	mPath := filepath.Join(dir, "Makefile")
	if _, err := os.Lstat(mPath); err == nil {
		return dir, nil
	} else if dir == "/" {
		return "", errors.New("Makefile not found")
	}
	parentDir := filepath.Dir(dir)
	return findUpMakefileDir(parentDir)
}

func contains(strs []string, substrs []string) bool {
	for _, s := range strs {
		for _, sub := range substrs {
			if s == sub {
				return true
			}
		}
	}
	return false
}
