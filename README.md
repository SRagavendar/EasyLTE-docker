# EasyLTE-docker
Docker-based LTE environement featuring NextEPC as MME, SGW and PGW, and srsLTE using the FauxRF (or srsLTE with ZMQ fake device) patch to simulate a UE and an eNB. Also provided, alternate docker-compose files for all-in-one EPC kind of node, zmq TCP pseudo radio, etc.


## architecture

```
                                                  ┌───────────────┐   ┌───────────────┐                           ┌───────────────┐       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  │  MongoDB      │   │  NextEPC HSS  │                           │  NextEPC PCRF │       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  │               │   │               │                           │               │       
                                                  └─┬─────────────┘   └────┬──────────┘                           └────┬──────────┘       
             ┌──────────────────┐                   │                      │                                           │                  
             │shared memory IPC │                   │                      │                                           │                  
┌────────────┴──┬─────────┬─────┴─────────┐         │   ┌───────────────┐  │┌───────────────┐   ┌───────────────┐      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│  srsUE        │         │  srseNB       ├─────────┼───▶  NextEPC MME  ├──┼▶  NextEPC SGW  │   │  NextEPC PGW  │      │                  
│               │         │               │         │   │               │  ││               │   │               │      │                  
│               │         │               │         │   │               │  ││               ├───▶   TUN+NAT     │      │                  
│      ■━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━╋━━━╋━━━━━━━━━━━━━━━╋━━╋╋━━━━━━━━━━━━━━━╋━━━╋━━━━━━■        │      │                  
└───────────────┘         └──────┬────────┘         │   └───────┬───────┘  │└───────┬───────┘   └────────┬──────┘      │                  
                                 │                  │           │          │        │                    │             │                  
                                 │                  │           │          │        │                    │             │                  
                                 │                  │           │          │        │                    │             │                  
                        ─────────▼──────────────────▼───────────▼──────────▼────────▼────────────────────▼─────────────▼─────────────────▶
                        192.168.26.0/24                                                                                                   
```

## setup 

```
docker-compose -f docker-compose-fauxrf.yml build --no-cache
```

## running

We just need to run the docker-compose:
```
docker-compose -f docker-compose-fauxrf.yml up -d
```

The following service should be running:
```
docker-compose -f docker-compose-fauxrf.yml ps
 Name                Command               State           Ports
-------------------------------------------------------------------------
enb       stdbuf -o L srsenb /config ...   Up
hss       /bin/sh /etc/nextepc/run_h ...   Up
mme       /bin/sh /etc/nextepc/run_m ...   Up
mongodb   docker-entrypoint.sh mongod      Up      27017/tcp
pcrf      /bin/sh /etc/nextepc/run_p ...   Up
pgw       /bin/sh /etc/nextepc/run_p ...   Up
sgw       /bin/sh /etc/nextepc/run_s ...   Up
ue        stdbuf -o L srsue /config/ ...   Up
webui     npm run start --prefix /ne ...   Up      0.0.0.0:3000->3000/tcp
```