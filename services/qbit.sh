mkdir -p qbit/{config,torrents,downloads} 
sudo chmod 0777 qbit/{config,torrents,downloads} 

sudo docker run -d  \
-v  $(pwd)/qbit/config:/config \
-v $(pwd)/qbit/torrents:/torrents \
-v $(pwd)/qbit/downloads:/downloads \
-p 8080:8080 \
-p 6881:6881 \
-p 6881:6881/udp  \
wernight/qbittorrent
