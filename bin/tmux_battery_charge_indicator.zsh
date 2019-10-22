#!/bin/zsh

battery_info=`ioreg -rc AppleSmartBattery`
current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
charge_status=$(echo "(($current_charge/$total_charge)*100)+1" | bc -l | cut -d '.' -f 1)

if [[ $charge_status -lt 20 ]]; then
  echo -n '#[fg=red]'
fi

if [[ $charge_status == '' ]]; then
  echo -n 'A/C#[fg=yellow]'
else
  echo -n "$charge_status%"
fi
