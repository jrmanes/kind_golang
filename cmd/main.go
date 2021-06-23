package main

import (
	"log"

	"github.com/jrmanes/kind_golang/cmd/bootstrap"
)

func main() {
	if err := bootstrap.Run(); err != nil {
		log.Fatal(err)
	}
}
