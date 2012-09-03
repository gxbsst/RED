require 'rubygems'
require 'fastercsv'

csv = FasterCSV.read('all.csv')

new = []
ext = []
csv.each do |row|
  ## 判断这个客人有没有被分配过
  cust = new.find{|i|i[1] == row[1]}
  if cust # 客人已经被分配过
    # 如果客人是被分配给同一个人则跳过
    #if cust[3] == row[3]
      next
    else
      ## 判断这个重复分配的客人是否已经在ext中记录
      #ext_cust = ext.find{|i|i[1] == cust[1]}
      #if ext_cust #在ext表中重复
      ## 检查是否与重复表中记录相同
      #if ext_cust[2].split(",").include?(row[2])
      #ext_cust[0] << ", #{row[0]}"
      #next
      #else
      #ext_cust[0] << ", #{row[0]}"
      #ext_cust[2] << ", #{row[2]}"
      #end
      #else
      ## 将重复分配的客人加入ext,添加新的字段记录原始的staff
      #ext << row.concat([cust[2]])
      #end
      #end
      #else
      new << row # apply assing customer
    #end
  end
end

#FasterCSV.open('new.csv', 'w') {|csv| new.each {|i| csv << i} }
#FasterCSV.open('ext.csv', 'w') {|csv| ext.each {|i| csv << i} }

open('new_array', 'w') do |file|
  new.each do |r|
    file << "['#{r[0]}', '#{r[1]}', '#{r[2]}', '#{r[3]}'],\n"
  end
end
