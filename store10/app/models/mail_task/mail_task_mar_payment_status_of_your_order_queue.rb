class MailTaskMarPaymentStatusOfYourOrderQueue < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task
  
  class << self
    def init_queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      
      [
        ["SO 0003342","2007-08-07","CU 0101761","an0n0email@yahoo.com","Company","2149",2025.00,0.00,2025.00],
        ["SO 0003351","2007-08-09","CU 0101766","paolopisacane@yahoo.com","paolo pisacane","2153",1750.00,0.00,1750.00],
        ["SO 0003355","2007-08-10","CU 0101768","ivo.tsvetkov@gmail.com","NGP","2155",7229.50,0.00,7229.50],
        ["SO 0003363","2007-08-12","CU 0101773","obi.nnaya@nayatronix.com","DDD Entertainment","2159",2025.00,0.00,2025.00],
        ["SO 0003369","2007-08-13","CU 0101777","rich@sentinel-entertainment.co.za","Sentinel Entertainment","2163",2420.00,0.00,2420.00],
        ["SO 0003364","2007-08-13","CU 0101774","binmejren@yahoo.com","Mejren Enterprises","2160",4257.00,0.00,4257.00],
        ["SO 0003365","2007-08-13","CU 0101775","sales@grapplestudios.lt","Grapple Studios","2161",6804.50,0.00,6804.50],
        ["SO 0003375","2007-08-14","CU 0101780","yingwang@jebsen.com","","2167",2737.00,0.00,2737.00],
        ["SO 0003380","2007-08-14","CU 0101784","korbic@gmail.com","korbic","2171",2754.80,0.00,2754.80],
        ["SO 0003378","2007-08-14","CU 0101782","info@jmpictures.nl","","2169",3375.00,0.00,3375.00],
        ["SO 0003389","2007-08-16","CU 0101789","rjlocking@hotmail.com","http://goldeneye.com/golden-7.htm","2176",1750.00,0.00,1750.00],
        ["SO 0003392","2007-08-16","CU 0101791","abcwahid@hotmail.com","New Line Indie","2178",2755.00,0.00,2755.00],
        ["SO 0003395","2007-08-17","CU 0101794","andrej@vpk.si","VPK","2181",2025.00,0.00,2025.00],
        ["SO 0003396","2007-08-17","CU 0101795","takhmaz@yahoo.co.uk","ZZ","2182",8629.50,0.00,8629.50],
        ["SO 0003404","2007-08-18","CU 0101800","aaron@breslaw.net","freelance","2188",2555.00,0.00,2555.00],
        ["SO 0003407","2007-08-18","CU 0101802","banditsfilms@gmail.com","bandits films","2190",2867.00,0.00,2867.00],
        ["SO 0003411","2007-08-20","CU 0101805","chris@skyviewfilms.com","Skyview Films","",2547.50,135.00,2412.50],
        ["SO 0003421","2007-08-21","CU 0101812","reserve_mail2@hotmail.com","None","2201",1750.00,0.00,1750.00],
        ["SO 0003420","2007-08-21","CU 0101811","oz@youngturk.biz","2nd floor productions limited","2200",2025.00,0.00,2025.00],
        ["SO 0003429","2007-08-22","CU 0101817","jbarajas@iteso.mx","Fomento Cultural","2206",1750.00,0.00,1750.00],
        ["SO 0003430","2007-08-23","CU 0101818","danny@broadcast.co.il","broadcast Israel","2207",5664.50,4756.00,908.50],
        ["SO 0003439","2007-08-23","CU 0101822","ryan@red.com","Shaw Studios","2210, 2211, 2212, 2213, 2214",23715.00,4320.00,19395.00],
        ["SO 0003453","2007-08-25","CU 0101829","midocean@comcast.net","akula Films","2226",1750.00,0.00,1750.00],
        ["SO 0003450","2007-08-25","CU 0101827","ramiszaki@gmail.com","Arascope","2224",4942.00,0.00,4942.00],
        ["SO 0003472","2007-08-28","CU 0101846","contact@onefish.it","onefish","2239",2310.00,0.00,2310.00],
        ["SO 0003476","2007-08-28","CU 0101849","senol@thisismint.be","fiction factory","2241",3387.00,0.00,3387.00],
        ["SO 0003487","2007-08-28","CU 0101855","jens@motionart.net","Motionart Films, Ltd.","2247",8139.50,0.00,8139.50],
        ["SO 0003478","2007-08-28","CU 0101850","maximovster@gmail.com","SMAX STUDIO PRO","2243",8474.50,0.00,8474.50],
        ["SO 0003496","2007-08-29","CU 0101860","janez.kovic@arkadena.si","Studio Arkadena","2255",3802.00,0.00,3802.00],
        ["SO 0003507","2007-08-31","CU 0101867","davidmendes@mariodaniel.com","Ideias com Pernas","2264",3080.00,0.00,3080.00],
        ["SO 0003546","2007-09-02","CU 0101881","anychina@hotmail.com","Deseam Research Lab.","2283",7980.88,0.00,7980.88],
        ["SO 0003557","2007-09-03","CU 0101889","jtrapero@visionuno.com","Cineassist","2292",3802.00,0.00,3802.00],
        ["SO 0003559","2007-09-03","CU 0101891","estudiosradi@prodigy.net.mx","estudios radi","2294",7174.50,0.00,7174.50],
        ["SO 0003566","2007-09-04","CU 0101898","victorholl@gmail.com","Victor Holl","2301",2555.00,0.00,2555.00],
        ["SO 0003571","2007-09-04","CU 0100802","tom@fletch.com","Fletcher ChiCAgo, Inc,","2306, 2307, 2308, 2309, 2310",15422.42,7420.32,8002.10],
        ["SO 0003600","2007-09-05","CU 0101725","Goldenadam@gmail.com","flower of Life Films","2335",3700.00,0.00,3700.00],
        ["SO 0003608","2007-09-06","CU 0101924","info@cineplanet.tv","Cineplanet","2340",4622.00,0.00,4622.00],
        ["SO 0003630","2007-09-07","CU 0101937","juguryan@excite.com","films","2356",1750.00,0.00,1750.00],
        ["SO 0003631","2007-09-07","CU 0100864","ryan@red.com","","2357",1800.00,2.50,1797.50],
        ["SO 0003642","2007-09-07","CU 0101944","tsepelikas@yahoo.com","argyris tsepelikas","2367",3785.00,0.00,3785.00],
        ["SO 0003639","2007-09-07","CU 0101942","boris@bayram.uz","BAYRAM-FILM","2364",4435.00,0.00,4435.00],
        ["SO 0003703","2007-09-11","CU 0101979","raffi@platformstudios.com","Platform Studios","2415",2630.00,0.00,2630.00],
        ["SO 0003751","2007-09-16","CU 0102007","lidija.kurucki@magicbox.co.yu","magicboxmultimedia","2440",4021.00,0.00,4021.00],
        ["SO 0003839","2007-09-24","CU 0102039","sanjin@creative247.ba","creative 24/7","2465",3416.00,0.00,3416.00],
        ["SO 0003859","2007-09-24","CU 0102050","gsd@otenet.gr","DOLPHINS PRODUCTIONS","2478",5051.50,0.00,5051.50],
        ["SO 0003865","2007-09-25","CU 0102054","polyakov@irecords.ru","iRecords Ltd.","2486",2310.00,0.00,2310.00],
        ["SO 0003909","2007-09-28","CU 0100005","testaccount@red.com","Red.Com, Inc.","2536",2890.00,0.00,2890.00],
        ["SO 0003905","2007-09-28","CU 0102078","miguel.mesas@mac.com","Digital Kore","2534",4570.10,0.00,4570.10],
        ["SO 0003939","2007-10-03","CU 0102100","aron@colorfront.com","Colorfront","2561",4017.50,0.00,4017.50],
        ["SO 0003955","2007-10-04","CU 0102112","umeshshirupalli@gmail.com","sound of music","2572",4775.00,0.00,4775.00],
        ["SO 0003985","2007-10-06","CU 0102128","jnewton@calibracorp.com","Calibra Pictures","2590",1750.00,0.00,1750.00],
        ["SO 0003990","2007-10-07","CU 0102131","kenchalk@mac.com","13 Pictures","2595",3085.00,0.00,3085.00],
        ["SO 0004001","2007-10-08","CU 0102139","s_anupam@xaansa.com","XAANSA INFOTECH","2603, 2604",4359.90,0.00,4359.90],
        ["SO 0004011","2007-10-09","CU 0102144","LITEIT1@SBCGLOBAL.NET","LITEIT  CINE RENTALS","2610",3630.90,0.00,3630.90],
        ["SO 0004003","2007-10-09","CU 0102140","mazen_gabali@yahoo.com","gab","2605",7165.00,0.00,7165.00],
        ["SO 0004019","2007-10-10","CU 0102147","pollywoodfilms@gmail.com","Pollywood films","2615",1750.00,0.00,1750.00],
        ["SO 0004013","2007-10-10","CU 0102145","info@palmavideo.com","PalmaVideo","2611",3510.20,0.00,3510.20],
        ["SO 0004021","2007-10-10","CU 0102149","dpfocus@hotmail.com","d.p.focus","2616",6231.50,0.00,6231.50],
        ["SO 0004059","2007-10-15","CU 0102164","mail@dimancho.com","Dimancho Production","2636",4075.00,0.00,4075.00],
        ["SO 0004087","2007-10-17","CU 0102175","nicolasbourbaki@hotmail.com","UEM","2649",1750.00,0.00,1750.00],
        ["SO 0004081","2007-10-17","CU 0102171","drewitz@vws15ltd.tv","VWS15. TV-Production Ltd.","2644",3611.70,0.00,3611.70],
        ["SO 0004101","2007-10-18","CU 0102177","michelgraphics@gmail.com","GREEN OCEAN MEDIA, INC","",4844.00,0.00,4844.00],
        ["SO 0004134","2007-10-19","CU 0102185","alsaudturki@yahoo.com","equi trade courier service","2661, 2662, 2663, 2664",8885.00,0.00,8885.00],
        ["SO 0004136, SO 0004137","2007-10-20, 2007-10-20","CU 0102187","viptv@ecuavisa.com","kabala entertainment","2667, 2668",6957.0,0.0,6957.0],
        ["SO 0004138","2007-10-21","CU 0102188","talal7s@hotmail.com","7spro","2669",6397.70,0.00,6397.70],
        ["SO 0004143","2007-10-22","CU 0101282","julio@energyproductions.tv","ENERGY PRODUCTION CO. INC.","2672, 2673",4610.50,4050.00,560.50],
        ["SO 0004163","2007-10-23","CU 0102200","noorajen@gmail.com","Home","2682",3621.00,0.00,3621.00],
        ["SO 0004168","2007-10-24","CU 0102203","bushil@mail.ru","Ebanutiy Operator","2685",1750.00,0.00,1750.00],
        ["SO 0004176","2007-10-25","CU 0102207","dritt@telenor.no","MØKK","2689",3370.00,0.00,3370.00],
        ["SO 0004223","2007-10-31","CU 0102233","tvguide.khv@gmail.com","TVA","2713",3398.90,0.00,3398.90],
        ["SO 0004230, SO 0004233, SO 0004232","2007-11-01, 2007-11-01, 2007-11-01","CU 0102238","richard@richardsalazar.com","richardsalazar.com","2718, 2719, ",5844.2,0.0,5844.2],
        ["SO-0004261","2007-11-05","CU 0102251","gustavo@elcaiman-films.com","El Caimán Films","2737",6152.50,0.00,6152.50],
        ["SO-0004270, SO-0004411","2007-11-06, 2007-11-21","CU 0102254","kuroda@fpi.co.jp","Kuroda Yuki","2740, ",2760.0,0.0,2760.0],
        ["SO-0004280","2007-11-08","CU 0102259","imanol@kinoskopik.com","KINOSKOPIK S.L.L.","2749",3052.00,2771.00,281.00],
        ["SO-0004306","2007-11-10","CU 0102272","shaufe@filmgear.com.my","FILMGEAR SDN BHD","2764",3535.80,0.00,3535.80],
        ["SO-0004335","2007-11-13","CU 0102284","PERKRIDE@YAHOO.COM","IMMACULATE OIL","2773",3911.30,0.00,3911.30],
        ["SO-0004337","2007-11-14","CU 0102286","cinedunefilm@hotmail.fr","cinedunefilm","2775",4040.00,0.00,4040.00],
        ["SO-0004341","2007-11-14","CU 0102289","irakli@kinoproject.com","Kinoproject, LLC","2780",4705.10,0.00,4705.10],
        ["SO-0004343","2007-11-15","CU 0102291","vultureheights@gmail.com","Vulture Heights Productions","2782",3085.90,0.00,3085.90],
        ["SO-0004360","2007-11-16","CU 0102299","apianoman18@aol.com","connor","2788",3458.30,0.00,3458.30],
        ["SO-0004365","2007-11-17","CU 0102302","popperdoom@yahooc.com","farid","2790",4920.00,0.00,4920.00],
        ["SO-0004370","2007-11-18","CU 0102305","max@pantax.co.il","max lomberg","2793",2998.40,0.00,2998.40],
        ["SO-0004382","2007-11-19","CU 0102311","jbenavides@vanquiser.com","Vanquiser Producciones","2800",1750.00,0.00,1750.00],
        ["SO-0004385","2007-11-20","CU 0102313","panalight@panalight.it","Altafilm Srl","2801, 2802",6810.40,0.00,6810.40],
        ["SO-0004416, SO-0004417","2007-11-22, 2007-11-22","CU 0102333","taa@kathimerini.gr","kathimerini.sa","2833, ",3700.0,0.0,3700.0],
        ["SO-0004420","2007-11-22","CU 0102335","Quincy@linkn.net"," Link\"N Marketing Services","2835",3835.00,0.00,3835.00],
        ["SO-0004434","2007-11-25","CU 0102342","marco@munix-productions.com","munix films","2841",4396.30,0.00,4396.30],
        ["SO-0004453","2007-11-27","CU 0102351","mediaoleg@gmail.com","Technomedia","2850",2037.50,0.00,2037.50],
        ["SO-0004454","2007-11-27","CU 0102352","wagner@niss.no","NISS Film- og TV-Akademiet","2851",3316.50,0.00,3316.50],
        ["SO-0004479","2007-11-29","CU 0102363","mikejkoontz@gmail.com","Sandi Bacchus Insurance Agency","2866",3435.00,0.00,3435.00],
        ["SO-0004484","2007-11-30","CU 0102368","alainassouline@free.fr","MOVIE-LOC","002870, 002871",6309.80,0.00,6309.80],
        ["SO-0004499","2007-12-02","CU 0102374","nate@nateweaver.net","Nate Weaver","2879",1750.00,0.00,1750.00],
        ["SO-0004504","2007-12-03","CU 0102377","davidherran@hotmail.com","SENA","2882",5271.70,0.00,5271.70],
        ["SO-0004537","2007-12-05","CU 0102390","gribva@radioaktivefilm.com","Playback.kiev.ua","2895",2665.60,0.00,2665.60],
        ["SO-0004542","2007-12-06","CU 0102395","diazinfo@yahoo.com","JD consultores politicos","2900",2625.00,0.00,2625.00],
        ["SO-0004552","2007-12-06","CU 0102401","thomjordan@gmail.com","Jordan Films","2908",4805.40,0.00,4805.40],
        ["SO-0004567","2007-12-08","CU 0102409","brot@noos.fr","LUMENS EVENEMENT","2917",3568.00,0.00,3568.00],
        ["SO-0004570","2007-12-10","CU 0102410","EBUTI123@MAIL.RU","VIDEO STUDIO SG","2918",5000.90,0.00,5000.90],
        ["SO-0004574","2007-12-10","CU 0102412","kumkumji@arts2art.com","Arts2Art","002920, 002921",8420.00,0.00,8420.00],
        ["SO-0004615","2007-12-16","CU 0102435","ranson@theujima.com","movietone inc.","2945",2559.90,0.00,2559.90],
        ["SO-0004627","2007-12-17","CU 0102441","cine_ojo@yahoo.com","THE BRIDGE","2952",4034.10,0.00,4034.10],
        ["SO-0004672","2007-12-20","CU 0102448","v.grigorash@richyfilms.com","Richy Films","2963",6294.30,0.00,6294.30],
        ["SO-0004701","2007-12-21","CU 0102458","radkinternational@gmail.com","radkaudio","2979",6173.50,0.00,6173.50],
        ["SO-0004764","2007-12-29","CU 0102482","jerome.larnou@gmail.com","Myobus","3005",2285.00,0.00,2285.00],
        ["SO-0004769","2007-12-31","CU 0102485","salimelturk@hotmail.com","SALIMEL TURK","3008",3704.70,0.00,3704.70],
        ["SO-0004784","2008-01-02","CU 0102495","matt@databass.tv","DataBassMedia","3018",1750.00,0.00,1750.00],
        ["SO-0004815","2008-01-05","CU 0102506","manduck2000@gmail.com","Eye Tv Network","3028",4990.80,0.00,4990.80],
        ["SO-0004950","2008-01-13","CU 0102548","dlanglada@gmail.com","DLanglada designs","3063",3910.70,0.00,3910.70],
        ["SO-0004949","2008-01-13","CU 0102547","igor@revolutiongroup.com.ua","revolution film service","3062",4192.40,0.00,4192.40],
        ["SO-0004973","2008-01-15","CU 0102557","dirpablom@hotmail.com","pablete inc","3073",5021.20,0.00,5021.20],
        ["SO-0004974","2008-01-15","CU 0102558","axisparashuram@yahoo.com","Axis Production House Pvt Ltd","003074, 003075, 003076, 003077, 003078",8750.00,0.00,8750.00],
        ["SO-0004988","2008-01-16","CU 0102561","scottgillen@directorsla.com","SGLA inc.","3085",1750.00,0.00,1750.00],
        ["SO-0005014","2008-01-17","CU 0102573","monnasich@yahoo.com","Logo motion pictures","3094",1750.00,0.00,1750.00],
        ["SO-0005011","2008-01-17","CU 0102570","ismael@lightbox.pt","Lightbox films","3092",2499.10,0.00,2499.10],
        ["SO-0005046","2008-01-19","CU 0102593","tangclub@163.com","TANG CLUB","3103",5339.50,0.00,5339.50],
        ["SO-0005172","2008-01-23","CU 0100059","fireforce@fireforce.com","Fireforce","",1604.00,1000.00,604.00],
        ["SO-0005229","2008-01-25","CU 0100357","toddc@austin.rr.com","Inner Child Studios","",716.90,500.00,216.90],
        ["SO-0005232","2008-01-25","CU 0102617","fabbianni@hotmail.com","unusual minds","3133",2675.00,0.00,2675.00],
        ["SO-0005226, SO-0005227","2008-01-25, 2008-01-25","CU 0102616","rr@conspira.com.br","Conspiracao filmes","003129, 003130, 003131, 003132",25669.9,0.0,25669.9],
        ["SO-0005240","2008-01-26","CU 0102621","sameer@smartmultimedia.biz","Smart Multimedia","3136",3290.00,0.00,3290.00],
        ["SO-0005283","2008-01-29","CU 0102639","ericovertonstudio@gmail.com","Eric Overton Studio","3148",1750.00,0.00,1750.00],
        ["SO-0005356","2008-01-31","CU 0102652","bodhifilms@mac.com","Bodhifilms","3166",5291.10,1180.00,4111.10]
      ].each do |i|
        self.create(
          :order_number => i[0],
          :order_create_date => i[1],
          :customer_number => i[2],
          :email_address => i[3],
          :name => i[4],
          :camera_number => i[5],
          :prepayments_due => i[6],
          :payments_received => i[7],
          :payments_needed => i[8],
          :sid => self.sid_generator
        )
      end
    end
  end

  def name
    "#{self[:name]}"
  end
  
  def ax_account_number
    self.customer_number
  end
  
  def send_mail
    options = {
      :subject => "Payment Status of Your Order",
      :from    => "RED <orders@red.com>"
    }
    super(options)
  end
end
