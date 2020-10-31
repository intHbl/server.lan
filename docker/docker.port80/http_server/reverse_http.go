package main

import (
	"fmt"
	"net/http"
	"net/http/httputil"
)

//NewHTTPProxy makes a http proxy ,with a simple director
func NewHTTPProxy(scheme, host string) *httputil.ReverseProxy {

	director := func(req *http.Request) {
		tmp := req.URL.Host
		req.URL.Scheme = scheme //"http",
		req.URL.Host = host     //"localhost:3000",
		//req.URL.Path = target.Path
		fmt.Printf("[INFO] %s -> %s \n", tmp, host)
	}
	return &httputil.ReverseProxy{Director: director}
}
