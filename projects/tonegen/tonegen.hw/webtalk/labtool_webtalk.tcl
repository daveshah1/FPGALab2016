webtalk_init -webtalk_dir /home/dave/lab/projects/tonegen/tonegen.hw/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Wed Dec  7 15:49:46 2016" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "Vivado v2016.3 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "1682563" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "211198163_1777519508_210643822_826" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "727a4e91beba521f8d49f8d3f5a4848a" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "1d267d91-8911-4f5f-804e-4babfe02b92c" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "2" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "unknown" -context "user_environment"
webtalk_add_data -client project -key os_release -value "unknown" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "3702.514 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "16.000 GB" -context "user_environment"
webtalk_register_client -client labtool
webtalk_add_data -client labtool -key chain -value "" -context "labtool\\usage"
webtalk_add_data -client labtool -key pgmcnt -value "01:00:00" -context "labtool\\usage"
webtalk_add_data -client labtool -key cable -value "Digilent/Genesys 2/15000000:" -context "labtool\\usage"
webtalk_transmit -clientid 254176067 -regid "211198163_1777519508_210643822_826" -xml /home/dave/lab/projects/tonegen/tonegen.hw/webtalk/usage_statistics_ext_labtool.xml -html /home/dave/lab/projects/tonegen/tonegen.hw/webtalk/usage_statistics_ext_labtool.html -wdm /home/dave/lab/projects/tonegen/tonegen.hw/webtalk/usage_statistics_ext_labtool.wdm -intro "<H3>LABTOOL Usage Report</H3><BR>"
webtalk_terminate
