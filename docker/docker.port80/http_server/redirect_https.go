package main

import (
	"fmt"
	"net/http"
	"os"
)

type redirectHTTPS struct{}

func (*redirectHTTPS) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// http -> https
	target := "https://server.lan" + r.URL.Path
	if len(r.URL.RawQuery) > 0 {
		target += "?" + r.URL.RawQuery
	}
	http.Redirect(w, r, target, http.StatusTemporaryRedirect)
}

func enableHTTPS() bool {
	//
	if len(os.Args) >= 2 && (os.Args[1] == "https" || os.Args[1] == "HTTPS") {
		//TODO :: not implemented!!!
		//return true
		fmt.Println("[Err] HTTPS is not implemented!! use http instead. ")

	}

	return false
}

func startServer() {
	fmt.Println("[INFO] if need https, please run with the arg1='HTTPS' < ./http_server HTTPS >. ")
	fmt.Println("      and with those files :: './server.crt' './server.key' in the same directory")
	if enableHTTPS() {
		go http.ListenAndServe("0.0.0.0:80", &redirectHTTPS{})
		http.ListenAndServeTLS("0.0.0.0:443", "server.crt", "server.key", nil)
	} else {
		http.ListenAndServe("0.0.0.0:80", nil)
	}
}
