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
					default:`$BB cat /sys/block/mmcblk0/queue/read_ahead_kb`,
					action:"ioset queue read_ahead_kb"
				}},
				{ SOptionList:{
					title:"I/O Scheduler",
					description:"The I/O Scheduler decides how to prioritize and handle I/O requests. More info: <a href='http://timos.me/tm/wiki/ioscheduler'>HERE</a>",
					default:`$BB echo $($UKM/actions/bracket-option \`sh $DEVICE DirIOScheduler\`)`,
					action:"ioset scheduler",
					values:[
						`sh $DEVICE IOSchedulerList`
					],
					notify:[
						{
							on:APPLY,
							do:[ REFRESH, CANCEL ],
							to:"`sh $DEVICE DirIOSchedulerTree`"
						},
						{
							on:REFRESH,
							do:REFRESH,
							to:"`sh $DEVICE DirIOSchedulerTree`"
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
			{ SPane:{
				title:"I/O Scheduler Tunables"
			}},
				{ STreeDescriptor:{
					path:"`sh $DEVICE DirIOSchedulerTree`",
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
