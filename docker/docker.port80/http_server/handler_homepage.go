package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

var (
	homePageMux                               *http.ServeMux
	homePageHTML, innerPageHTML, ariaPageHTML []byte
)

func initHomePage() {
	var err error
	homePageHTML, err = ioutil.ReadFile(rootdir + "/homepage.html")
	if err != nil {
		fmt.Println("[E] read homepage error")
	}
	innerPageHTML, err = ioutil.ReadFile(rootdir + "/homepage_inner.html")
	if err != nil {
		fmt.Println("[E] read homepage_inner.html error")
	}
	ariaPageHTML, err = ioutil.ReadFile(rootdir + "/ariaNg_ModifiedByHbl.html")
	if err != nil {
		fmt.Println("[E] read homepage_inner.html error")
	}

	homePageMux = http.NewServeMux()

	homePageMux.HandleFunc("/", homePage)
	homePageMux.HandleFunc("/home", homePageInner)
	homePageMux.HandleFunc("/home/", homePageInner)
	homePageMux.HandleFunc("/static", homeStatic)
	homePageMux.HandleFunc("/static/", homeStatic)

	homePageMux.HandleFunc("/ariaNg", ariang)
	homePageMux.HandleFunc("/ariaNg/", ariang)
	homePageMux.HandleFunc("/ariang", ariang)
	homePageMux.HandleFunc("/ariang/", ariang)

	proxyHandle["server.lan"] = homePageMux
}

func homePage(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write(homePageHTML)
}

func homePageInner(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write(innerPageHTML)
}

func homeStatic(w http.ResponseWriter, r *http.Request) {
	http.FileServer(http.Dir(rootdir))
}

// ariaNg_ModifiedByHbl.html
// http://server.lan/ariaNg
func ariang(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write(ariaPageHTML)
}
