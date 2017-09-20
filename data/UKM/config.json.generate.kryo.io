cat << CTAG
{
	name:I/O,
		elements:[
			{ STitleBar:{
				title:"I/O Control"
			}},
				{ SSeekBar:{
					title:"Read-ahead Size",
					description:"Set the read-ahead size for the internal storage.",
					unit:" KB",
					step:128,
					min:128,
					max:4096,
					default:`$BB cat /sys/block/sda/queue/read_ahead_kb`,
					action:"iosetkryo queue read_ahead_kb"
				}},
				{ SOptionList:{
					title:"I/O Scheduler",
					description:"The I/O Scheduler decides how to prioritize and handle I/O requests. More info: <a href='http://timos.me/tm/wiki/ioscheduler'>HERE</a>",
					default:`$BB echo $($UKM/actions/bracket-option \`sh $DEVICE DirKRYOIOScheduler\`)`,
					action:"iosetkryo scheduler",
					values:[
						`sh $DEVICE KRYOIOSchedulerList`
					],
					notify:[
						{
							on:APPLY,
							do:[ REFRESH, CANCEL ],
							to:"`sh $DEVICE DirKRYOIOSchedulerTree`"
						},
						{
							on:REFRESH,
							do:REFRESH,
							to:"`sh $DEVICE DirKRYOIOSchedulerTree`"
						}
					]
				}},
				`if [ -f "/sys/module/mmc_core/parameters/use_spi_crc" ]; then
				CRCS=\`bool /sys/module/mmc_core/parameters/use_spi_crc\`
					$BB echo '{ SPane:{
						title:"Software CRC control"
					}},
						{ SCheckBox:{
							label:"Software CRC control",
							description:"Enabling software CRCs on the data blocks can be a significant (30%) performance cost. So we allow it to be disabled.",
							default:'$CRCS',
							action:"boolean /sys/module/mmc_core/parameters/use_spi_crc"
						}},'
				fi`
				`if [ -f "/sys/devices/soc.0/f9824900.sdhci/mmc_host/mmc0/clk_scaling/scale_down_in_low_wr_load" ]; then
				MMCC=\`$BB cat /sys/devices/soc.0/f9824900.sdhci/mmc_host/mmc0/clk_scaling/scale_down_in_low_wr_load\`
				$BB echo '{ SPane:{
					title:"Memory Card Clock Scaling Control"
				}},
					{ SCheckBox:{
						label:"MMC Clock Scaling Control",
						description:"Optimize clock scaling during write requests. The default value for it is 0. In case we want to gain performance over power they should set it to 1.",
						default:'$MMCC',
						action:"generic /sys/devices/soc.0/f9824900.sdhci/mmc_host/mmc0/clk_scaling/scale_down_in_low_wr_load"
					}},'
				fi`
			{ SPane:{
				title:"I/O Scheduler Tunables"
			}},
				{ STreeDescriptor:{
					path:"`sh $DEVICE DirKRYOIOSchedulerTree`",
					generic: {
						directory: {},
						element: {
							SGeneric: { title:"@BASENAME" }
						}
					},
					exclude: [ "weights" ]
				}},
		]
}
CTAG
