package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
)

var rootdir string
var proxyHandle map[string]http.Handler

func init() {

	var err error
	rootdir, err = filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		fmt.Println("[Err]::get root dir err::", err)
	}
	fmt.Println("[INFO] work dir :: ", rootdir)
	proxyHandle = make(map[string]http.Handler)

	initHomePage()
	initReverseServer()
}

func main() {

	//  server.lan  -->  home page :: 导航页
	//  git.server.lan --> port 3000

	http.HandleFunc("/", reverseProxy)

	startServer()

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
