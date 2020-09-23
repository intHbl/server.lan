package main

import (
	"fmt"
	"net/http"
	"net/http/httputil"
	"os"
//        "path/filepath"
)

func main() {
	http.HandleFunc("/jsonrpc", func(w http.ResponseWriter, r *http.Request) {
		director := func(req *http.Request) {
			req.URL.Scheme = "http"
			req.URL.Host = "127.0.0.1:6801"
			req.URL.Path=r.URL.Path
		}
		proxy := &httputil.ReverseProxy{Director: director}
		proxy.ServeHTTP(w, r)
	})

	// http.Handle("/jsonrpc",http.redirect("127.0.0.1:6801"))
	
	http.Handle("/", http.FileServer(http.Dir(os.Args[1]))  )
	err := http.ListenAndServe(":6800", nil)
	if err != nil {
		fmt.Println(err)
	}
}


