package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

var (
	homePageMux *http.ServeMux
)

func initHomePage() {

	//homepage = make([]byte, 200)
	// read homepage

	homePageMux = http.NewServeMux()

	homePageMux.HandleFunc("/", homePage)
	homePageMux.HandleFunc("/home", homePageInner)
	homePageMux.HandleFunc("/home/", homePageInner)
	homePageMux.HandleFunc("/static", homeStatic)

	homePageMux.HandleFunc("/ariaNg", ariang)
	homePageMux.HandleFunc("/ariaNg/", ariang)
	homePageMux.HandleFunc("/ariang", ariang)
	homePageMux.HandleFunc("/ariang/", ariang)
}

func homePage(w http.ResponseWriter, r *http.Request) {
	homepage, err := ioutil.ReadFile(rootdir + "/homepage.html")
	if err != nil {
		fmt.Println("[E] read homepage error")
	}
	_, _ = w.Write(homepage)
}

func homePageInner(w http.ResponseWriter, r *http.Request) {
	page, err := ioutil.ReadFile(rootdir + "/homepage_inner.html")
	if err != nil {
		fmt.Println("[E] read homepage_inner.html error")
	}
	_, _ = w.Write(page)
}

func homeStatic(w http.ResponseWriter, r *http.Request) {
	http.FileServer(http.Dir(rootdir))
}

// ariaNg_ModifiedByHbl.html
// http://server.lan/ariaNg
func ariang(w http.ResponseWriter, r *http.Request) {
	page, err := ioutil.ReadFile(rootdir + "/ariaNg_ModifiedByHbl.html")
	if err != nil {
		fmt.Println("[E] read homepage_inner.html error")
	}
	_, _ = w.Write(page)
}
