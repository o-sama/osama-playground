// https://pkg.go.dev/path/filepath
// https://pkg.go.dev/os
// https://pkg.go.dev/bufio

package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

func main() {
	/*	Initialize logFile to empty string
		If an argument is passed, use that as the path to log file
		Otherwise, use the default path	*/
	logFile := ""
	if len(os.Args) > 1 {
		logFile = os.Args[1]
	} else {
		path, err := os.Executable()
		if err != nil {
			log.Fatal(err)
		}

		// EvalSymLinks checks for symlinks then returned the path after evaluating them, then it also calls filepath.Clean()
		cleanPath, err := filepath.EvalSymlinks(path)
		if err != nil {
			log.Fatal(err)
		}
		logFile = filepath.Join(filepath.Dir(cleanPath), "logfile.log")
	}

	// Open the file in readonly mode and defer its closure.
	file, err := os.Open(logFile)
	if err != nil {
		log.Fatalf("Got the following error when opening the log file: %v", err)
	}
	defer file.Close()

	// use a map to initially store the data since its operations are quick
	ipCounter := make(map[string]int)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		// Split each line based on the format we have, <timestamp> <ip address> <everything else>, we only care about the ip address here
		fields := strings.SplitN(line, " ", 3)
		ipCounter[fields[1]]++
	}

	// error check to see if we encountered any errors
	if err := scanner.Err(); err != nil {
		log.Printf("Got the following error reading log file: %v", err)
	}

	// Using a slice of structs allows for easy sorting using the standard library
	type ipCount struct {
		ip    string
		count int
	}
	var sorted []ipCount

	// Populate the slice then sort descending based on count
	for k, v := range ipCounter {
		sorted = append(sorted, ipCount{k, v})
	}
	sort.Slice(sorted, func(i, j int) bool { return sorted[i].count > sorted[j].count })

	// Print each element in the slice in the required format
	for _, v := range sorted {
		fmt.Printf("%d %s\n", v.count, v.ip)
	}
}
