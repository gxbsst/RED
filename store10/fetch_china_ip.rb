# Ip2address.find_all_by_countrySHORT
# Ip2address.find(:all, :conditions => ["countrySHORT IN (?)", "CN HK"], :limit => 10)

china_ip =  Ip2address.find( :all, :conditions => ["countrySHORT IN (?)", ["HK", "CN", "TW", "MO"]])
china_ip.each do	|item| 
	unless Ip2addressForChina.find_by_ipTO(item.ipTO)
		@ipforchina = Ip2addressForChina.new()
		@ipforchina.ipFROM = item.ipFROM
		@ipforchina.ipTO = item.ipTO
		@ipforchina.countrySHORT = item.countrySHORT
		@ipforchina.countryLONG = item.countryLONG
		@ipforchina.ipREGION = item.ipREGION
		@ipforchina.ipCITY = item.ipCITY
		@ipforchina.save!
	end
end



	