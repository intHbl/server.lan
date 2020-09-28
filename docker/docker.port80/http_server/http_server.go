package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
)

var rootdir string

func init() {

	var err error
	rootdir, err = filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		fmt.Println("[Err]::get root dir err::", err)
	}
	fmt.Println("[INFO] work dir :: ", rootdir)

	initHomePage()
	initGitServer()

}

func main() {

	//  server.lan  -->  home page :: 导航页
	//  git.server.lan --> port 3000

	http.HandleFunc("/", reverseProxy)

	http.ListenAndServe("0.0.0.0:80", nil)

}

func reverseProxy(w http.ResponseWriter, r *http.Request) {
	if r.Host == "server.lan" {
		homePageMux.ServeHTTP(w, r) //
	} else if r.Host == "git.server.lan" || r.Host == "git.lan" {
		gitHandler.ServeHTTP(w, r)
	}
}
