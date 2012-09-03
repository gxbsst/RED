class CreateAddMailTaskMarChangeNikonPriceShipRedDays < ActiveRecord::Migration
  def self.up
    # Update AxAccount assign_to (#1001 - #1250)
    [
      ['CU 0100403','Nate'],
      ['CU 0100341','Nate'],
      ['CU 0100101','Nate'],
      ['CU 0100567','Nate'],
      ['CU 0100112','Nate'],
      ['CU 0100297','Nate'],
      ['CU 0100859','Nate'],
      ['CU 0100301','Nate'],
      ['CU 0100277','Nate'],
      ['CU 0100288','Nate'],
      ['CU 0100494','Nate'],
      ['CU 0100422','Nate'],
      ['CU 0100824','Nate'],
      ['CU 0100811','Nate'],
      ['CU 0100596','Nate'],
      ['CU 0100702','Nate'],
      ['CU 0100762','Nate'],
      ['CU 0100020','Nate'],
      ['CU 0100157','Nate'],
      ['CU 0100175','Nate'],
      ['CU 0100763','Nate'],
      ['CU 0100475','Nate'],
      ['CU 0100266','Nate'],
      ['CU 0100790','Dan'],
      ['CU 0100734','Dan'],
      ['CU 0100699','Dan'],
      ['CU 0100111','Dan'],
      ['CU 0100126','Dan'],
      ['CU 0100212','Dan'],
      ['CU 0100791','Dan'],
      ['CU 0100317','Dan'],
      ['CU 0100676','Dan'],
      ['CU 0100299','Dan'],
      ['CU 0100353','Dan'],
      ['CU 0100370','Dan'],
      ['CU 0100200','Dan'],
      ['CU 0100313','Dan'],
      ['CU 0100236','Dan'],
      ['CU 0100350','Dan'],
      ['CU 0100579','Dan'],
      ['CU 0100595','Dan'],
      ['CU 0100165','Dan'],
      ['CU 0100389','Dan'],
      ['CU 0100456','Dan'],
      ['CU 0100098','Dan'],
      ['CU 0100655','Dan'],
      ['CU 0100581','Dan'],
      ['CU 0100307','Dan'],
      ['CU 0100828','Dan'],
      ['CU 0100558','Dan'],
      ['CU 0100204','Dan'],
      ['CU 0100300','Dan'],
      ['CU 0100385','Dan'],
      ['CU 0100365','Dan'],
      ['CU 0100222','Dan'],
      ['CU 0100566','Dan'],
      ['CU 0100096','Travis'],
      ['CU 0100186','Travis'],
      ['CU 0100404','Travis'],
      ['CU 0100496','Travis'],
      ['CU 0100510','Travis'],
      ['CU 0100778','Travis'],
      ['CU 0100155','Travis'],
      ['CU 0100381','Travis'],
      ['CU 0100873','Travis'],
      ['CU 0100874','Travis'],
      ['CU 0100875','Travis'],
      ['CU 0100876','Travis'],
      ['CU 0100877','Travis'],
      ['CU 0100878','Travis'],
      ['CU 0100879','Travis'],
      ['CU 0100880','Travis'],
      ['CU 0100881','Travis'],
      ['CU 0100882','Travis'],
      ['CU 0100883','Travis'],
      ['CU 0100884','Travis'],
      ['CU 0100885','Travis'],
      ['CU 0100886','Travis'],
      ['CU 0100887','Travis'],
      ['CU 0100888','Travis'],
      ['CU 0100889','Travis'],
      ['CU 0100890','Travis'],
      ['CU 0100891','Travis'],
      ['CU 0100892','Randy'],
      ['CU 0100893','Randy'],
      ['CU 0100894','Randy'],
      ['CU 0100867','Randy'],
      ['CU 0100896','Randy'],
      ['CU 0100148','Randy'],
      ['CU 0100897','Randy'],
      ['CU 0100898','Randy'],
      ['CU 0100899','Randy'],
      ['CU 0100900','Randy'],
      ['CU 0100902','Randy'],
      ['CU 0100903','Randy'],
      ['CU 0100904','Randy'],
      ['CU 0100905','Randy'],
      ['CU 0100906','Randy'],
      ['CU 0100907','Randy'],
      ['CU 0100908','Randy'],
      ['CU 0100910','Randy'],
      ['CU 0100911','Randy'],
      ['CU 0100912','Randy'],
      ['CU 0100913','Randy'],
      ['CU 0100914','Randy'],
      ['CU 0100915','Randy'],
      ['CU 0100916','Randy'],
      ['CU 0100917','Randy'],
      ['CU 0100919','Randy'],
      ['CU 0100920','Randy'],
      ['CU 0100922','Randy'],
      ['CU 0100923','Randy'],
      ['CU 0100924','Randy'],
      ['CU 0100926','Randy'],
      ['CU 0100927','Randy'],
      ['CU 0100928','Randy'],
      ['CU 0100929','Randy'],
      ['CU 0100930','Randy'],
      ['CU 0100931','Brian'],
      ['CU 0100932','Brian'],
      ['CU 0100577','Brian'],
      ['CU 0100933','Brian'],
      ['CU 0100934','Brian'],
      ['CU 0100935','Brian'],
      ['CU 0100936','Brian'],
      ['CU 0100938','Brian'],
      ['CU 0100939','Brian'],
      ['CU 0100940','Brian'],
      ['CU 0100941','Brian'],
      ['CU 0100942','Brian'],
      ['CU 0100943','Brian'],
      ['CU 0100944','Brian'],
      ['CU 0100871','Brian'],
      ['CU 0100945','Brian'],
      ['CU 0100947','Brian'],
      ['CU 0100948','Brian'],
      ['CU 0100950','Brian'],
      ['CU 0100951','Brian'],
      ['CU 0100952','Brian'],
      ['CU 0100953','Brian'],
      ['CU 0100954','Brian'],
      ['CU 0100956','Brian'],
      ['CU 0100957','Brian'],
      ['CU 0100958','Brian'],
      ['CU 0100959','Brian'],
      ['CU 0100615','Brian'],
      ['CU 0100960','Brian'],
      ['CU 0100962','Brian'],
      ['CU 0100963','Brian'],
      ['CU 0100961','John'],
      ['CU 0100964','John'],
      ['CU 0100966','John'],
      ['CU 0100967','John'],
      ['CU 0100969','John'],
      ['CU 0100970','John'],
      ['CU 0100971','John'],
      ['CU 0100972','John'],
      ['CU 0100973','John'],
      ['CU 0100974','John'],
      ['CU 0100975','John'],
      ['CU 0100976','John'],
      ['CU 0100977','John'],
      ['CU 0100978','John'],
      ['CU 0100979','John'],
      ['CU 0100872','John'],
      ['CU 0100980','John'],
      ['CU 0100981','John'],
      ['CU 0100982','John'],
      ['CU 0100983','John'],
      ['CU 0100984','John'],
      ['CU 0100986','John'],
      ['CU 0100987','John'],
      ['CU 0100989','John'],
      ['CU 0100990','John'],
      ['CU 0100991','John'],
      ['CU 0100992','John'],
      ['CU 0100993','Hoover'],
      ['CU 0100994','Hoover'],
      ['CU 0100995','Hoover'],
      ['CU 0100996','Hoover'],
      ['CU 0100997','Hoover'],
      ['CU 0100998','Hoover'],
      ['CU 0100999','Hoover'],
      ['CU 0101000','Hoover'],
      ['CU 0101001','Hoover'],
      ['CU 0101002','Hoover'],
      ['CU 0101003','Hoover'],
      ['CU 0101004','Hoover'],
      ['CU 0101005','Hoover'],
      ['CU 0101006','Hoover'],
      ['CU 0101007','Hoover'],
      ['CU 0101008','Hoover'],
      ['CU 0101009','Hoover'],
      ['CU 0100830','Hoover'],
      ['CU 0101010','Hoover'],
      ['CU 0101011','Hoover'],
      ['CU 0101012','Hoover'],
      ['CU 0101013','Hoover'],
      ['CU 0101014','Hoover'],
      ['CU 0101015','Hoover'],
      ['CU 0101016','Hoover'],
      ['CU 0101017','Hoover'],
      ['CU 0101018','Hoover'],
      ['CU 0101019','Hoover'],
      ['CU 0101020','Hoover'],
      ['CU 0101021','Hoover'],
      ['CU 0101022','Hoover']
    ].each do |i|
      account = AxAccount.find_by_ax_account_number(i.first)
      if account
        account.update_attributes(:assign_to => i.last) if account.assign_to.blank?
      end
    end
  end

  def self.down
  end
end
