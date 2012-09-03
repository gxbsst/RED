require 'rubygems'
require "fastercsv"
require 'time'

data =<<EOF
CU 0104745,James Reed,jreed111@aol.com,3/1/09
CU 0104746,ERSKINE R. CURRY,telecomventures@aol.com,3/1/09
CU 0104747,Eduardo Scheuren,edscheuren@cinematusa.com,3/1/09
CU 0104748,Guénaël Morin,morin.guenael@uqam.ca,3/2/09
CU 0104749,steve Gordon,witkop@mac.com,3/2/09
CU 0104750,Konstatantin Boguslavskiy,kb@kbflash.com,3/2/09
CU 0104751,Zhang JianJun,tzw@dianyingren.com,3/2/09
CU 0104752,Keifer Wainright,cockykeifer@hotmail.com,3/2/09
CU 0104753,Saleh Nass,saleh@elementsbh.com,3/3/09
CU 0104754,Maggie Heilmann,maggie@mojosolo.com,3/3/09
CU 0104755,Gwen Bader,all4u422@aol.com,3/3/09
CU 0104756,keito shinada,3431ubcz@jcom.home.ne.jp,3/3/09
CU 0104757,Marcus Lopes,marcusl@red.com,3/4/09
CU 0104758,Hamid Sirat,hamids@red.com,3/4/09
CU 0104759,Tina Gharavi,tina@bridgeandtunnelproductions.com,3/4/09
CU 0104760,Michael Lohmann,Hypercow10@aol.com,3/4/09
CU 0104761,Victor Nieuwenhuijs,victor@moskitofilm.com,3/4/09
CU 0104762,Frank Schulte,frank_schulte@skynet.be,3/4/09
CU 0104763,zdravev metodi,zdanzburg@gmail.com,3/5/09
CU 0104764,Matt Brown,videomatt32@comcast.net,3/5/09
CU 0104765,Jean-Charles Myrand,jc.myrand@live.fr,3/5/09
CU 0104766,Keith Morton,km7@me.com,3/5/09
CU 0104767,mario mosner,mario@postbar.eu,3/6/09
CU 0104768,Ross Jones,ross.pvc@mac.com,3/6/09
CU 0104769,julio Borrayo,jborrayo@staffhdtv.com,3/6/09
CU 0104770,Diane Burns,diane@winncom.com,3/6/09
CU 0104771,luiz sardenberg,jkldigital@gmail.com,3/9/09
CU 0104772,James Dozier,american-helicam@comcast.net,3/6/09
CU 0104773,Peter Odio,podio@promedios.tv,3/7/09
CU 0104774,LUIGI GIORIO,HNHENT@gmail.com,3/7/09
CU 0104775,Branden Selman,reeltorealpictures@me.com,3/8/09
CU 0104776,Tanya Aby,Tanya@linnproductions.com,3/9/09
CU 0104777,Anthony Perrault,1tonyp@gmail.com,3/9/09
CU 0104778,Ralf Liess,ralf.liess@caution.de,3/10/09
CU 0104779,Nino Arsovski,niniste@gmail.com,3/10/09
CU 0104780,Lily Merritt,lily@teletec.com.tw,3/10/09
CU 0104781,Tommy Madison,tommymadison@verizon.net,3/10/09
CU 0104782,Shawn Kessler,skessler41@gmail.com,3/10/09
CU 0104783,Jaime Guerra,elmaremoto@mac.com,3/10/09
CU 0104784,Douglas Prior,zlagathor@gmail.com,3/10/09
CU 0104785,Nathan Funk,nathan@funkfactoryfilms.com,3/11/09
CU 0104786,cristian bancila,info@ro-link.ro,3/11/09
CU 0104787,roberto pinnelli,roberto.pinnelli@gmail.com,3/11/09
CU 0104788,david Salmon,Dsalmon1@nc.rr.com,3/11/09
CU 0104789,Michele Vega,michelevla@yahoo.com,3/11/09
CU 0104790,GABA IMED ILYES,Neovision@hotmail.fr,3/11/09
CU 0104791,Rita Jarosz,rijarosz@mac.com,3/11/09
CU 0104792,luis Castro,karlacastro@mac.com,3/11/09
CU 0104793,Sarah Curtis,CurtisSA.state@gmail.com,3/11/09
CU 0104794,Jamal Hammett,hull0104@gmail.com,3/11/09
CU 0104795,WONG KWOK HUNG,videotechhk@yahoo.com.hk,3/11/09
CU 0104796,Royce Rumsey,roycer924_2@mac.com,3/11/09
CU 0104797,Joe Safai,joe@qsol.com,3/12/09
CU 0104798,James Clarke,proteous@hotmail.com,3/12/09
CU 0104799,Ron Dantowitz,dantowitz@dexter.org,3/12/09
CU 0104800,Damian Greenberg,sfpgreenberg@aol.com,3/13/09
CU 0104801,Elisabetta Cartoni,elisabetta@cartoni.com,3/13/09
CU 0104802,said sidki,ssidki@gmail.com,3/13/09
CU 0104803,Brian Paris,bwparis@gmail.com,3/13/09
CU 0104804,Roberto Quintana,rsapag@giconsulting.cl,3/13/09
CU 0104805,Kurt von Seekamm,kvs@csinj.com,3/13/09
CU 0104806,John A. Clemens,streetparade@comcast.net,3/13/09
CU 0104807,Roger Roth,waterlinepictures@me.com,3/14/09
CU 0104808,tony coker,labikoko@yahoo.co.uk,3/14/09
CU 0104809,Wendell Adkins,boomstrike@aol.com,3/15/09
CU 0104810,Marcia Leite,marciale@iis.com.br,3/15/09
CU 0104811,silvio saade,silvio@silvergrey.tv,3/16/09
CU 0104812,ARMAND B FRASCO,armandfrasco@gmail.com,3/16/09
CU 0104813,Simon Temple,simon@hahfilm.com,3/16/09
CU 0104814,Daniel Lukas Abele,Niggo62@web.de,3/16/09
CU 0104815,harvey krasnegor,redhil3@msn.com,3/16/09
CU 0104816,Mary Hendriks,mary.hendriks@csun.edu,3/16/09
CU 0104817,Wesley Dodd,wesley@vividwhite.tv,3/16/09
CU 0104818,Carlos Padilla,padillacallissiani@hotmail.com,3/16/09
CU 0104819,John Dougherty,dowconst@msn.com,3/16/09
CU 0104820,Naotaka Hirota,naotaka@tetsudoshashin.com,3/17/09
CU 0104821,José María González-Sinde R,jm@sinde.net,3/17/09
CU 0104822,Li JuTao,jutao68@163.com,3/17/09
CU 0104823,Gareth Ward,gareth@overcrank.co.uk,3/17/09
CU 0104824,Sylvain Poirier,sylvain@lyca-inc.com,3/17/09
CU 0104825,michael bollacke,onlineproductions@sbcglobal.net,3/17/09
CU 0104826,Zach Mann,izacmann@gmail.com,3/17/09
CU 0104827,victor miranda(tita),geral@wokfilms.pt,3/18/09
CU 0104828,Ulf Lundén,ulf@kokokaka.com,3/18/09
CU 0104829,Mahamoud Baraka,baraka@barakamediaproduction.com,3/18/09
CU 0104830,DANIEL GARATE,sales1@ipsmiami.com,3/18/09
CU 0104831,Scott Duncan,scott@scottduncanfilms.com,3/18/09
CU 0104833,johnny parker,parker@t180.com,3/18/09
CU 0104834,marcial munoz,studio@sessionpr.com,3/19/09
CU 0104835,Stephen Loehr,stephenloehr@gmx.de,3/20/09
CU 0104836,Connor Hair,rednurse666@yahoo.com,3/20/09
CU 0104837,Steven M Nyblom,mansion1151@yahoo.com,3/20/09
CU 0104838,bb unknown last name,reepop08@yahoo.co.uk,3/21/09
CU 0104839,Josef Urban,denali@email.cz,3/21/09
CU 0104840,Erik Edlefsen,hooyah1943@inbox.com,3/21/09
CU 0104841,Cornelius McKinney,corneliusmckinney@yahoo.com,3/21/09
CU 0104842,sean lang,sean_lang@163.com,3/22/09
CU 0104843,francisco garcia romero,fgromero@escuelaces.com,3/22/09
CU 0104844,Robert Harrigal,Robert.Harrigal@gmail.com,3/23/09
CU 0104845,James K. Henley,jk449@aol.com,3/23/09
CU 0104846,Kamera Avdelingen,mai@norskfilmstudio.no,3/24/09
CU 0104847,Dmitriy Paimullin,slasher@hitv.ru,3/24/09
CU 0104848,Dino Herrmann,contact@cinehyte.com,3/24/09
CU 0104849,michael campbell,soupfactory@cox.net,3/24/09
CU 0104850,James Lewis,jslewis@comcat.com,3/24/09
CU 0104851,Milutin Jakovljevic,studio3dvideo@sbb.rs,3/25/09
CU 0104852,Radim Schreiber,radims@theskyfactory.com,3/24/09
CU 0104853,joseph al kadamani,jkadamani@gamma-engineering.com,3/25/09
CU 0104854,Vanessa Champagne,bfcrental@hotmail.com,3/25/09
CU 0104855,Stephen Moore,stephenmoore624@mac.com,3/25/09
CU 0104857,Konrad Widelski,konradwidelski@pandora.be,3/25/09
CU 0104858,Birgit Buhleier,camculture@aol.com,3/25/09
CU 0104859,Alfonso Diaz,alfonso@vfxpanama.com,3/26/09
CU 0104860,Prasen Bose,prasen@samysdv.com,3/27/09
CU 0104861,Joost Kelderman,joost@invite-av.nl,3/30/09
CU 0104862,Jon Bingham,bjonb78@gmail.com,3/30/09
CU 0104863,Evert Cloo,evert.cloo@gmail.com,3/30/09
CU 0104864,Michael Tsimperopoulos,contact@tsimperopoulos.com,3/30/09
CU 0104865,Gevorg Sarkisian,juguryan@gmail.com,3/30/09
CU 0104866,Emyr R. E. Pugh,info@linguamongolia.co.uk,3/30/09
CU 0104867,jonas pinho,pinhojonas@hotmail.com,3/30/09
CU 0104868,Gerald Albitre,GPAlbitre@gmail.com,3/30/09
CU 0104869,Reidulf Botn,rb@hivolda.no,3/30/09
CU 0104870,Maxime MICHAUD,michaudmaxime@yahoo.fr,3/30/09
CU 0104871,David Ruck,david.ruck@gmail.com,3/30/09
CU 0104872,paul dudeck,pdudeck@antonbauer.com,3/30/09
CU 0104873,Louis Ortego,louortego@verizon.net,3/30/09
CU 0104874,Jason Buckley,jasonabuckley@gmail.com,3/30/09
CU 0104875,Scott Michelson,scott@hydraulx.com,3/31/09
CU 0104876,Donald T. Houston CEO,vision3dllc@yahoo.com,3/31/09
CU 0104877,Johnny  Sousa,sowza1@gmail.com,3/31/09
CU 0104878,Scott Stansfield,sstansfield49@yahoo.com,3/31/09
CU 0104879,ayman wahby,aymanwahby@afilmproduction.com,4/1/09
CU 0104880,Arno Schubert,arno.schubert@thomson.net,4/1/09
CU 0104881,Chris Fanning,chris@4webcast.com,4/1/09
CU 0104882,Xackery Irving,xackery@hotmail.com,4/1/09
CU 0104883,Swonson Highmen,Travis@red.com,4/1/09
CU 0104884,ZhangLin,zlinwork@163.com,4/2/09
CU 0104885,patrick mcgee,pmcgee@ion.co.za,4/2/09
CU 0104886,Len Gowing,len@53north.tv,4/2/09
CU 0104887,Tamás Lőrinczy,pegazusfilm@gmail.com,4/3/09
CU 0104888,chris witzke,info@witzke-studio.com,4/3/09
CU 0104889,francis disla f,indiocine@hotmail.com,4/3/09
CU 0104890,Vladimir Rodin,rodin@jcsi.biz,4/3/09
CU 0104891,BOUCHAIBI Mohamed,bouchaibima@yahoo.fr,4/5/09
CU 0104892,Kelly Fanning,KellyK31981@yahoo.com,4/6/09
CU 0104893,Steve Kalalian,Santiago@industrialcolor.com,4/6/09
CU 0104894,Timothy Burton,burtonpictures@msn.com,4/6/09
CU 0104895,Ben Drickey,torchwerk@gmail.com,4/6/09
CU 0104896,Caleb Ply,calebply@gmail.com,4/6/09
CU 0104897,Andy Attenhofer,aattenhofer@chispa-productions.com,4/7/09
CU 0104898,Nancy Bruyninx,nancy.bruyninx@nbcuni.com,4/7/09
CU 0104899,Jeff Wilson,jwilson@echobaymedia.com,4/7/09
CU 0104900,Marco Naylor,tripleecho@aol.com,4/7/09
CU 0104901,Sebastian Sorin,sebisorin@hotmail.com,4/7/09
CU 0104902,Jaesu Jeong,greensa@korea.com,4/7/09
CU 0104903,Jeff Turner,skyfilms@xplornet.com,4/8/09
CU 0104904,Melissa Farr,melissa.m.farr@gmail.com,4/8/09
CU 0104905,Elliot Leboe,elliot@aclproductions.com,4/8/09
CU 0104906,Keir Yee,keiryee@comcast.net,4/9/09
CU 0104907,Robert Kuns,rkuns@mac.com,4/9/09
CU 0104908,Marker Karahadian,marker_karahadian@panavision.com,4/9/09
CU 0104909,Michael Owens,michael@jmichaelowens.com,4/9/09
CU 0104910,Mario Maronati,info@cinerent.it,4/10/09
CU 0104911,Alex Fernbach,anthony@pawsco.tv,4/10/09
CU 0104912,Masayuki Itakura,mitakura@nifty.com,4/10/09
CU 0104913,Michael Seminerio,seminerm@pbcc.edu,4/10/09
CU 0104914,Ryan Baker,ryanbaker@blackarts.net,4/11/09
CU 0104915,Chris Landers,elmobarlow@gmail.com,4/11/09
CU 0104916,michael cano,michaelcano3@hotmail.com,4/12/09
CU 0104917,Ken Krawczyk,antonfilms@hotmail.com,4/13/09
CU 0104918,Michael Seminerio,seminerm@pbcc.edu,4/13/09
CU 0104919,William Walter,billwalter@mac.com,4/13/09
CU 0200000,Raul Marquez,raulm@red.com,3/25/09
EOF

data = FasterCSV.parse( data )
exist_store_users = []
create_store_users = []
#Update the orders to the table order
data.each do |store_user|
  erp_account_number	= store_user[0]
  name								= store_user[1]
  email_address				= store_user[2]
  password = rand(999999999999)
  # erp_modstamp= Time.parse("#{ order[4]}" "#{ order[5]}")
  created_on = Time.parse(store_user[3])
  if created_on >= Time.parse("4/5/09") and created_on <= Time.parse("4/13/09")
  
  if store_user = StoreUser.find_by_email_address( email_address )
    if store_user.erp_account_number.blank?
      store_user.update_attribute("erp_account_number", erp_account_number)
    end
    exist_store_users << "#{email_address} \n"
  else
    create_store_users << "#{erp_account_number}\t #{name}\t #{email_address}\t #{password} \n"
    store_user = 	StoreUser.new( :erp_account_number => erp_account_number, :name => name, :email_address => downcase(email_address), :password => password ) 
    store_user.save
  end
end #end for if created_on.....
end
#将数据放到文件
open("create_store_users","w") do |file|
  create_store_users.each do |user|
    file << user
  end
end

open("exist_store_users","w") do |file|
  exist_store_users.each do |user|
    file << user
  end
end