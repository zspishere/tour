package main

import (
	_ "go.uber.org/automaxprocs"
	"log"
	"test.com/shuzhang/tour/cmd"
)

func main() {
	log.Printf("let us begin ...")
	err := cmd.Execute()
	if err != nil {
		log.Fatalf("cmd.Execute err: %v", err)
	}
}

