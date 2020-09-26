package main

import (
	"net/http"
)

var gitHandler http.Handler

func initGitServer() {
	// redirect to  127.0.0.1:3000

	gitHandler = NewHTTPProxy("http", "127.0.0.1:3000")

}
