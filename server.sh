sudo chmod -R u+rwX,go-rwx ~/terraria/Worlds
sudo chown -R 1001:1001 ~/terraria/Worlds

sudo docker build -t terraria-server .
sudo docker run -it \
  --read-only \
  --cap-drop=ALL \
  --security-opt no-new-privileges:true \
  --rm \
  -p 7777:7777 \
  -v ~/terraria/Worlds:/home/terraria/.local/share/Terraria/Worlds \
  --name terraria \
  terraria-server

