# GLS Basic Station - with the Fine timestamp support
This repository provides an **idea** how to add (TDOA) fine timestamp support on LoRa Basics™ Station v2.0.6 version. Repository presents perhaps the world's first (public) implementation of the Basic Station with a Fine timestamp ;).

Repository of the original LoRa Basics™ Station implementation can be found [here](https://github.com/lorabasics/basicstation).

Documentation about the Concentrator Corecell desing found [here](https://lora-developers.semtech.com/build/software/lora-basics/lora-basics-for-gateways/?url=gw_corecell.html).

Another very good repository on this topic is [xoseperez/basicstation](https://github.com/xoseperez/basicstation).  

&nbsp;

## GLS Basic Station
GLS Basic Station enables The Fine timestamp functionality **if** consentrator hardware basis on the Semtech **SX1303** or **SX1302** chip and Semtech Corecell Desing. Concept has been tested on a Semtech SX1303 reference design board with an external EBYTE GN02 GPS module generating PPS pulse.

 Testing has been done on [ChirpStack](https://www.chirpstack.io/) v4 LoRaWAN® Network Server + GLS ChirpStack Gateway Bridge + GLS Basic Station back end combination. GLS ChirpStack Gateway Bridge is modified version of the original [Chirpstack gateway bridge](https://www.chirpstack.io/gateway-bridge/community/source/) and it enables the fineTimeSinceGpsEpoch field in uplink event JSON messages with nanosecond precision as follows:

 &nbsp;

 ``` sourceCode
 ...
"rxInfo": [
    {
        "gatewayId": "0016c001ffxxxxxx",
        "uplinkId": 3232276575,
        "time": "2022-12-26T12:01:47.709920+00:00",
        "timeSinceGpsEpoch": "1356091325.709920s",
        "fineTimeSinceGpsEpoch": "1356091325.263021396s",
        "rssi": -45,
        "snr": 14.25,
        "location": {
            "latitude": 62.1979847889177,
            "longitude": 21.123254060745244
        },
        "context": "AAAAAAAAAAAAMgABVWHvOA==",
        "metadata": {
            "region_common_name": "EU868",
            "region_name": "eu868"
        }
    },
...
```

&nbsp;

This repository not cover details of the GLS ChirpStack test environment configuration. But anyway, the [Chirpstack gateway bridge](https://www.chirpstack.io/gateway-bridge/community/source/) needs to some code changes to work together with the GLS Basic Station implemetation. (**GLS ChirpStack Gateway Bridge** repository will be published maybe later and the link to the implementation will be added here...)

&nbsp;

## Documentation
- LoRa Basics™ station [documentation](https://github.com/lorabasics/basicstation) and compilation instructions.

- [Concentrator Corecell desing](https://lora-developers.semtech.com/build/software/lora-basics/lora-basics-for-gateways/?url=gw_corecell.html)

&nbsp;


## Cloning the GLS Basic Station repository

&nbsp;

``` sourceCode

$ git clone https://github.com/LouneCode/gls-basicstation.git

```

&nbsp;

## A) Compilling Docker image (x86_64-linux-gnu)

Go gls-basicstation folder after cloning the repository. Give following commands on command line. 

``` sourceCode

$ cd gls-basicstation
$ sudo docker build --network host --build-arg VARIANT=std --build-arg ARCH=amd64 . -t gls-basicstation:2.0.6.1.Gnu

```
&nbsp;

## B) Compilling Docker Alpine image ( aarch64-alpine-linux-musl or x86_64-alpine-linux-musl)

Use the **`aarch64-alpine-linux-musl`** arm64 architecture compilling a Docker image of the GLS Basic station for **`Raspberry Pi 4, CM4`**.  

``` sourceCode

$ cd gls-basicstation
$ sudo docker build --network host --build-arg VARIANT=std --build-arg ARCH=x86_64-alpine-linux-musl . -t gls-basicstation:2.0.6.1.Alpine -f Dockerfile-alpine

```

&nbsp;


Check images of the container after compilation phase.

``` sourceCode

$ docker images

REPOSITORY                                                TAG              IMAGE ID       CREATED              SIZE
gls-basicstation                                          2.0.6.1.Alpine   80976a8432fd   About a minute ago   15.8MB
gls-basicstation                                          2.0.6.1.Gnu      b5bf738aa277   5 minutes ago        112MB
ubuntu                                                    22.04            58db3edaf2be   2 weeks ago          77.8MB
...

```
Notice **`the size`** of the Alpine version (15.8MB).

&nbsp;

Configure and run gls-basicstation image in Docker.

``` sourceCode

$ sudo docker run -d --name=gls-basicstation --device=/dev/ttyACM0:/dev/ttyACM0 \
  --restart=unless-stopped --network=host -e TC_URI="ws://192.168.1.100:3001" \
  -e MODEL="SX1303" -e INTERFACE="USB" -e DESIGN="CORECELL" \
  -e DEVICE="/dev/ttyACM1" -e GATEWAY_EUI="E45F01FFFE1DDCAA" \
  -e TC_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1fhifq-CeXj1GMMZc......."  \
  gls-basicstation:2.0.6.1.Alpine
  
```

&nbsp;

## Environment variables of the Docker run command

&nbsp;

List of environment variables (-e VARIABLE) of Docker run command  
Only `MODEL` and `TC_KEY` are mandatory.

Variable Name | Value | Description | Default
------------ | ------------- | ------------- | -------------
**`MODEL`** | `STRING` | Concentrator model (see `Define your MODEL` section below) | `SX1303`
**`INTERFACE`** | `SPI` or `USB` | Concentrator interface | `SPI`
**`DESIGN`** | `CORECELL` | Concentrator design version | A fair guess will be done based on `MODEL` and `INTERFACE`
**`DEVICE`** | `STRING` | Where the concentrator is connected to | `/dev/spidev0.0` for SPI, `/dev/ttyACM0` for USB
**`USE_LIBGPIOD`** | `INT` | Use `libgpiod` (1) instead of default `sysfs` (0) to manage the GPIOs. The former is the recommended but not yet supported on all platforms. | 0
**`GW_RESET_GPIO`** | `INT` | GPIO number that resets (Broadcom pin number, if not defined it's calculated based on the `GW_RESET_PIN`) | 17
**`GW_POWER_EN_GPIO`** | `INT` | GPIO number that enables power (by pulling HIGH) to the concentrator (Broadcom pin number). 0 means no required. | 0
**`GW_POWER_EN_LOGIC`** | `INT` | If `GW_POWER_EN_GPIO` is not 0, the corresponding GPIO will be set to this value | 1
**`GATEWAY_EUI_NIC`** | `STRING` | Interface to use when generating the EUI | `eth0`
**`GATEWAY_EUI`** | `STRING` | Gateway EUI to use | Autogenerated from `GATEWAY_EUI_NIC` if defined, otherwise in order 
**`USE_CUPS`** | 0 or 1 | Set to 1 to force CUPS even without a CUPS_KEY variable or cups.key file | 0
**`CUPS_URI`** | `STRING` | CUPS Server to connect to | Automatically created based on `SERVER`
**`CUPS_TRUST`** | `STRING` | Certificate for the CUPS server | Precached certificate
**`CUPS_KEY`** | `STRING` | Unique gateway key used to connect to the CUPS server | Paste API key from your provider
**`TC_URI`** | `STRING` | LoRaWAN Network Server to connect to | Automatically created based on `SERVER`
**`TC_KEY`** | `STRING` | Unique gateway key used to connect to the LNS | Paste API key from your LNS

&nbsp;

> At least `MODEL` and `TC_KEY` must be defined.

> When using CUPS (setting `USE_CUPS` to 1 or defining the `CUPS_KEY` variable), LNS configuration is retrieved from the CUPS server, so you don't have to set the `TC_*` variables.

&nbsp;

### Define your MODEL & DESIGN

The model is defined depending on the version of the LoRa concentrator chip: `SX1302` or `SX1303` . You can also use the concentrator module name or even the gateway model (for RAKwireless gateways). List of possible valid values:

* Semtech chip model: SX1302, SX1303
* Concentrator modules: RAK2287, RAK5146, RAK831, WM1302
* RAK WisGate Development gateways: RAK7248, RAK7248C, RAK7271, RAK7371

&nbsp;

## Check Docker process and logs.

&nbsp;

``` sourceCode
$ docker ps
CONTAINER ID   IMAGE                      COMMAND           CREATED         STATUS         PORTS         NAMES
9599e6bfaffc   gls-basicstation:2.0.6.1   "/app/start.sh"   7 minutes ago   Up 7 minutes                 gls-basicstation

$  docker logs -f gls-basicstation

------------------------------------------------------------------
Protocol
------------------------------------------------------------------
Mode:          DYNAMIC
Protocol:      LNS
LNS Server:    ws://192.168.1.100:3001
Gateway EUI:   E45F01FFFE1DDCAA
------------------------------------------------------------------
Radio
------------------------------------------------------------------
Model:         SX1303
Concentrator:  SX1303
Design:        CORECELL
Radio Device:  /dev/ttyACM1
Interface:     USB
Reset GPIO:    0
Enable GPIO:   0
------------------------------------------------------------------
2022-12-26 14:49:11.461 [SYS:INFO] Logging     : stderr (maxsize=10000000, rotate=3)
2022-12-26 14:49:11.461 [SYS:INFO] Station Ver : 2.0.6(corecell/std) 2022-12-25 13:02:48
2022-12-26 14:49:11.461 [SYS:INFO] Package Ver : (null)
2022-12-26 14:49:11.461 [SYS:INFO] mbedTLS Ver : 2.28.0
2022-12-26 14:49:11.461 [SYS:INFO] proto EUI   : e45f:1ff:fe1d:dc57     (station.conf)
2022-12-26 14:49:11.461 [SYS:INFO] prefix EUI  : ::1    (builtin)
2022-12-26 14:49:11.461 [SYS:INFO] Station EUI : e45f:1ff:fe1d:dc57
2022-12-26 14:49:11.461 [SYS:INFO] Station home: ./     (builtin)
2022-12-26 14:49:11.461 [SYS:INFO] Station temp: /var/tmp/      (builtin)
2022-12-26 14:49:11.461 [SYS:WARN] Station in NO-CUPS mode
2022-12-26 14:49:11.662 [TCE:INFO] Starting TC engine
2022-12-26 14:49:11.662 [TCE:INFO] Connecting to INFOS: ws://192.168.1.176:3001
2022-12-26 14:49:11.690 [TCE:INFO] Infos: e45f:01ff:fe1d:dc57 e45f:01ff:fe1d:dc57 ws://192.168.1.100:3001/gateway/e45f01fffe1ddc57
2022-12-26 14:49:11.690 [AIO:DEBU] [3] ws_close reason=1000
2022-12-26 14:49:11.690 [AIO:DEBU] [3] Connection closed unexpectedly
2022-12-26 14:49:11.690 [AIO:DEBU] [3] WS connection shutdown...
2022-12-26 14:49:11.691 [TCE:VERB] Connecting to MUXS...
2022-12-26 14:49:11.707 [TCE:VERB] Connected to MUXS.
...
2022-12-26 14:49:11.723 [RAL:INFO] Fine timestamp enabled.
...
2022-12-26 14:49:11.731 [RAL:INFO] Station device: usb:/dev/ttyACM1 (PPS capture enabled)
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_com_open:88] Opening USB communication interface
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:162] INFO: Configuring TTY
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:171] INFO: Flushing TTY
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:180] INFO: Setting TTY in blocking mode
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:195] INFO: Connect to MCU
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:203] INFO: Concentrator MCU version is V01.00.00
2022-12-26 14:49:11.731 [HAL:INFO] [lgw_usb_open:210] INFO: MCU status: sys_time:237473297 temperature:26.8oC
2022-12-26 14:49:11.733 [HAL:INFO] [lgw_connect:1192] chip version is 0x12 (v1.2)
2022-12-26 14:49:13.978 [HAL:INFO] [timestamp_counter_mode:435] using precision timestamp (max_ts_metrics:32 nb_symbols:0)
2022-12-26 14:49:14.225 [RAL:INFO] Concentrator started (2s494ms)
...

```

&nbsp;

## Compilling the GLS Basic Station Binary (x86_64-linux-gnu)

Run the make command in **`basicstation`** repository.

``` sourceCode

$ git clone https://github.com/lorabasics/basicstation basicstation
$ git clone https://github.com/LouneCode/gls-basicstation.git gls-basicstation
$ cd basicstation
$ git checkout v2.0.6
$ git apply ../gls-basicstation/builder/v2.0.6.patch
$ git apply ../gls-basicstation/builder/GLS_v2.0.6.1.patch
$ make arch=amd64 platform=corecell variant=std

```
Compilled files should found in a build-corecell-std folder. Detailed compilling instructions will be found in original [Basic Station](https://github.com/lorabasics/basicstation) repository.

&nbsp;

## Configuration files
Add following Configuration files in basicstation folder before run binary. Set "pps" property to true in "SX1302_conf" section to enable the Fine timestamping functionality. All the following configuration files are examples only and should be reviewed and modified according to the Basic Station configuration used.
* station.conf
 
``` sourceCode
{
    "SX1302_conf": {
        "device": "usb:/dev/ttyACM0",
        "lorawan_public": true,
        "clksrc": 0,
        "full_duplex": false,
        "pps": true,
        "radio_0": {
            "type": "SX1250",
            "rssi_offset": -215.4,
            "rssi_tcomp": {"coeff_a": 0, "coeff_b": 0, "coeff_c": 20.41, "coeff_d": 2162.56, "coeff_e": 0},
            "tx_enable": true,
            "antenna_gain": 0,
            "tx_gain_lut":[
                {"rf_power": 12, "pa_gain": 0, "pwr_idx": 15},
                {"rf_power": 13, "pa_gain": 0, "pwr_idx": 16},
                {"rf_power": 14, "pa_gain": 0, "pwr_idx": 17},
                {"rf_power": 15, "pa_gain": 0, "pwr_idx": 19},
                {"rf_power": 16, "pa_gain": 0, "pwr_idx": 20},
                {"rf_power": 17, "pa_gain": 0, "pwr_idx": 22},
                {"rf_power": 18, "pa_gain": 1, "pwr_idx": 1},
                {"rf_power": 19, "pa_gain": 1, "pwr_idx": 2},
                {"rf_power": 20, "pa_gain": 1, "pwr_idx": 3},
                {"rf_power": 21, "pa_gain": 1, "pwr_idx": 4},
                {"rf_power": 22, "pa_gain": 1, "pwr_idx": 5},
                {"rf_power": 23, "pa_gain": 1, "pwr_idx": 6},
                {"rf_power": 24, "pa_gain": 1, "pwr_idx": 7},
                {"rf_power": 25, "pa_gain": 1, "pwr_idx": 9},
                {"rf_power": 26, "pa_gain": 1, "pwr_idx": 11},
                {"rf_power": 27, "pa_gain": 1, "pwr_idx": 14}
            ]
        },
        "radio_1": {
            "type": "SX1250",
            "rssi_offset": -215.4,
            "rssi_tcomp": {"coeff_a": 0, "coeff_b": 0, "coeff_c": 20.41, "coeff_d": 2162.56, "coeff_e": 0},
            "tx_enable": false
        }
    },
    "station_conf": {
        "routerid": "0016F001FF1F0FEE",
        "RADIO_INIT_WAIT": "5s",
        "RX_POLL_INTV": "10ms",
        "TC_TIMEOUT": "360s",
        "log_file":  "stderr",
        "log_level": "XDEBUG",
        "log_size":  10000000,
        "log_rotate":  3
    }

}
```

* tc.key
``` sourceCode
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjaGlycHN0YWNrIiwiaXNzIjoiY2hpcnBzdGFjayIsInN1YiI6Ijk0Mjg4NDA3LTFjYzUtNGViMC...
```

* tc.uri
``` sourceCode
ws://192.168.1.100:3001
```

&nbsp;

## Running compiled code from the command line
``` sourceCode
sudo ./build-corecell-std/bin/station
```

&nbsp;

The Station binary accepts the following command-line options:

```
Usage: station [OPTION...]

  -d, --daemon               First check if another process is still alive. If
                             so do nothing and exit. Otherwise fork a worker
                             process to operate the radios and network
                             protocols. If the subprocess died respawn it with
                             an appropriate back off.
  -f, --force                If a station process is already running, kill it
                             before continuing with requested operation mode.
  -h, --home=DIR             Home directory for configuration files. Default is
                             the current working directory. Overrides
                             environment STATION_DIR.
  -i, --radio-init=cmd       Program/script to run before reinitializing radio
                             hardware. By default nothing is being executed.
                             Overrides environment STATION_RADIOINIT.
  -k, --kill                 Kill a currently running station process.
  -l, --log-level=LVL|0..7   Set a log level LVL=#loglvls# or use a numeric
                             value. Overrides environment STATION_LOGLEVEL.
  -L, --log-file=FILE[,SIZE[,ROT]]
                             Write log entries to FILE. If FILE is '-' then
                             write to stderr. Optionally followed by a max file
                             SIZE and a number of rotation files. If ROT is 0
                             then keep only FILE. If ROT is 1 then keep one
                             more old log file around. Overrides environment
                             STATION_LOGFILE.
  -N, --no-tc                Do not connect to a LNS. Only run CUPS
                             functionality.
  -p, --params               Print current parameter settings.
  -t, --temp=DIR             Temp directory for frequently written files.
                             Default is /tmp. Overrides environment
                             STATION_TEMPDIR.
  -x, --eui-prefix=id6       Turn MAC address into EUI by adding this prefix.
                             If the argument has value ff:fe00:0 then the EUI
                             is formed by inserting FFFE in the middle. If
                             absent use MAC or routerid as is. Overrides
                             environment STATION_EUIPREFIX.
  -?, --help                 Give this help list
      --usage                Give a short usage message
  -v, --version              Print station version.

Mandatory or optional arguments to long options are also mandatory or optional
for any corresponding short options.
```
&nbsp;

## If everything went well, the log will show something like this ... 
``` sourceCode
---
2022-12-19 17:17:46.690 [RAL:INFO] Fine timestamp enabled.
---
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:275] Packet checksum OK (0x79)
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:311] -----------------
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:312]   modem:      9
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:313]   chan:       5
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:314]   size:       37
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:315]   crc_en:     1
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:316]   crc_err:    0
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:317]   sync_err:   0
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:318]   hdr_err:    0
---
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:319]   timing_set: 1
---
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:320]   codr:       1
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:321]   datr:       7
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:322]   num_ts:     30
2022-12-19 17:20:14.782 [HAL:XDEB] [rx_buffer_pop:324]   ts_avg:
---
2022-12-19 17:20:14.783 [HAL:XDEB] [sx1302_parse:1959] Note: LoRa packet (modem 9 chan 5)
2022-12-19 17:20:14.783 [HAL:XDEB] [sx1302_parse:1981] Payload CRC check OK (0xCC3C)
2022-12-19 17:20:14.783 [HAL:XDEB] [precision_timestamp_correction:253] FTIME ON : timestamp correction 61421
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:587] ==> timestamp_pps => 362418142
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:605] timestamp_cnt : 384430325
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:606] timestamp_pps : 362418142
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:607] diff_pps : 22012183
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:611] pkt_ftime = 22012180.733333
2022-12-19 17:20:14.785 [HAL:XDEB] [precise_timestamp_calculate:628] ==> ftime = 687880518 ns since last PPS (687880518.939069867134094)
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2283] INFO: RSSI temperature compensation:
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2284]        coeff_a: 0.000
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2285]        coeff_b: 0.000
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2286]        coeff_c: 20.410
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2287]        coeff_d: 2162.560
2022-12-19 17:20:14.785 [HAL:XDEB] [sx1302_rssi_get_temperature_offset:2288]        coeff_e: 0.000
2022-12-19 17:20:14.785 [HAL:XDEB] [lgw_receive:1320] INFO: RSSI temperature offset applied: 1.124 dB (current temperature 27.1 C)
2022-12-19 17:20:14.785 [HAL:XDEB] [lgw_receive:1323] INFO: nb pkt found:1 left:1
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:340] <----- Searching for DUPLICATEs ------
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:343]   0: tmst=146305065 SF=7 CRC_status=16 freq=868100000 chan=5
---
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:345]  ftime=687880518
---
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:425] 0 elements swapped during sorting...
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:430] --
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:433]   0: tmst=146305065 SF=7 CRC_status=16 freq=868100000 chan=5
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:435]  ftime=687880518
2022-12-19 17:20:14.785 [HAL:XDEB] [merge_packets:441]  ------------------------------------>
---
2022-12-19 17:20:14.792 [RAL:XDEB] [CRC OK] 868.100MHz 13.75/-45.3 SF7/BW125 (mod=16/dr=7/bw=4) xtick=08b8702a (146305066) 37 bytes: 401032B50080100502EF892139DAF173F4B91023FC1856702277375E797CF865FF30CFB69B
---
2022-12-19 17:20:14.792 [S2E:DEBU] Copy the fine timestamp [687880518] of the previous mirror frame before drop it.
---
2022-12-19 17:20:14.792 [S2E:DEBU] Dropped mirror frame freq=868.1MHz snr= 11.5 rssi=-45 (vs. freq=868.1MHz snr= 13.8 rssi=-45) - DR5 mic=-1682518224 (37 bytes)
2022-12-19 17:20:14.797 [S2E:VERB] RX 868.1MHz DR5 SF7/BW125 snr=13.8 rssi=-45 xtime=0xB8000008B8702A fts=687880518 - updf mhdr=40 DevAddr=00B53210 FCtrl=80 FCnt=1296 FOpts=[] 02EF8921..65FF mic=-1682518224 (37 bytes)

2022-12-19 17:20:14.797 [AIO:XDEB] [3|WS] > {"msgtype":"updf","MHdr":64,"DevAddr":11874832,"FCtrl":128,"FCnt":1296,"FOpts":"","FPort":2,"FRMPayload":"EF892139DAF173F4B91023FC1856702277375E797CF865FF","MIC":-1682518224,"RefTime":0.000000,"DR":5,"Freq":868100000,"upinfo":{"rctx":0,"xtime":51791395861065770,"gpstime":1355505632761772,"fts":687880518,"rssi":-45,"snr":13.75,"rxtime":1671470414.687880516}}
---
```
&nbsp;

**Fine timestamp in the web socket message** ---> "fts":687880518 
``` sourceCode
2022-12-19 17:20:14.797 [AIO:XDEB] [3|WS] > {"msgtype":"updf","MHdr":64, --- "fts":687880518 --- ,"rssi":-45,"snr":13.75,"rxtime":1671470414.687880516}}
```

&nbsp;

## Attribution

- This is an adaptation of the [Semtech Basics Station repository](https://github.com/lorabasics/basicstation). See the [documentation](https://doc.sm.tc/station).
- Docker image compilation scripts bases on excellent work done by [xoseperez/basicstation](https://github.com/xoseperez/basicstation)

## License

The contents of this repository (not of those repositories linked or used by this one) are under BSD 3-Clause License.

Copyright (c) 2023 LouneCode - Only husky in the village <postia.lounelle@live.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of this project nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
