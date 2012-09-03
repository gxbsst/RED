class MailTaskJuneNikonMountUpdateItem < ActiveRecord::Base
  belongs_to :mail_task
  include MailTask::General
  # has_many :mail_task_feb_nearly_ready_to_ship2_queue_line_items, :dependent => :destroy
  # 
  # Delivery_range_begin = 751
  # Delivery_range_end   = 1000
  # 
  # DISCOUNT_PRE_CEMERA               = 2500
  # SHIPPING_CHARGE_PRE_CEMERA_IN_US  = 185.29
  # SHIPPING_CHARGE_PRE_CEMERA_OUT_US = 598.49
  
  # Class methods begin here.
  class << self
    def init_queues
      begin_time = Time.now
      
      # Cleanup all exists records.
      [
        "TRUNCATE #{table_name}",
      ].each do |statement|
        connection.execute(statement)
      end
      
      items = [
        ['CU 0103358', 'anarabianartist@gmail.com', 'Abdalla Mohamed Ali Mohamed Z. Bastaki', 'SO-0009688'],
        ['CU 0103217', 'abnerbenaim@yahoo.com', 'Abner Benai', 'SO 0002899'],
        ['CU 0103062', 'alexsugich@mac.com', 'Alejandro Sugich-Lopez', 'SO-0004679'],
        ['CU 0102939', 'alex@hula.net', 'Alejandro Viarnes', 'SO 0004033'],
        ['CU 0102873', 'killer@mnogofilm.com', 'Alessandro Trettenero', 'SO 0002952'],
        ['CU 0102615', 'info@bmovieitalia.com', 'Andrea Biscaro', 'SO-0005649'],
        ['CU 0102439', 'am@wunderwerk.at', 'Andreas Margreiter', 'SO 0003367'],
        ['CU 0102325', 'muzzlefish@gmail.com', 'Andrew Timlin', 'SO-0005700'],
        ['CU 0102323', 'aparis@sysmicfilms.com', 'Arnaud Paris', 'SO 0003535'],
        ['CU 0102320', 'aparis@sysmicfilms.com', 'Arnaud Paris', 'SO-0008980'],
        ['CU 0102274', 'fireforce@fireforce.com', 'Arne Busch', 'SO-0005172'],
        ['CU 0102124', 'axel@digital-arts.net', 'Axel Ericson', 'SO-0004719'],
        ['CU 0102083', 'axel@magnamana.com', 'Axel Mertes', 'SO-0004556'],
        ['CU 0101985', 'DDDDEI@hotmail.com', 'Babu Kantamneni', 'SO-0006638'],
        ['CU 0101681', 'penfever@gmail.com', 'Benjamin Feuer', 'SO-0004636'],
        ['CU 0101622', 'billg201@sio.midco.net', 'Bill Goehring', 'SO 0002615'],
        ['CU 0101620', 'clonboofilms@eircom.net', 'Billy McCannon', 'SO-0009244'],
        ['CU 0101617', 'barabjorn@gmail.com', 'Bjorn Ofeigsson', 'SO 0003887'],
        ['CU 0101615', 'brana@aatalanta.si', 'Branislav Srdic', 'SO-0006812'],
        ['CU 0101612', 'nodebased@gmail.com', 'Brett Keyes', 'SO-0005858'],
        ['CU 0101607', 'bryan.hd@gmail.com', 'Bryan Cloninger', 'SO-0006901'],
        ['CU 0101600', 'CArlorho@gmail.com', 'Carlo Rho', 'SO 0002874'],
        ['CU 0101587', 'thecompany@thecompany.dk', 'Claus Frandsen', 'SO-0005127'],
        ['CU 0101584', 'conorbongo@yahoo.com', 'Conor Ryan', 'SO-0006338'],
        ['CU 0101581', 'c.silveri@e-motion.tv', 'Corrado Silveri', 'SO-0004698'],
        ['CU 0101572', 'cory@alieanna.com', 'Cory Strassburger', 'SO-0005670'],
        ['CU 0101562', 'bowmanc@shaw.CA', 'Craig Bowman', 'SO 0003850'],
        ['CU 0101562', 'planetearth@sympatico.ca', 'Dale Hildebrand', 'SO-0006112'],
        ['CU 0101560', 'dale.launer@gte.net', 'Dale Launer', 'SO 0000264'],
        ['CU 0101553', 'awalker@599productions.com', 'Dale Storz', 'SO-0006885'],
        ['CU 0101552', 'damien@earthling-prod.net', 'Damien Molineaux', 'SO-0005774'],
        ['CU 0101551', 'djones@visionon.com', 'David Lee Jones', 'SO-0004433'],
        ['CU 0101550', 'david@litchfieldmedia.co.uk', 'David Litchfield', 'SO-0005543'],
        ['CU 0101547', 'denis@nutracore.com', 'Denis Betsi', 'SO 0000335'],
        ['CU 0101520', 'cineditor@gmail.com', 'Denis Guskov', 'SO-0005620'],
        ['CU 0101517', 'derek@allinone-usa.com', 'Derek Wan', 'SO-0008022'],
        ['CU 0101515', 'killbillfast@aol.com', 'Dimitris Rentzis', 'SO 0002548'],
        ['CU 0101506', 'echauvin@blackpoolstudios.com', 'Eric Chauvin', 'SO 0000391'],
        ['CU 0101500', 'maciver@madmojo.com', 'Eric Maciver', 'SO-0007186'],
        ['CU 0101493', 'felixlajeunesse@videotron.CA', 'Felix Lajeunesse', 'SO-0006971'],
        ['CU 0101489', 'fernandofrocha@iol.pt', 'Fernando Rocha', 'SO 0002870'],
        ['CU 0101487', 'florian.iacobucci@chello.at', 'Florian Iacobucci', 'SO-0005934'],
        ['CU 0101483', 'francisco@movicrecords.com', 'Francisco Lobo', 'SO-0005061'],
        ['CU 0101474', 'gabbeaud@hotmail.com', 'Gabriel Beaudry', 'SO-0005488'],
        ['CU 0101467', 'themusic@mac.com', 'Gabriel Cowan', 'SO-0005595'],
        ['CU 0101456', 'georg@lodgerfilms.com', 'Georg Kallert', 'SO-0006389'],
        ['CU 0101441', 'info@hdargentina.com', 'Gonzalo Rodriquez Bubis', 'SO-0005486'],
        ['CU 0101432', 'storm35mm@hotmail.com', 'Greg Stanford', 'SO-0005069'],
        ['CU 0101430', 'greg@eyecut.net', 'Greg Stroud c/o Stephen Mann', 'SO-0006006'],
        ['CU 0101426', 'helge@yellowfilm.no', 'Helge Tjelta', 'SO-0007353'],
        ['CU 0101424', 'omen@venom.hr', 'Hrvoje Simic', 'SO-0006038'],
        ['CU 0101423', 'hwanwook_kim@hotmail.com', 'Hwan-Wook Kim', 'SO-0006019'],
        ['CU 0101414', 'ianfstewart@ya.com', 'Stewart Juan Ian Fernando', 'SO-0006062'],
        ['CU 0101410', 'iansun@sympatico.CA', 'Ian Faguharson', 'SO 0000509'],
        ['CU 0101409', 'propaganda@deadworkers.com', 'J.D. Frey', 'SO-0004361'],
        ['CU 0101408', 'jacob@scootermedia.no', 'Jacob Hultgren', 'SO 0003474'],
        ['CU 0101404', 'jrv2@cornell.edu', 'Jaime Valles', 'SO-0006641'],
        ['CU 0101403', 'james@postfactory.co.uk', 'James Milner-Smyth', 'SO 0001660'],
        ['CU 0101389', 'jared@pixelchefmedia.com', 'Jared Vanleuven', 'SO-0007063'],
        ['CU 0101386', 'jbognacki@gmail.com', 'Jason Bognacki', 'SO-0006932'],
        ['CU 0101385', 'motojay@gmail.com', 'Jay Schweitzer', 'SO-0006346'],
        ['CU 0101365', 'ingevall@ebh.dk', 'Jens Ingevall', 'SO-0005076'],
        ['CU 0101364', 'cexton@comcast.net', 'Jim Exton', 'SO-0004828'],
        ['CU 0101362', 'js@jochenschmidt.de', 'Jochen Schmidt-Hambrock', 'SO 0002825'],
        ['CU 0101356', 'joebiscotti@gmail.com', 'joe Biscotti', 'SO-0005188'],
        ['CU 0101350', 'j@bigsmile.com', 'Joel Klandrud', 'SO-0007029'],
        ['CU 0101344', 'johnfiege@gmail.com', 'John Fiege', 'SO-0006052'],
        ['CU 0101341', 'john@jchalfant.com', 'John George Chalfant', 'SO-0005712'],
        ['CU 0101336', 'marktoia@zoomfilmtv.com.au', 'Mark Toia', 'SO-0005329'],
        ['CU 0101331', 'josteen@mac.com', 'John Osteen', 'SO-0004930'],
        ['CU 0101329', 'jribarich@gmail.com', 'John Ribarich', 'SO-0005005'],
        ['CU 0101327', 'latuerca@mac.com', 'Jorge Yair Leyva Robles', 'SO-0005625'],
        ['CU 0101324', 'justin83d@yahoo.com', 'Justin Kirchhoff', 'SO-0007960'],
        ['CU 0101316', 'massengill@att.net', 'Ken Massengill', 'SO 0002901'],
        ['CU 0101315', 'massengill@att.net', 'Ken Massengill', 'SO-0007254'],
        ['CU 0101310', 'kmichael@codekraft.com', 'Kenn Michael', 'SO-0008606'],
        ['CU 0101309', 'beardyweirdy@mac.com', 'Kevin White', 'SO 0000689'],
        ['CU 0101304', 'mark@tellavision.CA', 'Kris Wood', 'SO 0004045'],
        ['CU 0101299', 'kurt@222films.com', 'Kurt Branstetter', 'SO-0005423'],
        ['CU 0101298', 'zzyyzzxx2@msn.com', 'Lamon H. Jewett', 'SO-0008742'],
        ['CU 0101292', 'larconx@aol.com', 'Larry Confino', 'SO 0000709'],
        ['CU 0101290', 'naudir@gmail.com', 'Lee Jong-hoon', 'SO 0000715'],
        ['CU 0101279', 'luCAsvideo@gmail.com', 'LuCAs Solomon', 'SO-0006977'],
        ['CU 0101276', 'rental@eye-lite.com', 'Philip Mahieu', 'SO-0004633'],
        ['CU 0101273', 'ostoja@ebh.pl', 'Maciej Ostoja-Chyzynski', 'SO-0006831'],
        ['CU 0101271', 'maheelrp@dcinemanetworks.com', 'Maheel R. Perera', 'SO-0005941'],
        ['CU 0101269', 'markus@filmfatale.com', 'Markus Stromquist', 'SO-0005443'],
        ['CU 0101268', 'mike@zinner.org', 'Michael G. Zinner', 'SO-0008354'],
        ['CU 0101264', 'mansouri@mac.com', 'Michael Mansouri', 'SO-0007104'],
        ['CU 0101243', 'journeyfilm@yahoo.com', 'Michael N Thornton', 'SO-0005775'],
        ['CU 0101242', 'blindinglight@gmail.com', 'Michael Scott', 'SO-0007736'],
        ['CU 0101239', 'mwvl@aol.com', 'Michael Van Laanen', 'SO-0008077'],
        ['CU 0101225', 'mickvanrossum@mac.com', 'Mick Van Rossum', 'SO-0008429'],
        ['CU 0101221', 'mitakura@jp.seika.com', 'Masayuki Itakura', 'SO 0003654'],
        ['CU 0101220', 'mikebudde@hotmail.com', 'Mike Budde', 'SO-0006925'],
        ['CU 0101216', 'mikedcurtis@mac.com', 'Mike Curtis', 'SO-0005288'],
        ['CU 0101210', 'mpallikonda@gmail.com', 'Murali Pallikonda', 'SO-0005542'],
        ['CU 0101210', 'nsorbara@mac.com', 'Nicholas Sorbara', 'SO 0003185'],
        ['CU 0101207', 'osk@norvidit.no', 'Olav Skogoy', 'SO-0007701'],
        ['CU 0101195', 'oztinato@gmail.com', 'Osler Go', 'SO-0004652'],
        ['CU 0101191', 'LHfactor@aol.com', 'Paul Hickey', 'SO-0006951'],
        ['CU 0101171', 'sopesan@gmail.com', 'Pedro Sandoval Espinosa', 'SO-0005071'],
        ['CU 0101161', 'pennywatier@psps.com', 'Penny Watier', 'SO-0005857'],
        ['CU 0101159', 'pierre@evergreenfilms.com', 'Pierre De Lespinois', 'SO-0006208'],
        ['CU 0101158', 'ralphmadison@hotmail.com', 'Ralph Madison', 'SO-0006030'],
        ['CU 0101153', 'rrdirect@pipeline.com', 'Ralph Toporoff', 'SO-0006442'],
        ['CU 0101151', 'flynn.imageray@gmail.com', 'Raymond Flynn', 'SO-0006757'],
        ['CU 0101149', 'rgdfilms@gmail.com', 'Richard Darge', 'SO-0007730'],
        ['CU 0101148', 'hdfilm@bresnan.net', 'Richard L. Maney', 'SO-0005485'],
        ['CU 0101146', 'rlpdesign@mac.com', 'Richard Peterson', 'SO-0008120'],
        ['CU 0101138', 'bennettrxrep@mac.com', 'Rob Bennett', 'SO-0007038'],
        ['CU 0101128', 'christian@christianswegal.com', 'Robert Henry', 'SO-0005650'],
        ['CU 0101126', 'rwt2@mac.com', 'Robert Torrance', 'SO 0001031'],
        ['CU 0101125', 'streetlightcinema@gmail.com', 'Rod Bradley', 'SO-0005733'],
        ['CU 0101121', 'rd@polifi.com', 'Ryan Damm', 'SO-0006100'],
        ['CU 0101117', 'ryleyfogg@gmail.com', 'Ryley Fogg', 'SO-0005462'],
        ['CU 0101112', 'scott@atmospherepictures.com', 'Scott Colthorp', 'SO-0005280'],
        ['CU 0101106', 'mail@scramer.com', 'Sebastian Cramer', 'SO 0003047'],
        ['CU 0101105', 'malviux@yahoo.fr', 'Sebastian Zurita', 'SO-0005584'],
        ['CU 0101104', 'senad@fabrika.com', 'Senad Zaimovic', 'SO 0003755'],
        ['CU 0101098', 'shaun.au@gmail.com', 'Shaun Au', 'SO-0006418'],
        ['CU 0101092', 'shawnwiththewind@gmail.com', 'Shawn McCArty', 'SO-0008453'],
        ['CU 0101090', 'abc@tempesttech.com', 'Shawn Peterson', 'SO-0009834'],
        ['CU 0101086', 'stevesherrick@mac.com', 'Steve Sherrick', 'SO-0006887'],
        ['CU 0101082', 'steve@brandspank.com', 'Steve Thomson', 'SO-0005525'],
        ['CU 0101081', 'parker@foveanpictures.com', 'Steven Parker', 'SO 0001135'],
        ['CU 0101072', 'sunshinesmind@hotmail.com', 'Sunshine Whitton', 'SO-0005319'],
        ['CU 0101065', 'tdw@digitalauteur.com', 'Thomas D. Weeks', 'SO 0001150'],
        ['CU 0101060', 'tommychock@gmail.com', 'Thomas Takemoto-chock', 'SO-0004700'],
        ['CU 0101058', 'info@timeslicefilms.com', 'Tim MacMillan', 'SO-0007576'],
        ['CU 0101056', 'tmorten@savagegames.com', 'Tim Morten', 'SO-0006131'],
        ['CU 0101049', 'cinemano@gmail.com', 'Tim Stoll', 'SO-0007135'],
        ['CU 0101039', 'tims@blacklistfilm.com', 'Tims Johnson', 'SO-0005676'],
        ['CU 0101038', 'creativeshopper@gmail.com', 'Vincent K Lucero', 'SO 0003520'],
        ['CU 0101030', 'veugene@gmail.com', 'Vladimir Eugene', 'SO-0007106'],
        ['CU 0101026', 'vol_k@1plus1.net', 'Volodymyr Kozhuhov', 'SO-0005828'],
        ['CU 0101025', 'bill.chapman@turner.com', 'William Chapman', 'SO-0008314'],
        ['CU 0101022', 'wlange@whoi.edu', 'William N. Lange', 'SO 0001234'],
        ['CU 0101020', 'wlange@whoi.edu', 'William N. Lange', 'SO-0008725'],
        ['CU 0101019', 'zakforrest@mac.com', 'Zak Forrest', 'SO 0000109'],
        ['CU 0101017', 'chas@runjumpfly.net', 'charles perkins', 'SO-0006233'],
        ['CU 0101014', 'seth@chaoticpictures.com', 'Seth Larney', 'SO-0006659'],
        ['CU 0101007', 'soupechaude@yahoo.fr', 'Mathieu Bergeron', 'SO-0007092'],
        ['CU 0101004', 'info@cinedigitalcanarias.com', 'Daniel Martos Neuman', 'SO 0003069'],
        ['CU 0101003', 'rm@ricardomehedff.com', 'Ricardo Mehedff', 'SO 0003622'],
        ['CU 0100979', 'lzamba@gmail.com', 'Ladislav Zamba', 'SO-0006304'],
        ['CU 0100970', 'djfml@bigpond.com', 'David Limpus', 'SO-0006285'],
        ['CU 0100962', 'slicht@bfpe.org', 'Sonja Licht', 'SO-0006177'],
        ['CU 0100956', 'office@wildruf.com', 'Lucas Riccabona', 'SO-0006237'],
        ['CU 0100953', 'cam@filmnorth.tv', 'Cameron McGrath', 'SO-0006332'],
        ['CU 0100941', 'shields@suedeproductions.ca', 'Cameron Hucker', 'SO-0006287'],
        ['CU 0100939', 'michael@sonne.dk', 'Michael Sonne', 'SO-0007236'],
        ['CU 0100934', 'zorie@cinemavajra.com', 'Zorie Barber', 'SO-0007929'],
        ['CU 0100927', 'albert@yayofilms.com', 'Albert Rudnicki', 'SO 0003541'],
        ['CU 0100923', 'info@srfilm.tv', 'John Rosenlund', 'SO-0008685'],
        ['CU 0100915', 'timtenten@comcast.net', 'Timothy Herpel', 'SO-0007933'],
        ['CU 0100911', 'kward@kennanward.com', 'Kennan Ward', 'SO 0001331'],
        ['CU 0100908', 'agaillard@artbeats.com', 'Laura Hollifield', 'SO-0006243'],
        ['CU 0100898', 'kgordoninc@aol.com', 'Kevin Gordon', 'SO 0001442'],
        ['CU 0100890', 'rion@5ive.ca', 'Rion Gonzales', 'SO-0006395'],
        ['CU 0100887', 'jsipola@uiah.fi', 'PEKKA J SIPOLA', 'SO-0008839'],
        ['CU 0100884', 'zebu99@hotmail.com', 'william mitchell', 'SO 0001352'],
        ['CU 0100883', 'Alex@HDArizona.com', ' Alexander Mitchell', 'SO-0007397'],
        ['CU 0100881', 'niki@onair2.com', 'Alessio Niki Petrucci', 'SO-0006381'],
        ['CU 0100880', 'dan@mpintl.us', 'Dan McCain', 'SO-0006336'],
        ['CU 0100874', 'wedowee@hotmail.com', 'Jim Burnworth', 'SO-0006996'],
        ['CU 0100866', 'PeterRichardson1@gmail.com', 'Peter Richardson', 'SO-0008234'],
        ['CU 0100861', 'briankaz@idsmedia.net', 'Brian Kazmierczak', 'SO-0006888'],
        ['CU 0100854', 'imaxys@noos.fr', 'Antoine Trebouta', 'SO-0006490'],
        ['CU 0100854', 'eaglepro@yahoo.com', 'Larry McKee', 'SO 0001463'],
        ['CU 0100852', 'erik@tcsfilm.com', 'Erik Schietinger', 'SO-0008660'],
        ['CU 0100845', 'papacy@pacbell.net', 'Brian Pope', 'SO 0001374'],
        ['CU 0100844', 'tcduran@hotmail.com', 'Timothy Duran', 'SO 0003108'],
        ['CU 0100841', 'postoffice@15elm.com', 'Post Office Editorial', 'SO-0007220'],
        ['CU 0100815', 'msvp@mac.com', 'Mark Tyson', 'SO-0007923'],
        ['CU 0100814', 'ziadoakes@mac.com', 'Ziad Oakes', 'SO-0005908'],
        ['CU 0100812', 'info@banzaistudio.tv', ' Banzai', 'SO-0006742'],
        ['CU 0100810', 'dmacleod@sympatico.ca', 'Dylan Macleod', 'SO-0006615'],
        ['CU 0100805', 'gregariousdaze@yahoo.com', 'Jeff Dotherrow', 'SO 0001617'],
        ['CU 0100801', 'carew@gol.com', 'Daniel Carew', 'SO-0006796'],
        ['CU 0100791', 'victor_t@cinemotion.bg', 'Victor Trichkov', 'SO-0007007'],
        ['CU 0100790', 'gabicam@mac.com', 'Gabriel Camargo', 'SO 0001625'],
        ['CU 0100787', 'aoug77@dsl.pipex.com', 'Bodhisattva Productions Ltd', 'SO-0006797'],
        ['CU 0100785', 'vj1156@yahoo.co.uk', 'Victor Jokov', 'SO 0001626'],
        ['CU 0100765', 'mylrea@gmail.com', 'Drew Mylrea', 'SO-0006723'],
        ['CU 0100764', 'dmiller@tunvision.com', 'Dennis Miller', 'SO 0001554'],
        ['CU 0100762', 'scanfilm@iinet.net.au', 'Viv Scanu', 'SO-0008474'],
        ['CU 0100755', 'spectral@otenet.gr', 'Nicos Ambatzis', 'SO-0006279'],
        ['CU 0100754', 'carl@schrom.com', 'Carl Sturges', 'SO-0006767'],
        ['CU 0100753', 'raphlou@gmail.com', 'Michel BENSADOUN', 'SO 0001427'],
        ['CU 0100744', 'sottykat@yahoo.com', 'Tropnet Marketing LLC', 'SO-0006675'],
        ['CU 0100735', 'jesper@fasad.se', 'Jesper Ganslandt', 'SO-0006676'],
        ['CU 0100733', 'dvvillage@hotmail.com', 'Chris Parker', 'SO-0006854'],
        ['CU 0100718', 'hobi@hobi.se', 'Hobi Jarne', 'SO 0003690'],
        ['CU 0100715', 'rservera@aquafilms.com.ar', 'Roberto Servera', 'SO-0006699'],
        ['CU 0100711', 'julianbanos@gmail.com', 'Julian Banos', 'SO-0007449'],
        ['CU 0100705', 'i.baselga@ceproma.com', 'Jose Ignacio Baselga', 'SO-0006955'],
        ['CU 0100699', 'johnterendy@yahoo.com', 'John Terendy', 'SO 0001551'],
        ['CU 0100697', 'nikolai@renew.ru', 'Nikolai Pigarev', 'SO-0006868'],
        ['CU 0100693', 'shalomhunan@hotmail.com', 'Jesse Cook', 'SO-0007981'],
        ['CU 0100685', 'ttweeten@omnikino.com', 'Trevor Tweeten', 'SO-0004605'],
        ['CU 0100677', 'office@sif309.com', 'Borislav Chouchkov', 'SO-0007003'],
        ['CU 0100675', 'pacmotor@gte.net', 'Shawn Fields', 'SO-0006789'],
        ['CU 0100669', 'orders@rageproductions.com', 'Rage Productions', 'SO-0006729'],
        ['CU 0100647', 'brad@indigocreativeinc.com', 'Brad Palmer', 'SO-0006957'],
        ['CU 0100646', 'pryczko@mac.com', 'Arkadiy Ugorskiy', 'SO-0008557'],
        ['CU 0100643', 'martin@noweck.net', 'Martin Noweck', 'SO-0006943'],
        ['CU 0100631', 'VahePapaz@aol.com', 'Vahe Papazyan', 'SO 0001349'],
        ['CU 0100624', 'km9000@gmail.com', 'keith morris', 'SO-0009097'],
        ['CU 0100614', 'TimPipher@gmail.com', 'Timothy A Pipher', 'SO-0007429'],
        ['CU 0100610', 'TimPipher@gmail.com', 'Timothy A Pipher', 'SO-0007488'],
        ['CU 0100604', 'shaun@twoc.ca', 'Shaun Mavronicolas', 'SO-0009458'],
        ['CU 0100603', 'dexter_gregoire@hotmail.com', 'DEXTER GREGOIRE', 'SO-0009023'],
        ['CU 0100602', 'patterson@cte.usf.edu', 'William Patterson', 'SO-0007335'],
        ['CU 0100601', 'filmaker777@hotmail.com', 'Carl Ackerman', 'SO-0008653'],
        ['CU 0100598', 'pablo@pablovallejo.com', 'Pablo Vallejo', 'SO-0007357'],
        ['CU 0100596', 'electrolift@hotmail.com', 'David Bossie', 'SO 0002633'],
        ['CU 0100590', 'eugene@eugenewei.com', 'Eugene Wei', 'SO 0002634'],
        ['CU 0100587', 'amperture.motion.pictures@gmail.com', 'Edward Semaan', 'SO 0003046'],
        ['CU 0100580', 'digicomvideo@digicomvideo.com', 'Michael Descheneaux', 'SO-0007742'],
        ['CU 0100545', 'miroslav.janura@avistudio.sk', 'Miroslav Janura', 'SO-0007239'],
        ['CU 0100517', 'melani.zerrudo@wetdesign.com', 'Maria Villamil', 'SO 0002661'],
        ['CU 0100516', 'monev@skynet.be', 'Freddy Van Dam', 'SO 0002663'],
        ['CU 0100515', 'Mike@cmrStudios.net', 'Mike Weber', 'SO 0002665'],
        ['CU 0100512', 'atf@cepheusfilms.com', 'Andrew Foster', 'SO-0006390'],
        ['CU 0100497', 'cris.b@mac.com', 'Cris Blyth', 'SO 0002683'],
        ['CU 0100492', 'don@hamiltonstudio.com', 'Donald W. Hamilton', 'SO 0002686'],
        ['CU 0100490', 'thomas.brun@tpcag.ch', 'thomas brun', 'SO 0002698'],
        ['CU 0100486', 'chen@vcih.com', 'Wensean Chen', 'SO 0002754'],
        ['CU 0100485', 'percy@digitalmagic.com.hk', 'Percy Fung', 'SO 0002705'],
        ['CU 0100478', 'adelemromanski@yahoo.com', 'Adele Romanski', 'SO-0008915'],
        ['CU 0100470', 'jbrun@capitolcreek.com', 'James Brundige', 'SO 0002718'],
        ['CU 0100467', 'geir@monitormagasin.no', 'Geir Bergersen', 'SO 0002722'],
        ['CU 0100467', 'coyne113@yahoo.com', 'christopher coyne', 'SO-0007211'],
        ['CU 0100451', 'davebernstein@mindspring.com', 'David J Bernstein', 'SO 0003330'],
        ['CU 0100443', 'panos@panoscosmatos.com', 'Panos Cosmatos', 'SO-0008537'],
        ['CU 0100434', 'kalbach@artichokepro.com', 'Paul Kalbach', 'SO-0007258'],
        ['CU 0100431', 'cato.cato@sbcglobal.net', 'cato Weathersoop', 'SO-0009116'],
        ['CU 0100426', 'rculpepper@sfasu.edu', 'Rob Culpepper', 'SO-0008546'],
        ['CU 0100423', 'hjsmkv@mac.com', 'Howard J Smith', 'SO 0002761'],
        ['CU 0100421', 'vitzthum@nhb.de', 'Michael Vitzthum', 'SO-0007179'],
        ['CU 0100409', 'tuki@jencquel.net', 'Braulio Rodriguez/Jurgen Jencquel', 'SO-0007292'],
        ['CU 0100407', 'dave@turningforward.com', 'David Frank', 'SO 0002776'],
        ['CU 0100406', 'renrel@aol.com', 'rich Lerner', 'SO 0002781'],
        ['CU 0100400', 'derth@earthlink.net', 'Derth Adams', 'SO-0008863'],
        ['CU 0100393', 'chosei@funahara.com', 'Chosei Funahara', 'SO 0002788'],
        ['CU 0100385', 'george@planetbillard.com', 'George Billard', 'SO 0002810'],
        ['CU 0100380', 'John@johnallardice.com', 'John Allardice', 'SO 0002818'],
        ['CU 0100377', 'mantra_33@hotmail.com', 'Michelle Sainz Castro', 'SO 0002822'],
        ['CU 0100371', 'fass@greenhosp.org', 'Daniel E Fass', 'SO 0002843'],
        ['CU 0100361', 'hansgdaun@talentdev.ch', 'Hans-Georg Daun', 'SO-0007616'],
        ['CU 0100359', 'videoconsulting@mac.com', 'tony bacak', 'SO 0002853'],
        ['CU 0100358', 'darekjot@tps.com.pl', 'Dariusz Jankowski', 'SO 0002854'],
        ['CU 0100350', 'clay@haskellfilms.com', 'Clayton Haskell', 'SO-0009010'],
        ['CU 0100349', 'gastonfazio@gmail.com', 'Carlos Gaston Fazio', 'SO 0003858'],
        ['CU 0100347', 'r_k@mac.com', 'ryota kurata', 'SO-0008192'],
        ['CU 0100342', 'ecamarena@alazraki2020.com', 'Eduardo CmenPez', 'SO 0002878'],
        ['CU 0100334', 'patrick_wynne@hotmail.com', 'patrick wynne', 'SO-0006877'],
        ['CU 0100319', 'nick@alchemyfilms.net', 'Nick Davidson', 'SO 0002885'],
        ['CU 0100318', 'adnan@arthur.ba', 'adnan huremovic', 'SO-0007313'],
        ['CU 0100310', 'david@davidfortney.com', 'David Fortney', 'SO 0002896'],
        ['CU 0100297', 'Carroll.Sean.A@gmail.com', 'Sean Carroll', 'SO-0007687'],
        ['CU 0100286', 'baljitsinghdeo@hotmail.com', 'Baljit Singh Deo', 'SO 0003186'],
        ['CU 0100285', 'panicos@fullmoonprod.biz', 'Panicos Petrides', 'SO 0002556'],
        ['CU 0100279', 'gilleklabin@gmail.com', 'Gille Klabin', 'SO 0002560'],
        ['CU 0100273', 'alexx@proproduction.at', 'arts&multimedia hovh', 'SO 0002562'],
        ['CU 0100271', 'gian.joon@orcon.net.nz', 'Gian Joon', 'SO-0006732'],
        ['CU 0100269', 'brandon@shindigpictures.com', 'Brandon Fraley', 'SO 0002968'],
        ['CU 0100261', 'ctoleti@gmail.com', 'Chakri Toleti', 'SO 0002533'],
        ['CU 0100260', 'kyk2kys@hotmail.com', 'Young Ki Kim', 'SO 0002985'],
        ['CU 0100231', 'G.DOURDAN@MAC.COM', 'GARY DOURDAN', 'SO 0003000'],
        ['CU 0100228', 'tkjdesign@charter.net', 'thomas h. clapp', 'SO 0003002'],
        ['CU 0100223', 'bjorn@ljud-bildmedia.se', 'Bjorn Thissel', 'SO-0004885'],
        ['CU 0100222', 'sugino@suginostudios.com', 'shin sugino', 'SO 0003040'],
        ['CU 0100207', 'dennis.tsamis@utoronto.ca', 'Dennis Tsamis', 'SO 0003044'],
        ['CU 0100206', 'segaunt@btinternet.com', 'Conrad Gaunt', 'SO 0003048'],
        ['CU 0100173', 'peter@klum.se', 'Peter Klum', 'SO 0002567'],
        ['CU 0100171', 'karim@jirafadigital.com.mx', 'Karim Iglesias Chacon', 'SO 0002568'],
        ['CU 0100169', 'stefanivo@gmx.de', 'Stefan Ivo', 'SO 0003056'],
        ['CU 0100168', 'ginopapineau@unasan.com', 'Gino Papineau', 'SO 0003208'],
        ['CU 0100160', 'ginopapineau@unasan.com', 'Gino Papineau', 'SO-0008641'],
        ['CU 0100158', 'hstudio@hanafos.com', 'Seung pyo Hong', 'SO 0003072'],
        ['CU 0100156', 'mikegiff@blueyonder.co.uk', 'Robert MikGiffd', 'SO 0002572'],
        ['CU 0100154', 'bengt.kruse@keyediting.se', 'Bengt Kruse', 'SO 0003087'],
        ['CU 0100146', 'email@vincentscotti.com', 'Vincent Scotti', 'SO-0008739'],
        ['CU 0100115', 'sarjuliao@gmail.com', 'Sergio Juliao', 'SO-0007869'],
        ['CU 0100110', 'marek@mmfilm.sk', 'Marek Mackovic', 'SO-0008750'],
        ['CU 0100100', 'mike@mayda.com', 'Michael A. Mayda', 'SO 0003115'],
        ['CU 0100096', 'mike@waltze.com', 'Michael Waltze', 'SO-0008634'],
        ['CU 0100085', 'yousif@flickershow.ae', 'Yousif Humaid Al-Marri', 'SO-0006683'],
        ['CU 0100082', 'williamji@sina.com', 'Weiwei Ji', 'SO 0003293'],
        ['CU 0100079', 'pistre@noos.fr', 'gabriel Pistre', 'SO 0003126'],
        ['CU 0100073', 'jean.wallez@9online.fr', 'Jean Wallez', 'SO-0007782'],
        ['CU 0100073', 'lauri.kettunen@koillismaa.fi', 'Lauri Kettunen', 'SO-0006751'],
        ['CU 0100064', 'ludwig@rental.de', 'Martin Ludwig', 'SO-0004692'],
        ['CU 0100063', 'contact@globalnetproductions.com', 'Michael Lienau', 'SO-0006479'],
        ['CU 0100062', 'greg@gregfoto.com', 'Greg Williams', 'SO 0003980'],
        ['CU 0100059', 'hmpfilms@gmail.com', 'Osler Go III', 'SO-0005811'],
        ['CU 0100058', 'mike.prevette@gmail.com', 'Mike Prevette', 'SO 0002738'],
        ['CU 0100058', 'CGrandel@ArcaneVFX.com', 'Christopher Grandel', 'SO-0006450'],
        ['CU 0100048', 'aj@bdpicture.com', 'Ajay Kamboj', 'SO-0006239'],
        ['CU 0100042', 'obin@dv3productions.com', 'obin olson', 'SO-0004621'],
        ['CU 0100037', 'koaboy@gmail.com', 'Ryo R. Miyamoto', 'SO-0005206'],
        ['CU 0100021', 'sergei@earthvideo.net', 'Sergei Franklin', 'SO-0008306'],
        ['CU 0100020', 'leon_trinidad@yahoo.com', 'Dustin McKim', 'SO-0006875'],
        ['CU 0100019', 'daveg@mmokc.com', 'David Greene', 'SO-0009509'],
        ['CU 0100010', 'sebastian@embassy.de', 'Sebastian Eberhard', 'SO-0008091'],
        ['CU 0100009', 'timurbekmambetov@mac.com', 'Timur Bekmambetov', 'SO-0008654']
        ]
        #.inject([]) do |orders,i|
        #  orders << AxOrder.find(:all, :conditions => ['ax_order_number = ?', i[3]])
        # end
        # pp items
        accounts = []
        items.each do |i|
          # order = AxOrder.find_by_ax_order_number(item.last)
          # account = ERP::Customer.find_by_account_num(i[0])
          account = ERP::SalesOrder.find_by_sales_id(i[3])
          account.customer.email = i[1]
          account.customer.name = i[2]
          
          # if account.nil?
          #          open("#{RAILS_ROOT}/log/lost_orders_id.log", "a+") { |file| file << "#{i[3]}\n" }
          #        else
            accounts << account
          # end
        end
        
        # accounts = orders.compact.map(&:ax_account)
        accounts.compact.each { |account| self.create_queue(account)}
      end
    
    def create_queue( account )
      queue = self.new(
        :ax_account_number             => account.customer.account_num,
        # :account_balance               => account.account_balance,
        # :discounts                     => account.discounts,
        :email_address                 => account.customer.email,
        :first_name                    => account.customer.name,
         :last_name                     => nil,
        # :name                         => account.customer.name,
        :phone                         => account.customer.phone,
        # :contact_person_name           => account.contact_person_name,
        # :contact_person_select_address => account.contact_person_select_address,
        # :address                       => account.address,
        # :invoice_address               => account.invoice_address,
        # :invoice_city                  => account.invoice_city,
        # :invoice_country_region_id     => account.invoice_country_region_id,
        # :invoice_state                 => account.invoice_state,
        # :invoice_street                => account.invoice_street,
        :delivery_address              => account.ship_to_address.street,
        :delivery_city                 => account.ship_to_address.city,
        :delivery_country_region_id    => account.ship_to_address.country_region_id,
        :delivery_state                => account.ship_to_address.state,
        :delivery_street               => account.ship_to_address.street,
        :assign_to                     => account.customer.assign_to,
        :sid                           => UUID.random_create.to_s.gsub(/-/,'')
      )
      
      queue.save
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
    deliverable_redone.MAP(&:remain_sales_physical).inject(&:+) <= 0
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
    line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number NOT IN (?)', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)], :order => 'sales_item_reservation_number ASC')
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
  def name
    "#{self.first_name}"
  end
  def deposits
    account_balance.nil? ? 0.0 : account_balance
  end
  
  def available_credits
    deliverable_redone_quantity * DISCOUNT_PRE_CEMERA
  end
  
  def credits
    case
    when deliverable_assembly_subtotal == 0 : 0.0
    when available_credits >= deliverable_assembly_subtotal : deliverable_assembly_subtotal
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
      when "WA" : return "Washington"
      when "CA" : return "California"
      end
    end
    
    return ""
  end
  
  def sales_tax
    tax = 0.0
    if self.delivery_country_region_id == "US"
      case self.delivery_state
      when "WA" : tax = 9.50
      when "CA" : tax = 8.85
      end
    end

    (complete_subtotal - credits) * (tax * 0.01)
  end
  
  def total_due
    complete_subtotal - deposits - credits + shipping_charges + sales_tax
  end
  
  def bill_to_name
    self.name
  end
  
  def bill_to_address
    case
    when !self.invoice_address.blank? : self.invoice_address
    when !self.address.blank? : self.address
    end
  end
  
  def ship_to_name
    case
    when !self.contact_person_name.blank? : self.contact_person_name
    when !self.name.blank? : self.name
    end
  end
  
  def ship_to_address
    case
    when !self.delivery_address.blank? : self.delivery_address
    end
  end
  
  def staff_email_address
    email_address = AppConfig.CUSTOMER_STAFF[assign_to]
    email_address ? email_address : "sales@red.com"
  end
  
  def staff_name_with_email_address
    if AppConfig.CUSTOMER_STAFF[assign_to]
      "#{assign_to} <#{AppConfig.CUSTOMER_STAFF[assign_to]}>"
    else
      "RED <sales@red.com>"
    end
  end
  
  def send_mail
    subject = "NIKON MOUNT Update"
    super({:subject => subject, :from => 'restivo@red.com'})
  end
end