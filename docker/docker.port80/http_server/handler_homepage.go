package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

var (
	homePageMux                                           *http.ServeMux
	homePage, homePageInner, ariaPage, videoPage, favicon pageX
)

type pageX struct {
	content []byte
}

func (p pageX) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write(p.content)
}

func initHomePage() {
	var err error
	homePage.content, err = ioutil.ReadFile(rootdir + "/homepage.html")
	if err != nil {
		fmt.Println("[E] read homepage error")
	}
	homePageInner.content, err = ioutil.ReadFile(rootdir + "/homepage_inner.html")
	if err != nil {
		fmt.Println("[E] read homepage_inner.html error")
	}

	// // ariaNg_ModifiedByHbl.html
	// // http://server.lan/ariaNg
	ariaPage.content, err = ioutil.ReadFile(rootdir + "/ariaNg_ModifiedByHbl.html")
	if err != nil {
		fmt.Println("[E] read ariaNg.html error")
	}

	videoPage.content, err = ioutil.ReadFile(rootdir + "/video.html")
	if err != nil {
		fmt.Println("[E] read video.html error")
	}

	favicon.content, err = ioutil.ReadFile(rootdir + "/favicon.ico")
	if err != nil {
		fmt.Println("[E] read favicon error")
	}

	homePageMux = http.NewServeMux()

	homePageMux.Handle("/", homePage)
	homePageMux.Handle("/home", homePageInner)
	homePageMux.Handle("/home/", homePageInner)
	homeStaticHandler := http.FileServer(http.Dir(rootdir))
	homePageMux.Handle("/static", homeStaticHandler)
	homePageMux.Handle("/static/", homeStaticHandler)

	homePageMux.Handle("/ariaNg", ariaPage)
	homePageMux.Handle("/ariaNg/", ariaPage)
	homePageMux.Handle("/video", videoPage)
	homePageMux.Handle("/video/", videoPage)

	homePageMux.Handle("/favicon.ico", favicon)

	proxyHandle["server.lan"] = homePageMux
}

// func homePage(w http.ResponseWriter, r *http.Request) {
// 	_, _ = w.Write(homePageHTML)
// }

// func homePageInner(w http.ResponseWriter, r *http.Request) {
// 	_, _ = w.Write(innerPageHTML)
// }

// // ariaNg_ModifiedByHbl.html
// // http://server.lan/ariaNg
// func ariang(w http.ResponseWriter, r *http.Request) {
// 	_, _ = w.Write(ariaPageHTML)
// }

// func video(w http.ResponseWriter, r *http.Request) {
// 	_, _ = w.Write(videoPageHTML)
// }

// func favicon(w http.ResponseWriter, r *http.Request) {
// 	_, _ = w.Write(icon)
// }
