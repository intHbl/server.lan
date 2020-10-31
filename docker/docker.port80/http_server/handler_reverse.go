package main

func initReverseServer() {
	// redirect to  127.0.0.1:3000
	// var reverseHandler http.Handler
	// reverseHandler = NewHTTPProxy("http", "127.0.0.1:3000")

	//r.Host ==
	///"server.lan"  -> homepage

	///"git.server.lan" || r.Host == "git.lan"
	proxyHandle["git.lan"] = NewHTTPProxy("http", "127.0.0.1:3000")
	proxyHandle["git.server.lan"] = proxyHandle["git.lan"]
	///"down.server.lan"
	proxyHandle["down.server.lan"] = NewHTTPProxy("http", "127.0.0.1:6800")
	///"down.server.lan"
	proxyHandle["qbit.server.lan"] = NewHTTPProxy("http", "127.0.0.1:6810")
	///seafile ""
	proxyHandle["seafile.server.lan"] = NewHTTPProxy("http", "127.0.0.1:8000")
	proxyHandle["webdav.server.lan"] = NewHTTPProxy("http", "127.0.0.1:8080")
	//seafhttp
	proxyHandle["file.server.lan"] = NewHTTPProxy("http", "127.0.0.1:8082")
	///bitwarden    		"bitwarden.server.lan"
	proxyHandle["bitwarden.server.lan"] = NewHTTPProxy("http", "127.0.0.1:9000")
	///statics resource 	"statics.server.lan"
	proxyHandle["statics.server.lan"] = NewHTTPProxy("http", "127.0.0.1:10001")

}
