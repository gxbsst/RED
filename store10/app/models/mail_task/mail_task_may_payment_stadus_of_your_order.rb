class MailTaskMayPaymentStadusOfYourOrder < ActiveRecord::Base
  include MailTask::General

  belongs_to :mail_task
  # has_many :mail_task_apr_ready_to_ship_queue_line_items, :dependent => :destroy

  # Delivery_range_begin = 1501 
  # Delivery_range_end   = 1750
  # 
  # DISCOUNT_PRE_CEMERA               = 0
  # SHIPPING_CHARGE_PRE_CEMERA_IN_US  = 185.29
  # SHIPPING_CHARGE_PRE_CEMERA_OUT_US = 598.49

  # Class methods begin here.
  class << self
    # [
    #      "TRUNCATE #{table_name}",
    #      "TRUNCATE #{line_items_table_name}"
    #    ].each do |statement|
    #      ActiveRecord::Base.connection.execute(statement)
    #    end
    def init_queues
      begin_time = Time.now

      # Cleanup all exists records.
      # self.destroy_all
      # Cleanup all exists records.
      [
        "TRUNCATE #{table_name}"
        ].each do |statement|
          connection.execute(statement)
        end
        # Update AxAccount assign_to (#1001 - #1250)
        [
          ['SO-0005878', '2/21/12', 'CU 0100023', 'axl1@mac.com', '', 'Axl Films', '2,413.10 ', '1,750.00 ', '663.10 '],
          ['SO-0005444', '2/6/12', 'CU 0100129', 'lakeviewpres@aol.com', '', '', '1,145.00 ', '200.92 ', '944.08 '],
          ['SO-0005529', '2/7/12', 'CU 0100144', 'ckarcher@karcherdesign.com', '', 'Karcher', '296.20 ', '0.00 ', '296.20 '],
          ['SO-0005623', '2/11/12', 'CU 0100229', 'dewaldaukema@mac.com', '', 'Cinematographer', '2,653.70 ', '2,250.00 ', '403.70 '],
          ['SO-0005487', '2/7/12', 'CU 0100409', 'j@bigsmile.com', '3200', '', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0005801', '2/18/12', 'CU 0100437', 'smilingdog@telus.net', '', '', '2,399.60 ', '1,000.00 ', '1,399.60 '],
          ['SO-0006421', '3/10/12', 'CU 0100458', 'wowholdings88@yahoo.com.hk', '003428, 003429, 003430, 003431, 003432', 'WOW Holdings Limited', '8,750.00 ', '3,356.51 ', '5,393.49 '],
          ['SO-0005941', '2/22/12', 'CU 0100517', 'maheelrp@dcinemanetworks.com', '', 'DCinema Neworks', '1,372.50 ', '1,000.00 ', '372.50 '],
          ['SO-0005434', '2/5/12', 'CU 0100578', 'mike@michaelepple.com', '', '', '327.70 ', '0.00 ', '327.70 '],
          ['SO 0003897', '9/27/11', 'CU 0100647', 'pennywatier@psps.com', '2502, 2503, 2504, 2505, 2506, 2507, 2508, 2509, 2510, 2511, 2512, 2513, 2514, 2515, 2516, 2517, 2518, 2519, 2520, 2521, 2522, 2523, 2524, 2525, 2526, 2527, 2528, 2529, 2530, 2531', 'P.S Production Services', '52,500.00 ', '18,585.70 ', '33,914.30 '],
          ['SO-0005612', '2/10/12', 'CU 0100729', 'ross@marsprod.com', '', 'Mars Productions', '1,873.80 ', '1,000.00 ', '873.80 '],
          ['SO 0003571', '9/5/11', 'CU 0100802', 'tom@fletch.com', '2306, 2307, 2308, 2309, 2310', 'Fletcher ChiCAgo, Inc,', '15,422.42 ', '4,577.00 ', '10,845.42 '],
          ['SO 0003631', '9/8/11', 'CU 0100864', 'ryan@red.com', '2357', '', '1,800.00 ', '2.50 ', '1,797.50 '],
          ['SO-0006713', '3/19/12', 'CU 0100964', 'kjones@alamofilms.com', '', '', '1,200.00 ', '0.00 ', '1,200.00 '],
          ['SO-0006737', '3/20/12', 'CU 0101085', 'fabian.flesch@film-kontor.de', '', '', '345.00 ', '0.00 ', '345.00 '],
          ['SO-0006731', '3/20/12', 'CU 0101203', 'michael@movie-magic.tv', '', '', '5,426.00 ', '2,000.00 ', '3,426.00 '],
          ['SO-0007447', '4/10/12', 'CU 0101281', 'caxrax@gmail.com', '3922', 'Metacube', '2,325.70 ', '0.00 ', '2,325.70 '],
          ['SO-0007448', '4/10/12', 'CU 0101281', 'caxrax@gmail.com', '', 'Metacube', '252.70 ', '0.00 ', '252.70 '],
          ['SO 0004143', '10/23/11', 'CU 0101282', 'julio@energyproductions.tv', '2672, 2673', 'ENERGY PRODUCTION CO. INC.', '4,670.50 ', '4,170.00 ', '500.50 '],
          ['SO-0007228', '4/2/12', 'CU 0101358', 'wasin@kantana.co.th', '', 'Kantana Group PCL', '6,683.50 ', '1,750.00 ', '4,933.50 '],
          ['SO-0007456', '4/10/12', 'CU 0101666', 'lucatornatore@dmcommunication.net', '3925', 'DM Communication', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003600', '9/6/11', 'CU 0101725', 'Goldenadam@gmail.com', '2335', 'flower of Life Films', '3,700.00 ', '0.00 ', '3,700.00 '],
          ['SO-0006973', '3/26/12', 'CU 0101730', 'victor_t@cinemotion.bg', '', "charles schultz production's", '3,479.00 ', '0.00 ', '3,479.00 '],
          ['SO 0003342', '8/8/11', 'CU 0101761', 'an0n0email@yahoo.com', '2149', 'Company', '2,025.00 ', '0.00 ', '2,025.00 '],
          ['SO 0003351', '8/10/11', 'CU 0101766', 'paolopisacane@yahoo.com', '2153', 'paolo pisacane', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003355', '8/11/11', 'CU 0101768', 'ivo.tsvetkov@gmail.com', '2155', 'NGP', '7,229.50 ', '0.00 ', '7,229.50 '],
          ['SO 0003363', '8/13/11', 'CU 0101773', 'obi.nnaya@nayatronix.com', '2159', 'DDD Entertainment', '2,025.00 ', '0.00 ', '2,025.00 '],
          ['SO 0003364', '8/14/11', 'CU 0101774', 'binmejren@yahoo.com', '2160', 'Mejren Enterprises', '4,257.00 ', '0.00 ', '4,257.00 '],
          ['SO 0003365', '8/14/11', 'CU 0101775', 'sales@grapplestudios.lt', '2161', 'Grapple Studios', '6,804.50 ', '0.00 ', '6,804.50 '],
          ['SO 0003369', '8/14/11', 'CU 0101777', 'rich@sentinel-entertainment.co.za', '2163', 'Sentinel Entertainment', '2,420.00 ', '0.00 ', '2,420.00 '],
          ['SO 0003372', '8/14/11', 'CU 0101779', 'ragnarlasse@hotmail.com', '', 'Vassfaret studio', '275.00 ', '0.00 ', '275.00 '],
          ['SO 0003378', '8/15/11', 'CU 0101782', 'info@jmpictures.nl', '2169', '', '3,375.00 ', '0.00 ', '3,375.00 '],
          ['SO 0003380', '8/15/11', 'CU 0101784', 'korbic@gmail.com', '2171', 'korbic', '2,754.80 ', '0.00 ', '2,754.80 '],
          ['SO 0003389', '8/17/11', 'CU 0101789', 'rjlocking@hotmail.com', '2176', 'http://goldeneye.com/golden-7.htm', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003392', '8/17/11', 'CU 0101791', 'abcwahid@hotmail.com', '2178', 'New Line Indie', '2,755.00 ', '0.00 ', '2,755.00 '],
          ['SO 0003395', '8/18/11', 'CU 0101794', 'andrej@vpk.si', '2181', 'VPK', '2,025.00 ', '0.00 ', '2,025.00 '],
          ['SO 0003396', '8/18/11', 'CU 0101795', 'takhmaz@yahoo.co.uk', '2182', 'ZZ', '8,629.50 ', '0.00 ', '8,629.50 '],
          ['SO 0003404', '8/19/11', 'CU 0101800', 'aaron@breslaw.net', '2188', 'freelance', '2,555.00 ', '0.00 ', '2,555.00 '],
          ['SO 0003407', '8/19/11', 'CU 0101802', 'banditsfilms@gmail.com', '2190', 'bandits films', '2,867.00 ', '0.00 ', '2,867.00 '],
          ['SO 0003411', '8/21/11', 'CU 0101805', 'chris@skyviewfilms.com', '', 'Skyview Films', '2,547.50 ', '0.00 ', '2,547.50 '],
          ['SO 0003420', '8/22/11', 'CU 0101811', 'oz@youngturk.biz', '2200', '2nd floor productions limited', '2,025.00 ', '0.00 ', '2,025.00 '],
          ['SO 0003421', '8/22/11', 'CU 0101812', 'reserve_mail2@hotmail.com', '2201', 'None', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003429', '8/23/11', 'CU 0101817', 'jbarajas@iteso.mx', '2206', 'Fomento Cultural', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003430', '8/24/11', 'CU 0101818', 'danny@broadcast.co.il', '2207', 'broadcast Israel', '5,664.50 ', '4,756.00 ', '908.50 '],
          ['SO 0003439', '8/24/11', 'CU 0101822', 'ryan@red.com', '2210, 2211, 2212, 2213, 2214', 'Shaw Studios', '23,715.00 ', '4,320.00 ', '19,395.00 '],
          ['SO 0003450', '8/26/11', 'CU 0101827', 'ramiszaki@gmail.com', '2224', 'Arascope', '4,942.00 ', '0.00 ', '4,942.00 '],
          ['SO 0003453', '8/26/11', 'CU 0101829', 'midocean@comcast.net', '2226', 'akula Films', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003472', '8/29/11', 'CU 0101846', 'contact@onefish.it', '2239', 'onefish', '2,310.00 ', '0.00 ', '2,310.00 '],
          ['SO 0003476', '8/29/11', 'CU 0101849', 'senol@thisismint.be', '2241', 'fiction factory', '3,387.00 ', '0.00 ', '3,387.00 '],
          ['SO 0003478', '8/29/11', 'CU 0101850', 'maximovster@gmail.com', '2243', 'SMAX STUDIO PRO', '8,474.50 ', '0.00 ', '8,474.50 '],
          ['SO 0003487', '8/29/11', 'CU 0101855', 'jens@motionart.net', '2247', 'Motionart Films, Ltd.', '8,139.50 ', '0.00 ', '8,139.50 '],
          ['SO 0003496', '8/30/11', 'CU 0101860', 'janez.kovic@arkadena.si', '2255', 'Studio Arkadena', '3,802.00 ', '0.00 ', '3,802.00 '],
          ['SO 0003507', '9/1/11', 'CU 0101867', 'davidmendes@mariodaniel.com', '2264', 'Ideias com Pernas', '3,080.00 ', '0.00 ', '3,080.00 '],
          ['SO 0003522', '9/2/11', 'CU 0101872', 'agarez@correio24.com', '', 'Armando Costa', '275.00 ', '0.00 ', '275.00 '],
          ['SO 0003546', '9/3/11', 'CU 0101881', 'anychina@hotmail.com', '2283', 'Deseam Research Lab.', '7,980.88 ', '0.00 ', '7,980.88 '],
          ['SO 0003557', '9/4/11', 'CU 0101889', 'jtrapero@visionuno.com', '2292', 'Cineassist', '3,802.00 ', '0.00 ', '3,802.00 '],
          ['SO 0003559', '9/4/11', 'CU 0101891', 'estudiosradi@prodigy.net.mx', '2294', 'estudios radi', '7,174.50 ', '0.00 ', '7,174.50 '],
          ['SO 0003566', '9/5/11', 'CU 0101898', 'victorholl@gmail.com', '2301', 'Victor Holl', '2,555.00 ', '0.00 ', '2,555.00 '],
          ['SO-0007027', '3/27/12', 'CU 0101909', 'dom@thescarab.org', '', 'Scarab Studio', '3,502.50 ', '2,025.00 ', '1,477.50 '],
          ['SO 0003608', '9/7/11', 'CU 0101924', 'info@cineplanet.tv', '2340', 'Cineplanet', '4,622.00 ', '0.00 ', '4,622.00 '],
          ['SO 0003630', '9/8/11', 'CU 0101937', 'juguryan@excite.com', '2356', 'films', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003639', '9/8/11', 'CU 0101942', 'boris@bayram.uz', '2364', 'BAYRAM-FILM', '4,435.00 ', '0.00 ', '4,435.00 '],
          ['SO 0003642', '9/8/11', 'CU 0101944', 'tsepelikas@yahoo.com', '2367', 'argyris tsepelikas', '3,785.00 ', '0.00 ', '3,785.00 '],
          ['SO 0003703', '9/12/11', 'CU 0101979', 'raffi@platformstudios.com', '2415', 'Platform Studios', '2,630.00 ', '0.00 ', '2,630.00 '],
          ['SO 0003839', '9/25/11', 'CU 0102039', 'sanjin@creative247.ba', '2465', 'creative 24/7', '3,416.00 ', '0.00 ', '3,416.00 '],
          ['SO 0003859', '9/25/11', 'CU 0102050', 'gsd@otenet.gr', '2478', 'DOLPHINS PRODUCTIONS', '5,051.50 ', '0.00 ', '5,051.50 '],
          ['SO 0003865', '9/26/11', 'CU 0102054', 'polyakov@irecords.ru', '2486', 'iRecords Ltd.', '2,310.00 ', '0.00 ', '2,310.00 '],
          ['SO 0003902', '9/28/11', 'CU 0102076', 'hds@trm.fr', '', 'TRM', '315.00 ', '0.00 ', '315.00 '],
          ['SO 0003905', '9/29/11', 'CU 0102078', 'miguel.mesas@mac.com', '2534', 'Digital Kore', '4,570.10 ', '0.00 ', '4,570.10 '],
          ['SO 0003939', '10/4/11', 'CU 0102100', 'aron@colorfront.com', '2561', 'Colorfront', '4,017.50 ', '0.00 ', '4,017.50 '],
          ['SO 0003955', '10/5/11', 'CU 0102112', 'umeshshirupalli@gmail.com', '2572', 'sound of music', '4,775.00 ', '0.00 ', '4,775.00 '],
          ['SO 0003985', '10/7/11', 'CU 0102128', 'jnewton@calibracorp.com', '2590', 'Calibra Pictures', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0003990', '10/8/11', 'CU 0102131', 'kenchalk@mac.com', '2595', '13 Pictures', '3,085.00 ', '0.00 ', '3,085.00 '],
          ['SO 0004001', '10/9/11', 'CU 0102139', 's_anupam@xaansa.com', '2603, 2604', 'XAANSA INFOTECH', '4,359.90 ', '0.00 ', '4,359.90 '],
          ['SO-0007468', '4/10/12', 'CU 0102140', 'mazen_gabali@yahoo.com', '003927, 003928', 'gab', '9,623.00 ', '0.00 ', '9,623.00 '],
          ['SO 0004003', '10/10/11', 'CU 0102140', 'mazen_gabali@yahoo.com', '2605', 'gab', '7,165.00 ', '0.00 ', '7,165.00 '],
          ['SO 0004011', '10/10/11', 'CU 0102144', 'LITEIT1@SBCGLOBAL.NET', '2610', 'LITEIT  CINE RENTALS', '3,630.90 ', '0.00 ', '3,630.90 '],
          ['SO 0004013', '10/11/11', 'CU 0102145', 'info@palmavideo.com', '2611', 'PalmaVideo', '3,510.20 ', '0.00 ', '3,510.20 '],
          ['SO 0004019', '10/11/11', 'CU 0102147', 'pollywoodfilms@gmail.com', '2615', 'Pollywood films', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0004059', '10/16/11', 'CU 0102164', 'mail@dimancho.com', '2636', 'Dimancho Production', '4,075.00 ', '0.00 ', '4,075.00 '],
          ['SO 0004081', '10/18/11', 'CU 0102171', 'drewitz@vws15ltd.tv', '2644', 'VWS15. TV-Production Ltd.', '3,611.70 ', '0.00 ', '3,611.70 '],
          ['SO 0004087', '10/18/11', 'CU 0102175', 'nicolasbourbaki@hotmail.com', '2649', 'UEM', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0004101', '10/19/11', 'CU 0102177', 'michelgraphics@gmail.com', '', 'GREEN OCEAN MEDIA, INC', '4,844.00 ', '0.00 ', '4,844.00 '],
          ['SO 0004134', '10/20/11', 'CU 0102185', 'alsaudturki@yahoo.com', '2661, 2662, 2663, 2664', 'equi trade courier service', '8,885.00 ', '0.00 ', '8,885.00 '],
          ['SO 0004137', '10/21/11', 'CU 0102187', 'viptv@ecuavisa.com', '2668', 'kabala entertainment', '4,228.50 ', '0.00 ', '4,228.50 '],
          ['SO 0004136', '10/21/11', 'CU 0102187', 'viptv@ecuavisa.com', '2667', 'kabala entertainment', '2,728.50 ', '0.00 ', '2,728.50 '],
          ['SO 0004138', '10/22/11', 'CU 0102188', 'talal7s@hotmail.com', '2669', '7spro', '6,397.70 ', '0.00 ', '6,397.70 '],
          ['SO 0004163', '10/24/11', 'CU 0102200', 'noorajen@gmail.com', '2682', 'Home', '3,621.00 ', '0.00 ', '3,621.00 '],
          ['SO 0004168', '10/25/11', 'CU 0102203', 'bushil@mail.ru', '2685', 'Ebanutiy Operator', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0004176', '10/26/11', 'CU 0102207', 'dritt@telenor.no', '2689', 'MØKK', '3,370.00 ', '0.00 ', '3,370.00 '],
          ['SO 0004223', '11/1/11', 'CU 0102233', 'tvguide.khv@gmail.com', '2713', 'TVA', '3,398.90 ', '0.00 ', '3,398.90 '],
          ['SO 0004232', '11/2/11', 'CU 0102238', 'richard@richardsalazar.com', '', 'richardsalazar.com', '2,344.20 ', '0.00 ', '2,344.20 '],
          ['SO 0004230', '11/2/11', 'CU 0102238', 'richard@richardsalazar.com', '2718', 'richardsalazar.com', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO 0004233', '11/2/11', 'CU 0102238', 'richard@richardsalazar.com', '2719', 'richardsalazar.com', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004261', '11/6/11', 'CU 0102251', 'gustavo@elcaiman-films.com', '2737', 'El Caimán Films', '6,152.50 ', '0.00 ', '6,152.50 '],
          ['SO-0004270', '11/7/11', 'CU 0102254', 'kuroda@fpi.co.jp', '2740', 'Kuroda Yuki', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004411', '11/22/11', 'CU 0102254', 'kuroda@fpi.co.jp', '', 'Kuroda Yuki', '1,010.00 ', '0.00 ', '1,010.00 '],
          ['SO-0004306', '11/11/11', 'CU 0102272', 'shaufe@filmgear.com.my', '2764', 'FILMGEAR SDN BHD', '3,535.80 ', '0.00 ', '3,535.80 '],
          ['SO-0004335', '11/14/11', 'CU 0102284', 'PERKRIDE@YAHOO.COM', '2773', 'IMMACULATE OIL', '3,911.30 ', '0.00 ', '3,911.30 '],
          ['SO-0004337', '11/15/11', 'CU 0102286', 'cinedunefilm@hotmail.fr', '2775', 'cinedunefilm', '4,040.00 ', '0.00 ', '4,040.00 '],
          ['SO-0004341', '11/15/11', 'CU 0102289', 'irakli@kinoproject.com', '2780', 'Kinoproject, LLC', '4,705.10 ', '0.00 ', '4,705.10 '],
          ['SO-0004360', '11/17/11', 'CU 0102299', 'apianoman18@aol.com', '2788', 'connor', '3,458.30 ', '0.00 ', '3,458.30 '],
          ['SO-0004365', '11/18/11', 'CU 0102302', 'popperdoom@yahooc.com', '2790', 'farid', '4,920.00 ', '0.00 ', '4,920.00 '],
          ['SO-0004370', '11/19/11', 'CU 0102305', 'max@pantax.co.il', '2793', 'max lomberg', '2,998.40 ', '0.00 ', '2,998.40 '],
          ['SO-0004373', '11/20/11', 'CU 0102307', 'loukilmedia@gmail.com', '', 'media center', '170.00 ', '0.00 ', '170.00 '],
          ['SO-0004382', '11/20/11', 'CU 0102311', 'jbenavides@vanquiser.com', '2800', 'Vanquiser Producciones', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004385', '11/21/11', 'CU 0102313', 'panalight@panalight.it', '2801, 2802', 'Altafilm Srl', '6,810.40 ', '0.00 ', '6,810.40 '],
          ['SO-0004417', '11/23/11', 'CU 0102333', 'taa@kathimerini.gr', '', 'kathimerini.sa', '1,950.00 ', '0.00 ', '1,950.00 '],
          ['SO-0004416', '11/23/11', 'CU 0102333', 'taa@kathimerini.gr', '2833', 'kathimerini.sa', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004420', '11/23/11', 'CU 0102335', 'Quincy@linkn.net', '2835', 'Link"N Marketing Services', '3,835.00 ', '0.00 ', '3,835.00 '],
          ['SO-0004434', '11/26/11', 'CU 0102342', 'marco@munix-productions.com', '2841', 'munix films', '4,396.30 ', '3,160.00 ', '1,236.30 '],
          ['SO-0004453', '11/28/11', 'CU 0102351', 'mediaoleg@gmail.com', '2850', 'Technomedia', '2,037.50 ', '0.00 ', '2,037.50 '],
          ['SO-0004454', '11/28/11', 'CU 0102352', 'wagner@niss.no', '2851', 'NISS Film- og TV-Akademiet', '3,316.50 ', '0.00 ', '3,316.50 '],
          ['SO-0004479', '11/30/11', 'CU 0102363', 'mikejkoontz@gmail.com', '2866', 'Sandi Bacchus Insurance Agency', '3,435.00 ', '0.00 ', '3,435.00 '],
          ['SO-0004484', '12/1/11', 'CU 0102368', 'alainassouline@free.fr', '002870, 002871', 'MOVIE-LOC', '6,309.80 ', '0.00 ', '6,309.80 '],
          ['SO-0004499', '12/3/11', 'CU 0102374', 'nate@nateweaver.net', '2879', 'Nate Weaver', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004504', '12/4/11', 'CU 0102377', 'davidherran@hotmail.com', '2882', 'SENA', '5,271.70 ', '0.00 ', '5,271.70 '],
          ['SO-0004537', '12/6/11', 'CU 0102390', 'gribva@radioaktivefilm.com', '2895', 'Playback.kiev.ua', '2,665.60 ', '0.00 ', '2,665.60 '],
          ['SO-0004542', '12/7/11', 'CU 0102395', 'diazinfo@yahoo.com', '2900', 'JD consultores politicos', '2,625.00 ', '0.00 ', '2,625.00 '],
          ['SO-0004552', '12/7/11', 'CU 0102401', 'thomjordan@gmail.com', '2908', 'Jordan Films', '4,805.40 ', '0.00 ', '4,805.40 '],
          ['SO-0004567', '12/9/11', 'CU 0102409', 'brot@noos.fr', '2917', 'LUMENS EVENEMENT', '3,568.00 ', '0.00 ', '3,568.00 '],
          ['SO-0004570', '12/11/11', 'CU 0102410', 'EBUTI123@MAIL.RU', '2918', 'VIDEO STUDIO SG', '5,000.90 ', '0.00 ', '5,000.90 '],
          ['SO-0004574', '12/11/11', 'CU 0102412', 'kumkumji@arts2art.com', '002920, 002921', 'Arts2Art', '8,420.00 ', '0.00 ', '8,420.00 '],
          ['SO-0004615', '12/17/11', 'CU 0102435', 'ranson@theujima.com', '2945', 'movietone inc.', '2,559.90 ', '0.00 ', '2,559.90 '],
          ['SO-0004627', '12/18/11', 'CU 0102441', 'cine_ojo@yahoo.com', '2952', 'THE BRIDGE', '4,034.10 ', '0.00 ', '4,034.10 '],
          ['SO-0004672', '12/21/11', 'CU 0102448', 'v.grigorash@richyfilms.com', '2963', 'Richy Films', '6,294.30 ', '0.00 ', '6,294.30 '],
          ['SO-0004701', '12/22/11', 'CU 0102458', 'radkinternational@gmail.com', '2979', 'radkaudio', '6,173.50 ', '0.00 ', '6,173.50 '],
          ['SO-0004764', '12/30/11', 'CU 0102482', 'jerome.larnou@gmail.com', '3005', 'Myobus', '2,285.00 ', '0.00 ', '2,285.00 '],
          ['SO-0004769', '1/1/12', 'CU 0102485', 'salimelturk@hotmail.com', '3008', 'SALIMEL TURK', '3,704.70 ', '0.00 ', '3,704.70 '],
          ['SO-0004784', '1/3/12', 'CU 0102495', 'matt@databass.tv', '3018', 'DataBassMedia', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0004815', '1/6/12', 'CU 0102506', 'manduck2000@gmail.com', '3028', 'Eye Tv Network', '4,990.80 ', '0.00 ', '4,990.80 '],
          ['SO-0004949', '1/14/12', 'CU 0102547', 'igor@revolutiongroup.com.ua', '3062', 'revolution film service', '4,192.40 ', '0.00 ', '4,192.40 '],
          ['SO-0004950', '1/14/12', 'CU 0102548', 'dlanglada@gmail.com', '3063', 'DLanglada designs', '3,910.70 ', '0.00 ', '3,910.70 '],
          ['SO-0004973', '1/16/12', 'CU 0102557', 'dirpablom@hotmail.com', '3073', 'pablete inc', '5,021.20 ', '0.00 ', '5,021.20 '],
          ['SO-0004974', '1/16/12', 'CU 0102558', 'axisparashuram@yahoo.com', '003074, 003075, 003076, 003077, 003078', 'Axis Production House Pvt Ltd', '8,750.00 ', '0.00 ', '8,750.00 '],
          ['SO-0004988', '1/17/12', 'CU 0102561', 'scottgillen@directorsla.com', '3085', 'SGLA inc.', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0005014', '1/18/12', 'CU 0102573', 'monnasich@yahoo.com', '3094', 'Logo motion pictures', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0005046', '1/20/12', 'CU 0102593', 'tangclub@163.com', '3103', 'TANG CLUB', '5,339.50 ', '0.00 ', '5,339.50 '],
          ['SO-0005232', '1/26/12', 'CU 0102617', 'fabbianni@hotmail.com', '3133', 'unusual minds', '2,675.00 ', '0.00 ', '2,675.00 '],
          ['SO-0005240', '1/27/12', 'CU 0102621', 'sameer@smartmultimedia.biz', '3136', 'Smart Multimedia', '3,290.00 ', '0.00 ', '3,290.00 '],
          ['SO-0005283', '1/30/12', 'CU 0102639', 'ericovertonstudio@gmail.com', '3148', 'Eric Overton Studio', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0005356', '2/1/12', 'CU 0102652', 'bodhifilms@mac.com', '3166', 'Bodhifilms', '5,291.10 ', '1,180.00 ', '4,111.10 '],
          ['SO-0005370', '2/2/12', 'CU 0102654', 'dinindu@hotmail.com', '3169', 'Dinindu Jagoda', '5,367.50 ', '0.00 ', '5,367.50 '],
          ['SO-0005408', '2/5/12', 'CU 0102668', 'drazen.stader@siol.net', '3180', 'staderzen', '2,190.00 ', '0.00 ', '2,190.00 '],
          ['SO-0005427', '2/5/12', 'CU 0102670', 'motives829@yahoo.com', '3182', 'isaiah michel', '4,712.20 ', '0.00 ', '4,712.20 '],
          ['SO-0005431', '2/5/12', 'CU 0102672', 'rafikhajiyev@gmail.com', '3184', 'Rafiq Hajiyev', '4,320.30 ', '0.00 ', '4,320.30 '],
          ['SO-0005448', '2/6/12', 'CU 0102675', 'matteo.dispenza@libreidee.org', '3188', 'Libre', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0005467', '2/6/12', 'CU 0102677', 'studio@vedadovision.com', '3194', 'Ventura Films', '2,989.00 ', '0.00 ', '2,989.00 '],
          ['SO-0005532', '2/8/12', 'CU 0102686', 'joachimlevy@mac.com', '3208', 'Joachim Levy', '3,985.10 ', '0.00 ', '3,985.10 '],
          ['SO-0005536', '2/8/12', 'CU 0102688', 'cj@widescreen.ee', '3210', 'Widescreen LLC', '3,135.00 ', '0.00 ', '3,135.00 '],
          ['SO-0005576', '2/8/12', 'CU 0102696', 'mike@mytrashmail.com', '003217, 003218, 003219, 003220, 003221, 003222, 003223, 003224, 003225, 003226, 003227, 003228, 003229, 003230, 003231, 003232, 003233, 003234, 003235, 003236', 'Biz', '101,276.20 ', '0.00 ', '101,276.20 '],
          ['SO-0005610', '2/9/12', 'CU 0102702', 'vegelover@gmail.com', '3245', 'Paramount Pictures', '3,848.00 ', '0.00 ', '3,848.00 '],
          ['SO-0005617', '2/10/12', 'CU 0102705', 'hgprod@mac.com', '3247', 'HG Productions', '4,907.80 ', '0.00 ', '4,907.80 '],
          ['SO-0005708', '2/14/12', 'CU 0102726', 'DonVeg@mac.com', '3271', 'T-Veg Productions', '2,725.00 ', '0.00 ', '2,725.00 '],
          ['SO-0005719', '2/15/12', 'CU 0102728', 'info@multipointmedia.it', '3274', 'MultipointMedia', '4,221.00 ', '0.00 ', '4,221.00 '],
          ['SO-0005720', '2/15/12', 'CU 0102729', 'office@vincentfilm.com', '3275', 'vincent filmproduktion GmbH', '4,500.00 ', '0.00 ', '4,500.00 '],
          ['SO-0005770', '2/16/12', 'CU 0102736', 'lkelly010@hotmail.com', '3283', 'luis kelly', '8,873.80 ', '0.00 ', '8,873.80 '],
          ['SO-0005796', '2/17/12', 'CU 0102740', 'langfilmsllc@mac.com', '003288, 003289', 'Bestfriends Media INC.', '6,294.20 ', '0.00 ', '6,294.20 '],
          ['SO-0005804', '2/18/12', 'CU 0102741', 'saitom@jp.seika.com', '003292, 003293', 'Seika Corporation', '4,884.00 ', '2,000.00 ', '2,884.00 '],
          ['SO-0005805', '2/19/12', 'CU 0102742', 'chonglee1978@163.com', '003294, 003295, 003296, 003297, 003298, 003299, 003300, 003301, 003302', 'CHONGLEE', '53,077.10 ', '0.00 ', '53,077.10 '],
          ['SO-0005815', '2/19/12', 'CU 0102745', 'betacam@bk.ru', '3305', 'Betacamera Co.', '3,856.40 ', '0.00 ', '3,856.40 '],
          ['SO-0005835', '2/19/12', 'CU 0102749', 'mihow2007@mytekdigital.com', '3308', 'Michal Jurewicz', '2,309.90 ', '0.00 ', '2,309.90 '],
          ['SO-0005839', '2/20/12', 'CU 0102750', 'Moemoney@bigboyz.tv', '3309', 'Big Boyz Entertainment', '4,701.20 ', '0.00 ', '4,701.20 '],
          ['SO-0005840', '2/20/12', 'CU 0102751', 'WIM@BOCACINE.BE', '3310', 'BOCACINE', '4,105.00 ', '0.00 ', '4,105.00 '],
          ['SO-0005850', '2/20/12', 'CU 0102752', 'mkruhmin@saddleback.edu', '3311', 'Saddleback College', '5,222.30 ', '0.00 ', '5,222.30 '],
          ['SO-0005942', '2/22/12', 'CU 0102761', 'video.jason@gmail.com', '3319', 'ST Video&Film Equipments LTD.', '2,570.00 ', '0.00 ', '2,570.00 '],
          ['SO-0006007', '2/24/12', 'CU 0102765', 'info@cinehd.com', '3324', 'CINEHD', '2,686.10 ', '0.00 ', '2,686.10 '],
          ['SO-0006008', '2/24/12', 'CU 0102766', 'wadilaadam@gmail.com', '3325', 'madame ginette', '2,395.00 ', '0.00 ', '2,395.00 '],
          ['SO-0006018', '2/25/12', 'CU 0102771', 'jason@leviathanstrategy.com', '3330', 'Leviathan', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0006028', '2/26/12', 'CU 0102774', 'tfw@indentstudios.com', '003334, 003335', 'Indent Studios, LLC', '5,907.00 ', '0.00 ', '5,907.00 '],
          ['SO-0006105', '2/28/12', 'CU 0102788', 'info@arkadiancollection.com', '3348', 'MAITREYA PRODUCTIONS LLC.', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0006144', '3/1/12', 'CU 0102799', 'drummerhot@hotmail.com', '3353', 'James Gao', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0006182', '3/2/12', 'CU 0102813', 'ej_walton@hotmail.com', '003377, 003378, 003379', 'Global Studios North America', '7,825.00 ', '0.00 ', '7,825.00 '],
          ['SO-0006186', '3/3/12', 'CU 0102816', 'loutrixrecords@netzero.com', '3382', 'E.S.L. Films', '1,875.00 ', '0.00 ', '1,875.00 '],
          ['SO-0006215', '3/4/12', 'CU 0102818', 'urbanizvuk@gmail.com', '3385', 'Urbani zvuk', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0006322', '3/7/12', 'CU 0102842', 'Alnawrasmedia@yahoo.com', '3408', 'Rahieq co', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0006369', '3/7/12', 'CU 0102847', 'info@golden-eye.nl', '003414, 003415, 003416', 'golden eye', '8,154.50 ', '0.00 ', '8,154.50 '],
          ['SO-0006394', '3/8/12', 'CU 0102849', 'neverevil17@yahoo.com', '3419', 'invest prod', '4,930.00 ', '0.00 ', '4,930.00 '],
          ['SO-0006401', '3/8/12', 'CU 0102852', 'prodboys@gmail.com', '3420', 'Production Boys', '6,700.60 ', '0.00 ', '6,700.60 '],
          ['SO-0006456', '3/12/12', 'CU 0102868', 'ikusu94@hotmail.com', '3728', 'HAN', '4,966.00 ', '0.00 ', '4,966.00 '],
          ['SO-0006703', '3/19/12', 'CU 0102920', 'chester@plasmatik.com', '', 'Plasmatik Design', '1,584.90 ', '0.00 ', '1,584.90 '],
          ['SO-0006716', '3/19/12', 'CU 0102921', 'info@mirkozlatar.com', '3782', 'mirko zlatar', '3,899.20 ', '0.00 ', '3,899.20 '],
          ['SO-0006848', '3/21/12', 'CU 0102936', 'dankrames@volny.cz', '3797', 'ALPHA PLUS PRO', '2,380.00 ', '0.00 ', '2,380.00 '],
          ['SO-0006906', '3/24/12', 'CU 0102945', 'sashatronics@gmail.com', '3804', 'Sashatronics Designs', '3,341.00 ', '2,400.00 ', '941.00 '],
          ['SO-0006937', '3/26/12', 'CU 0102948', 'jwllr@mail.ru', '3807', 'Veles', '6,281.00 ', '0.00 ', '6,281.00 '],
          ['SO-0006970', '3/26/12', 'CU 0102960', 'martin@mkrproductions.com', '3822', 'mkr productions GmbH', '1,875.00 ', '0.00 ', '1,875.00 '],
          ['SO-0007061', '3/28/12', 'CU 0102972', 'belov.denis@mail.ru', '3834', 'Belov Denis', '5,584.70 ', '0.00 ', '5,584.70 '],
          ['SO-0007069', '3/28/12', 'CU 0102975', 'perm841851@aol.com', '3836', 'Port Republic Productions', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0007147', '4/1/12', 'CU 0102997', 'gboa@eciad.ca', '3860', 'Emily Carr Institute of Art & Design', '3,423.50 ', '0.00 ', '3,423.50 '],
          ['SO-0007234', '4/3/12', 'CU 0103007', 'a@hanmail.net', '003874, 003875', 'asd', '3,625.00 ', '0.00 ', '3,625.00 '],
          ['SO-0007310', '4/4/12', 'CU 0103018', '123@123.com', '3880', '123', '4,225.00 ', '0.00 ', '4,225.00 '],
          ['SO-0007340', '4/5/12', 'CU 0103024', 'julr@noos.fr', '3890', 'astrolab', '2,386.20 ', '0.00 ', '2,386.20 '],
          ['SO-0007383', '4/8/12', 'CU 0103033', 'nicolas@le-studio.ch', '3903', 'Le Studio Production SA', '3,477.30 ', '0.00 ', '3,477.30 '],
          ['SO-0007437', '4/9/12', 'CU 0103045', 'magda@efd.com.mx', '3917', 'Equipment & film Design S.A de C.V', '2,658.70 ', '0.00 ', '2,658.70 '],
          ['SO-0007438', '4/9/12', 'CU 0103045', 'magda@efd.com.mx', '3918', 'Equipment & film Design S.A de C.V', '1,750.00 ', '0.00 ', '1,750.00 '],
          ['SO-0007491', '4/11/12', 'CU 0103058', 'kino_ke@yahoo.it', '3932', 'rental compny', '2,600.00 ', '0.00 ', '2,600.00 '],
          ['SO-0007515', '4/12/12', 'CU 0103066', 'desainc@rediffmail.com', '003940, 003941, 003942', 'chandrakant productions pvt. ltd.', '7,835.00 ', '0.00 ', '7,835.00 ']              
          ].each do |i|
            if MailTaskMayPaymentStadusOfYourOrder.find(:first, :conditions => ['ax_account_number = ?', i[0]])
              open("#{RAILS_ROOT}/log/repeat_orders.log", "a+") { |file| file << "#{i[2]}\n" }

            else
              i[3] = AxAccount.find(:first, :conditions => ['ax_account_number = ?' ,i[2]]).email_address unless AxAccount.find(:first, :conditions => ['ax_account_number = ?' ,i[2]]).email_address.nil?
              MailTaskMayPaymentStadusOfYourOrder.create(:ax_order_number     => i[0], :order_date => i[1], :ax_account_number => i[2], :email_address => i[3], :camerma_number => i[4], :full_name => i[5], :prepayments_due => i[6], :prepayments_received => i[7], :prepayments_needed => i[8], :sid => self.sid_generator) 
            end
          end
          
            MailTaskMayPaymentStadusOfYourOrder.find(:first, :conditions => ['ax_account_number = ?',  'CU 0101822']).update_attribute(:email_address ,'e.stark@shawstudios.hk')            
            # get all redone that serial number in the range.
            # line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0])
            # delivered = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical = ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0]).map(&:sales_item_reservation_number)
            # losted = (Delivery_range_begin..Delivery_range_end).map{|i|i.to_s} - line_items.map(&:sales_item_reservation_number) - delivered

            # get unique orders which include all lien_items
            # orders = line_items.map(&:ax_order).uniq.compact.select do |order|
            #   if message = order.prepare_delivery_validation
            #     open("#{RAILS_ROOT}/log/invalid_orders.log", "a+") { |file| file << "#{message}\n" }
            #     false
            #   else
            #     true
            #   end
            # end

            # collect all accounts which orders belongs to
            # accounts = orders.map(&:ax_account).uniq

            # create mail queues
            # accounts.each { |account| self.create_queue(account) }
            # 
            # puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
            # puts %(Delivered Redone serial number: [#{delivered.join(",")}].)
            # puts %(Lost Redone serial number: [#{losted.join(",")}].)
            # puts %(Amount: #{line_items.size} line_items include redone body.)
            # puts %(Amount: #{orders.size} valid and unique orders.)
            # puts %(Amount: #{accounts.size} valid and unique accounts.)
            # puts %(Amount: #{self.count} records in Mail Queue.)
            # puts %(Missing Staff assign to: #{missing_assign_to_list.join(", ")})
            # puts %(Use #{Time.now - begin_time} seconds.)
          end

          def create_queue(account)
            queue = self.new(
            :ax_order_number         => account.ax_account_number,
            :order_date              => account.account_balance,
            :ax_account_number       => account.discounts,
            :email_address           => account.email_address,
            :camerma_number          => account.first_name,
            :full_name               => account.last_name,
            :prepayments_due         => account.phone,
            :prepayments_received    => account.contact_person_email_address,
            :prepayments_needed      => account.contact_person_first_name
            )

            # # get all order line items which blongs to account.
            #       line_items = []
            #       account.ax_orders.map(&:ax_order_line_items).flatten.each do |line_item|
            #         # Validation for line item has record in products table.
            #         if message = line_item.prepare_delivery_validation
            #           open("#{RAILS_ROOT}/log/invalid_order_line_items.log", "a+") do |file|
            #             file << "#{message}\n"
            #           end
            #           next
            #         end
            #         
            #         line_items << line_items_obj.new(
            #           :ax_order_number               => line_item.ax_order_number,
            #           :confirmed_lv                  => line_item.confirmed_lv,
            #           :delivered_in_total            => line_item.delivered_in_total,
            #           :invoiced_in_total             => line_item.invoiced_in_total,
            #           :item_id                       => line_item.item_id,
            #           :item_name                     => line_item.item_name,
            #           :remain_sales_physical         => line_item.remain_sales_physical,
            #           :sales_item_reservation_number => line_item.sales_item_reservation_number,
            #           :sales_qty                     => line_item.sales_qty,
            #           :sales_unit                    => line_item.sales_unit,
            #           :price                         => line_item.price
            #         )
            #       end
            #       
            #       eval("queue.#{line_items_table_name} = line_items")

            queue.save
          end

          def missing_assign_to_list
            find(:all).select{|queue| queue.assign_to.blank? || AppConfig.CUSTOMER_STAFF[queue.assign_to].nil? }.map(&:ax_account_number)
          end

          def line_items_table_name
            "#{table_name.singularize}_line_items"
          end

          def line_items_obj
            ActiveRecord::Base.const_get(line_items_table_name.classify)
          end
        end

        # Instance methods begin here.
        def line_items
          @line_items ||= self.send(self.class.line_items_table_name)
        end

        def deliverable_redone
          line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number IN (?)', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)], :order => 'sales_item_reservation_number ASC')
        end

        def deliverable_redone_complete?
          deliverable_redone.map(&:remain_sales_physical).inject(&:+) <= 0
        end

        def deliverable_redone_quantity
          deliverable_redone.size
        end

        def deliverable_redone_unit_price
          17500.0
        end

        def deliverable_redone_subtotal
          deliverable_redone_quantity * deliverable_redone_unit_price
        end

        def undeliverable_redone
          line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number NOT IN (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0], :order => 'sales_item_reservation_number ASC')
        end

        def deliverable_assembly_list
          list = []
          line_items.find(:all, :conditions => ['item_id <> ?', '101001'], :order => 'item_id ASC').each do |line_item|
            # Skip line_item which has already delivered.
            next if line_item.remain_sales_physical <= 0

            item = list.find{|i| i.item_id == line_item.item_id}
            if item
              item.remain_sales_physical += line_item.remain_sales_physical
            else
              list << line_item
            end
          end
          return list
        end

        def deliverable_assembly
          @deliverable_assembly_list ||= deliverable_assembly_list
        end

        def deliverable_assembly_subtotal
          return 0.0 if deliverable_assembly.empty?
          deliverable_assembly.map{ |item| item.price * item.remain_sales_physical }.inject(&:+)
        end

        def complete_subtotal
          deliverable_redone_subtotal + deliverable_assembly_subtotal
        end

        def deposits
          account_balance.nil? ? 0.0 : account_balance
        end

        def available_credits
          deliverable_redone_quantity * DISCOUNT_PRE_CEMERA
        end

        def credits
          case
          when deliverable_assembly_subtotal == 0 then 0.0
          when available_credits >= deliverable_assembly_subtotal then deliverable_assembly_subtotal
          else
            available_credits
          end
        end

        def all_credited?
          available_credits == credits
        end

        def shipping_charges
          if self.delivery_country_region_id == "US"
            deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_IN_US
          else
            deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_OUT_US
          end
        end

        def sales_tax_state_name
          if self.delivery_country_region_id == "US"
            case self.delivery_state
            when "WA" then return "Washington"
            when "CA" then return "California"
            end
          end

          return ""
        end

        def sales_tax
          tax = 0.0
          if self.delivery_country_region_id == "US"
            case self.delivery_state
            when "WA" then tax = 9.50
            when "CA" then tax = 8.85
            end
          end

          (complete_subtotal - credits) * (tax * 0.01)
        end

        def total_due
          # complete_subtotal - deposits - credits + shipping_charges + sales_tax
          self.prepayments_due
        end

        def bill_to_name
          self.name
        end

        def bill_to_address
          case
          when !self.invoice_address.blank? then self.invoice_address
          when !self.address.blank? then self.address
          end
        end

        def ship_to_name
          case
          when !self.contact_person_name.blank? then self.contact_person_name
          when !self.name.blank? then self.name
          end
        end

        def ship_to_address
          case
          when !self.delivery_address.blank? then self.delivery_address
          end
        end

        def staff_email_address
          email_address = AppConfig.CUSTOMER_STAFF[assign_to]
          email_address ? email_address : "sales@red.com"
        end

        def staff_name_with_email_address
          # if AppConfig.CUSTOMER_STAFF[assign_to]
          #       "#{assign_to} <#{AppConfig.CUSTOMER_STAFF[assign_to]}>"
          #     else
          #       "RED <sales@red.com>"
          #     end
          "RED <orders@red.com>"
        end
        #需要修改 
        def send_mail
          subject = "Payment Status of Your Order"
          super({:subject => subject, :from => "RED <orders@red.com>"})
        end
      end
