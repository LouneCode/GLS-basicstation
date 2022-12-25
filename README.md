# GLS Basic Station - with a fine timestamp support

Repository provides an idea how to enable (TOA) fine timestamp support with LoRa Basics™ Station v2.0.6. See details on [V2.0.6.1 Release note](https://github.com/LouneCode/GLS-basicstation/releases/tag/v2.0.6.1). 

## Basic Station
The concentrator desing is [Corecell](https://doc.sm.tc/station/gw_corecell.html) and hardware is based on the Semtech SX1303 or SX1302 chip. This concept has been tested on a Semtech SX1303 reference design board with an external EBYTE GN02 GPS module generating PPS pulse.

### LNS test environment software stack - this repository not cover details of the ChirpStack test environment configuration
- GLS basicstation (https://github.com/LouneCode/GLS-basicstation) 
- ChirpStack v4 + modified GLS ChirpStack Gateway Bridge. Chirpstack gateway bridge need some changes to work with GLS basicstation and fine timestamp configuration (a link to the GLS ChirpStack Gateway Bridge repository will be added maybe here later...)

## Documentation
See LoRa Basics™ station [documentation](https://github.com/LouneCode/GLS-basicstation/edit/master/README.md#documentation-1) and compilation instructions below.

### Cloning the GLS Basic Station Repository

``` sourceCode
git clone https://github.com/LouneCode/GLS-basicstation.git
```

### Compiling the GLS Basic Station Binary

``` sourceCode
cd GLS-basicstation
make platform=corecell variant=std
```

#### Add following Configuration files in basicstation folder to use GLS Basic Station with ChirpStack:
Set "pps" property to true in "SX1302_conf" section to enable the Fine timestamping functionality. All the following configuration files are examples only and should be reviewed and modified according to the Basic Station configuration used.
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
ws://192.168.1.130:3001
```

### Running compiled code from the command line
``` sourceCode
sudo ./build-corecell-std/bin/station
```

### If everything went well, the log will show something like this ... 
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

**Fine timestamp in the web socket message** ---> "fts":687880518 
``` sourceCode
2022-12-19 17:20:14.797 [AIO:XDEB] [3|WS] > {"msgtype":"updf","MHdr":64, --- "fts":687880518 --- ,"rssi":-45,"snr":13.75,"rxtime":1671470414.687880516}}
```

# LoRa Basics™ Station 
[![regr-tests](https://github.com/lorabasics/basicstation/actions/workflows/regr-tests.yml/badge.svg?branch=master)](https://github.com/lorabasics/basicstation/actions/workflows/regr-tests.yml?query=branch%3Amaster)

[Basic Station](https://doc.sm.tc/station) is a LoRaWAN Gateway implementation, including features like

*  **Ready for LoRaWAN Classes A, B, and C**
*  **Unified Radio Abstraction Layer supporting Concentrator Reference Designs [v1.5](https://doc.sm.tc/station/gw_v1.5.html), [v2](https://doc.sm.tc/station/gw_v2.html) and [Corecell](https://doc.sm.tc/station/gw_corecell.html)**

*  **Powerful Backend Protocols** (read [here](https://doc.sm.tc/station/tcproto.html) and [here](https://doc.sm.tc/station/cupsproto.html))
    -  Centralized update and configuration management
    -  Centralized channel-plan management
    -  Centralized time synchronization and transfer
    -  Various authentication schemes (client certificate, auth tokens)
    -  Remote interactive shell

*  **Lean Design**
    -  No external software dependencies (except mbedTLS and libloragw/-v2)
    -  Portable C code, no C++, dependent only on GNU libc
    -  Easily portable to Linux-based gateways and embedded systems
    -  No dependency on local time keeping
    -  No need for incoming connections

## Documentation

The full documentation is available at [https://doc.sm.tc/station](https://doc.sm.tc/station).

### High Level Architecture

![High Level Station Architecture](https://doc.sm.tc/station/_images/architecture.png)

## Prerequisites

Building the Station binary from source, requires

* gcc (C11 with GNU extensions)
* GNU make
* git
* bash

## First Steps

The following is a three-step quick start guide on how to build and run Station. It uses a Raspberry Pi as host platform and assumes a Concentrator Reference Design 1.5 compatible radio board connected via SPI, and assumes that SPI port is enabled using the [raspi-config](https://www.raspberrypi.org/documentation/configuration/raspi-config.md) tool. In this example the build process is done on the target platform itself (the make environment also supports cross compilation in which case the toolchain is expected in `~/toolchain-$platform` - see [setup.gmk](setup.gmk)).

#### Step 1: Cloning the Station Repository

``` sourceCode
git clone https://github.com/lorabasics/basicstation.git
```

#### Step 2: Compiling the Station Binary

``` sourceCode
cd basicstation
make platform=rpi variant=std
```

The build process consists of the following steps:

*  Fetch and build dependencies, namely [mbedTLS](https://github.com/ARMmbed/mbedtls) and [libloragw](https://github.com/Lora-net/lora_gateway)
*  Setup build environment within subdirectory `build-$platform-$variant/`
*  Compile station source files into executable `build-$platform-$variant/bin/station`

#### Step 3: Running the Example Configuration on a Raspberry Pi

``` sourceCode
cd examples/live-s2.sm.tc
RADIODEV=/dev/spidev0.0 ../../build-rpi-std/bin/station
```

**Note:** The SPI device for the radio MAY be passed as an environment variable using `RADIODEV`.

The example configuration connects to a public test server [s2.sm.tc](wss://s2.sm.tc) through which Station fetches all required credentials and a channel plan matching the region as determined from the IP address of the gateway. Provided there are active LoRa devices in proximity, received LoRa frames are printed in the log output on `stderr`.

## Instruction for Supported Platfroms

#### Corecell Platform (Raspberry Pi as HOST + [SX1302CxxxxGW Concentrator](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1302cxxxgw1))

##### Compile and Running the Example

``` sourceCode
cd basicstation
make platform=corecell variant=std
cd examples/corecell
./start-station.sh -l ./lns-ttn
```

This example configuration for Corecell connects to [The Things Network](https://www.thethingsnetwork.org/) public LNS. The example [station.conf](station.conf) file holds the required radio configurations and station fetches the channel plan from the configured LNS url ([tc.uri](tc.uri)).

Note: SPI port requires to be activated on Raspberry Pi thanks to [raspi-config](https://www.raspberrypi.org/documentation/configuration/raspi-config.md) tool.

#### PicoCell Gateway (Linux OS as HOST + [SX1308 USB Reference design](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1308p868gw))


##### Compile and Running the Example

``` sourceCode
cd basicstation
make platform=linuxpico variant=std
cd examples/live-s2.sm.tc
RADIODEV=/dev/ttyACM0 ../../build-linuxpico-std/bin/station
```

**Note:** The serial device for the PicoCell MAY be passed as an environment variable using `RADIODEV`.

## Next Steps

Next,

*  consult the help menu of Station via `station --help`,
*  inspect the `station.conf` and `cups-boot.*` [example configuration files](/examples/live-s2.sm.tc),
*  tune your local [configuration](https://doc.sm.tc/station/conf.html),
*  learn how to [compile Station](https://doc.sm.tc/station/compile.html) for your target platform.

Check out the other examples:

*  [Simulation Example](/examples/simulation) - An introduction to the simulation environment.
*  [CUPS Example](/examples/cups) - Demonstration of the CUPS protocol within the simulation environment.
*  [Station to Pkfwd Protocol Bridge Example](/examples/station2pkfwd) - Connect Basic Station to LNS supporting the legacy protocol.

## Usage

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
