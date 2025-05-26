# Simple Terraria Dedicated Server (Dockerized)

This repository provides a simple, containerized setup to run a **Terraria** dedicated server using Docker.  
It's designed to be secure, lightweight, and easy to use for hosting a private world.

## Features

- Docker-based: no clutter or dependency installation on your host
- Secure configuration (read-only container, dropped capabilities)
- Automatically starts your world with predefined settings
- Health checks for container monitoring

---

## Getting Started

### 📦 Prerequisites

- Docker installed on your system
- A `.wld` Terraria world file (created via the game or transferred from another server)
- TCP port 7777 must be open:
  - Open port 7777 in your firewall or security group
  - Set up port forwarding if hosting from home
  - Ensure no other service is using the port
  - Terraria uses TCP port 7777 for multiplayer connections by default

---

## 🔧 Setup

1. **Clone this repository**

```bash
git clone git@github.com:chelyabinsk/terraria-server.git
cd terraria-server
```

2. **Make the launch script executable**
```bash
chmod +x server.sh
```

3. **Prepare your world file**
Place your world file in the following path: `terraria-server/Worlds/someworld.wld`
> Make sure the file name matches the one set in `serverconfig.txt`.

4. **Build and run the Docker container**
```bash
./server.sh
```
> This script builds the Docker image and starts the server in a secure container.

## ⚙️ Configuration

Edit `serverconfig.txt` to customize your server settings:
```ini
world=/home/terraria/.local/share/Terraria/Worlds/someworld.wld
difficulty=0
port=7777
maxplayers=2
password=somesecurepassword
```

- `difficulty`: 0 (Normal), 1 (Expert), 2 (Master), 3 (Journey)
- `maxplayers`: Maximum number of players allowed
- `password`: Password required to join the server

More options are described in the [official wiki](https://terraria.fandom.com/wiki/Server#Server_config_file).

## 🌍 No World? No Problem.

If you don't already have a .wld world file, you can generate one using the built-in Terraria server interface.

### Let the Server Generate a World Interactively
1. Comment out or remove the world=... line in serverconfig.txt, like so:
```init
# world=/home/terraria/.local/share/Terraria/Worlds/someworld.wld
```

2. Start the container manually:
```bash
docker run -it \
  --read-only \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --security-opt no-new-privileges:true \
  -p 7777:7777 \
  -v ~/terraria-server/Worlds:/home/terraria/.local/share/Terraria/Worlds \
  --name terraria \
  terraria-server
```

3. The server will launch in interactive mode, prompting you to:

- Select world size (Small, Medium, Large)
- Choose a world name
- Pick difficulty (Normal/Expert/Master/Journey)
- The world will be saved to the `Worlds/` directory.

4. Once the world is created, copy the resulting filename into `serverconfig.txt`:
```ini
world=/home/terraria/.local/share/Terraria/Worlds/<your-new-world>.wld
```

5. Restart the server using `./server.sh` for future runs.

## 🔒 Security

This container runs with the following security best practices:

- `--read-only` filesystem
- Drops all capabilities except NET_BIND_SERVICE
- No new privileges (--security-opt no-new-privileges:true)
- Runs as a non-root user (terraria)

## 🐳 Docker Details

### Build manually
```bash
docker build -t terraria-server .
```
> Your world data is stored in ~/terraria-server/Worlds on the host, mapped to the container’s Terraria world path.

### Run manually
```bash
docker run -it \
  --read-only \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --security-opt no-new-privileges:true \
  --rm \
  -p 7777:7777 \
  -v ~/terraria-server/Worlds:/home/terraria/.local/share/Terraria/Worlds \
  --name terraria \
  terraria-server
```

## 🧪 Health Check

The Docker container includes a health check to ensure the Terraria server process is running. You can integrate this with container orchestration or monitoring tools for improved reliability.

## 📝 License

This project is open-source and provided under the [MIT License](https://mit-license.org/).
Terraria is a trademark of Re-Logic. You must own a valid copy of Terraria to use the server files.

## 🙋 Support

For questions, suggestions, or contributions, feel free to open an issue or pull request.
