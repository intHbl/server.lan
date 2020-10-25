
# arch
arm
x86_64

# cmd
/opt/seafile

docker build -t test/seafile -f  x86_64.Dockerfile .

docker run -it -p 8000:8000 -p 8080:8080 -p 8082:8082 test/seafile


# url
http://localhost:8000/
http://localhost:8080/

