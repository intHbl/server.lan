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
		fmt.Println("[Info] HTTPS is enable")
		return true
		//fmt.Println("[Err] HTTPS is not implemented!! use http instead. ")
	}

	return false
}

func startServer() {
	http.HandleFunc("/", reverseProxy)
	fmt.Println("[INFO] if need https, please run with the arg1='HTTPS' < ./http_server HTTPS >. ")
	fmt.Println("      and with those files :: './server.crt' './server.key' in the same directory")
	if enableHTTPS() {
		go http.ListenAndServe("0.0.0.0:80", &redirectHTTPS{})
		http.ListenAndServeTLS("0.0.0.0:443", rootdir+"/server.crt", rootdir+"/server.key", nil)
	} else {
		http.ListenAndServe("0.0.0.0:80", nil)
	}
}

func reverseProxy(w http.ResponseWriter, r *http.Request) {
	if v, ok := proxyHandle[r.Host]; ok {
		//r.Host ==
		///"server.lan"
		///"git.server.lan" || r.Host == "git.lan"
		///"down.server.lan"
		///"v.server.lan"
		///....
		v.ServeHTTP(w, r)
	}
}
