This sort of example builds nginx deb package from source (with ngx_http_stub_status_module) in one image
And then run it in another image (because we don't want building tools in our image)
This approach called "multi-stage build" and helped save ~300MB space (from ~500 to ~150)

Build:
docker build . -t nginx-docker

Run:
docker run -d -p 80:80 nginx-docker

Test:
curl 127.0.0.1/status 
