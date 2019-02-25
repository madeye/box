## Intro

```bash
sudo iptables -I DOCKER-USER -p udp --dport 444:65535 ! -d 172.0.0.0/8 -j DROP
sudo iptables -I DOCKER-USER -p tcp --dport 444:65535 ! -d 172.0.0.0/8 -j DROP
docker-compose up -d
```
