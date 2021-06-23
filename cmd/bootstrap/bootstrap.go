package bootstrap

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/gorilla/mux"
)

// Server define an http standard library
type Server struct {
	server *http.Server
}

func Root(w http.ResponseWriter, r *http.Request) {
	response := "Welcome to Kind Golang"
	fmt.Fprintf(w, response)
}

func Run() error {
	// Initialize the database connection

	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080"
	}

	r := mux.NewRouter()
	r.HandleFunc("/", Root)
	http.Handle("/", r)

	// set configuration to our server
	serv := &http.Server{
		Addr:         ":" + port,
		Handler:      r,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	server := Server{server: serv}

	// start the server.
	go Start(server)
	// Wait for an in interrupt panic
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c

	// Attempt a graceful shutdown.
	Close()
	return nil
}

// Start the server.
func Start(srv Server) {
	log.Printf("Server running on http://localhost%s", srv.server.Addr)
	log.Fatal(srv.server.ListenAndServe())
}

// Close server resources.
func Close() error {
	return nil
}
