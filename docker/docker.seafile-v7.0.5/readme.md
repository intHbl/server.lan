
# arch
arm
x86_64



init data  


```
sudo tar -C data.seafile/  -zcvf seafile.init_data.3.0.tar.gz  .
	v2.x   --> http
	v3.0   --> https://seafile.server.lan https://file.server.lan
```

# cmd

/opt/seafile

docker build -t test/seafile -f  x86_64.Dockerfile .

docker run -it -p 8000:8000 -p 8080:8080 -p 8082:8082 test/seafile


# url
http://localhost:8000/
http://localhost:8080/

