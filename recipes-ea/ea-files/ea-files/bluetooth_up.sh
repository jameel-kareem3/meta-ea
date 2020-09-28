#!/bin/sh

VERSION="1.0"

function usage() {
  echo ""
  echo "Version: $VERSION"
  echo ""
  echo "Usage:"
  echo "  $0"
  echo ""
}

function get_uart() {
  model=$(tr -d '\0' </proc/device-tree/model)
  if [[ $model == *'i.MX6 DualLite'* ]]; then
    echo /dev/ttymxc4
  elif [[ $model == *'i.MX6 UltraLite'* ]]; then
    echo /dev/ttymxc1
  elif [[ $model == *'i.MX6 SoloX'* ]]; then
    echo /dev/ttymxc1
  elif [[ $model == *'i.MX6 Quad'* ]]; then
    echo /dev/ttymxc4
  elif [[ $model == *'i.MX7 Dual COM'* ]]; then
    echo /dev/ttymxc1
  elif [[ $model == *'iMX7 Dual uCOM'* ]]; then
    echo /dev/ttymxc1
  elif [[ $model == *'i.MX7ULP'* ]]; then
    echo /dev/ttyLP2
  elif [[ $model == *'i.MX8MM'* ]]; then
    echo /dev/ttymxc0
  elif [[ $model == *'i.MX8M Nano'* ]]; then
    echo /dev/ttymxc0
  elif [[ $model == *'i.MX8MQ'* ]]; then
    echo /dev/ttymxc1
  else
    echo "Unknown model"
    exit 2
  fi
}

if [[ $# -ne 0 ]]; then
  current
  usage
  exit 1
fi

btuart=$(get_uart)
module=1mw

case $module in
  1mw|1MW|1dx|1DX|1lv|1LV|1cx|1CX|cyw-sdio|CYW-SDIO|cyw-pcie|CYW-PCIE)
    hciattach $btuart bcm43xx 3000000 flow
    hciconfig hci0 up
    hciconfig hci0 piscan
    hcitool scan
    echo ""
    echo "To run a scan again, use hcitool scan"
    echo ""
    ;;
  1zm|1ZM|1ym|1YM)
    hciattach $btuart any 115200 flow
    hciconfig hci0 up
    hcitool -i hci0 cmd 0x3f 0x0009 0xc0 0xc6 0x2d 0x00
    killall hciattach
    hciattach $btuart any -s 3000000 3000000 flow
    hciconfig hci0 up
    hciconfig hci0 piscan
    hciconfig hci0 noencrypt
    hcitool scan
    echo ""
    echo "To run a scan again, use hcitool scan"
    echo ""
    ;;
  *)
    usage
    ;;
esac

