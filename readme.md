This sort of example builds nginx deb package from source (with ngx_http_stub_status_module) in one image  
And then run it in another image (because we don't want building tools in our image)  
This approach called "multi-stage build" and helped save ~300MB space (from ~500 to ~150)  
  
1) This image contains compiled nginx (with stub module and custom default nginx.conf),  
official nginx .deb package, and re-packed (with previously compiled) custom .deb package.  
Also containing all compilation and deb-packing stuff, needed for these actions.  
Build1:  
`docker build -f Dockerfile.intermediate -t nginx-docker-intermediate .`  
  
2) This image contains all, that contains 'intermediate' image,  
but with nginx installed from re-packed .deb package.  Also nginx running.  
Build2:  
`docker build -f Dockerfile.big -t nginx-docker-big .`  
Run2:  
`docker run --name nginx-docker-big -p 80:80 --rm nginx-docker-big`   
Test2:  
`curl 127.0.0.1/status`  
  
3) This image contains only re-packed .deb package,  
with nginx installed from this package,  
also nginx running.  
Build3:  
`docker build -f Dockerfile.small -t nginx-docker-small .`  
Run3:  
`docker run --name nginx-docker-small -p 80:80 --rm nginx-docker-small`  
Test3:  
`curl 127.0.0.1/status`  
  
After all images built and tested, you can compare their sizes by:  
`docker image ls`  
difference is impressive.  
