package main

import (
	"net/http"
	"net/http/httputil"
)

//NewHTTPProxy makes a http proxy ,with a simple director
func NewHTTPProxy(scheme, host string) *httputil.ReverseProxy {

	director := func(req *http.Request) {

		req.URL.Scheme = scheme //"http",
		req.URL.Host = host     //"localhost:3000",
		//req.URL.Path = target.Path
	}
	return &httputil.ReverseProxy{Director: director}
}
