class MailTaskMarNikonMountPriceAdjustmentNoticeQueue < ActiveRecord::Base
  
  include MailTask::General
  
  belongs_to :mail_task
  
  class << self
    def init_queues
      # cleanup exists queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      
      # raw date from original csv file...
      [
        ['SO 0002601','matt.wright@freehand.co.uk',1],
        ['SO 0002633','electrolift@hotmail.com',1],
        ['SO 0002634','eugene@eugenewei.com',1],
        ['SO 0002654,SO 0003045','OMNIUS@COX.NET',2],
        ['SO 0002665','mike@cmrstudios.com',1],
        ['SO 0002698','thomas.brun@tpcag.ch',1],
        ['SO 0002754','chen@vcih.com',1],
        ['SO 0002776','dave@turningforward.com',1],
        ['SO 0002781','renrel@aol.com',1],
        ['SO 0002795','Blueinfo@mac.com',1],
        ['SO 0002818','John@johnallardice.com',1],
        ['SO 0002822','mantra_33@hotmail.com',1],
        ['SO 0002824','jason@insanityfilmworks.com',1],
        ['SO 0002825','js@jochenschmidt.de',1],
        ['SO 0002761','howard@mk-v.com',1],
        ['SO 0002811','mp@threesixtyproductions.com',1],
        ['SO 0002816','dang@storylineproductions.com',1],
        ['SO 0002640','kimtheo@gmail.com',1],
        ['SO 0002683','cris.b@mac.com',1],
        ['SO 0002853','videoconsulting@mac.com',1],
        ['SO 0002854','darekjot@tps.com.pl',1],
        ['SO 0002870','fernandofrocha@iol.pt',1],
        ['SO 0002872','hani.arab@abigroup.com.au',1],
        ['SO 0002874','CArlorho@gmail.com',1],
        ['SO 0002693','S816mm35mm@aol.com',1],
        ['SO 0002898,SO-0005061','francisco@movicrecords.com',2],
        ['SO 0002899','abnerbenaim@yahoo.com',1],
        ['SO 0002901','massengill@att.net',1],
        ['SO 0002887','adnan@arthur.ba',1],
        ['SO 0002892','paul@paulrogersuk.com',1],
        ['SO 0002915','bill@sightandsoundhawaii.com',1],
        ['SO 0002916','johannperry@btinternet.com',1],
        ['SO 0002918','manuel.wenger@varicam.net',1],
        ['SO 0002703','rob@applevalleyent.com',1],
        ['SO 0002617','westbotswana@bigpond.com',1],
        ['SO 0002705','percy@digitalmagic.com.hk',2],
        ['SO 0002923','Carroll.Sean.A@gmail.com',1],
        ['SO 0002945','donatello@pacbell.net',1],
        ['SO 0002952','killer@mnogofilm.com',1],
        ['SO 0002560','gilleklabin@gmail.com',1],
        ['SO 0002955','jordan@louisianamediaservices.com',1],
        ['SO 0002968','brandon@shindigpictures.com',1],
        ['SO 0002562','alexx@proproduction.at',1],
        ['SO 0002714','mckinneybro@gmail.com',1],
        ['SO 0002985,SO 0003864','kyk2kys@hotmail.com',2],
        ['SO 0002996','MMACHOVER@CAMERASERVICE.COM',1],
        ['SO 0003330','davebernstein@mindspring.com',1],
        ['SO 0002878','ecamarena@alazraki2020.com',1],
        ['SO 0003013','daniel.monahan@gmail.com',1],
        ['SO 0003020','VahePapaz@aol.com',1],
        ['SO 0002935','chrisjemanuel@cox.net',1],
        ['SO 0003007','maarten@thumbyou.com',1],
        ['SO 0002592','daneglasgow@yahoo.com',1],
        ['SO 0003040','sugino@suginostudios.com',1],
        ['SO 0003044','dennis.tsamis@utoronto.ca',1],
        ['SO 0002567','peter@klum.se',1],
        ['SO 0003060','rick@duplimark.com',1],
        ['SO 0003069','camera@cinedigitalcanarias.com',1],
        ['SO 0002888','msteinauer@aol.com',1],
        ['SO 0002572','mikegiff@blueyonder.co.uk',1],
        ['SO 0002530','mcgeedigital@hotmail.com',1],
        ['SO 0003087','bengt.kruse@keyediting.se',1],
        ['SO 0003094','eli@techie.com',1],
        ['SO 0003280','benjamin@camcar.de',1],
        ['SO 0003098','vincepascoe@hotmail.com',1],
        ['SO 0003054','huebscher@fastmail.net',1],
        ['SO 0003102,SO 0003504','stefanivo@gmx.de',2],
        ['SO 0003103','sarjuliao@gmail.com',1],
        ['SO 0003107','contact@raphael-bauche.com',1],
        ['SO 0003108','tcduran@hotmail.com',2],
        ['SO 0003109','marek@mmfilm.sk',1],
        ['SO 0003111','tom@spitfirestudios.com',1],
        ['SO 0003115','mike@mayda.com',1],
        ['SO 0003293','williamji@sina.com',1],
        ['SO 0003126','pistre@noos.fr',1],
        ['SO 0003127','randallstowell@mac.com',1],
        ['SO 0003297','sandovaldourado@hotmail.com',1],
        ['SO 0002556','panicos@fullmoonprod.biz',1],
        ['SO 0003155','mark@markallen.net',1],
        ['SO 0003181','lawrence.chan@gmail.com',1],
        ['SO 0003185','nsorbara@mac.com',1],
        ['SO 0003186','baljitsinghdeo@hotmail.com',1],
        ['SO 0003193','vfxdubai@gmail.com',1],
        ['SO 0003307','fafawill@hotmail.com',1],
        ['SO 0003203','agogofilm@gmail.com',1],
        ['SO 0003208','ginopapineau@unasan.com',1],
        ['SO 0003311','ioannisfilm@yahoo.gr',1],
        ['SO 0003225','kontakt@loptafilm.de',1],
        ['SO 0003313,SO 0003252','olivier.madar@vecteurm.com',2],
        ['SO 0002579','egil@filmhuset.no',1],
        ['SO 0002582','arun@windsorsathyam.com',1],
        ['SO 0003241','supinan.watanakiatsun@platinum.co.th',1],
        ['SO 0003206','curtis@greyhousefilms.com',1],
        ['SO 0003245,SO 0000852','mansouri@mac.com',2],
        ['SO 0003259','mika@nerim.fr',1],
        ['SO 0002587','bombofilms@gmail.com',1],
        ['SO 0002577','shanx@cbn.net.id',1],
        ['SO 0003332','ryan@red.com',1],
        ['SO 0003345','mark.warren@adm.monash.edu.au',1],
        ['SO 0003355','ivo.tsvetkov@gmail.com',1],
        ['SO 0003358,SO 0003374','o_koeppel@yahoo.de',2],
        ['SO 0003365','sales@grapplestudios.lt',1],
        ['SO 0003367','am@wunderwerk.at',1],
        ['SO 0003371','junior@brothersfilms.com',1],
        ['SO 0003377','rmelville@ringling.edu',1],
        ['SO 0003386','sunpath@linkline.com',1],
        ['SO 0003390','arcprod@terra.es',1],
        ['SO 0003396','takhmaz@yahoo.co.uk',1],
        ['SO 0003397','jeff.glickman@suddenstorm.ca',1],
        ['SO 0003399','bradleyvance@mac.com',1],
        ['SO 0003405','mex@kth.se',1],
        ['SO 0003407','banditsfilms@gmail.com',2],
        ['SO 0003412','mickdoyle@ireland.com',1],
        ['SO 0003428','jason@jasongeorge.com',1],
        ['SO 0003443','NEVER2LATEStudios@yahoo.com',1],
        ['SO 0003461','janolav@medialab.no',1],
        ['SO 0003465','cy@karbonarc.com',1],
        ['SO 0003470','woodyhan@hotmail.com',1],
        ['SO 0003474','jacob@scootermedia.no',1],
        ['SO 0003487','jens@motionart.net',1],
        ['SO 0003495','jwebb@zilkerfilms.com',1],
        ['SO 0003498','abc.gerard@cegetel.net',1],
        ['SO 0003520','creativeshopper@gmail.com',1],
        ['SO 0003523,SO 0003527','mkl@free.fr',2],
        ['SO 0003528','mail@chrisvincze.info',1],
        ['SO 0003531','gareth-edwards@msn.com',1],
        ['SO 0003541','albert@yayofilms.com',1],
        ['SO 0003555','kevin@drawbridge.tv',1],
        ['SO 0003575','momentumtvco@yahoo.com',1],
        ['SO 0003578','witecki@mastershot.pl',1],
        ['SO 0003580','rkooris@501studios.com',1],
        ['SO 0003583','songadab1@aol.com',1],
        ['SO 0003584','adam@adamwilt.com',1],
        ['SO 0003589','sanjinjukic@yahoo.com',1],
        ['SO 0003594','owen@careyfilms.com',1],
        ['SO 0003601','tony@lorentzen.com',1],
        ['SO 0003605','mfinch56@yahoo.com',1],
        ['SO 0003613','beardyweirdy@mac.com',1],
        ['SO 0003622','ricardo@vfilmes.com',1],
        ['SO 0003626','jason@supernovafilms.com.au',1],
        ['SO 0003629','whatchadrinking@gmail.com',1],
        ['SO 0003635','buhot.denis@wanadoo.fr',1],
        ['SO 0003647','mike@mbluestone.com',1],
        ['SO 0003658','mitakura@nifty.com',1],
        ['SO 0003662','sakalli@isiproductions.com',1],
        ['SO 0003670','dolfilms@club-internet.fr',1],
        ['SO 0003672','mail@faberstudios.com',1],
        ['SO 0003678,SO 0004071','dennisone@mac.com',2],
        ['SO 0003690','hobi@hobi.se',1],
        ['SO 0003707','roland.blaser@cuenet.ch',1],
        ['SO 0003741','sunshinetom@gmail.com',1],
        ['SO 0003755','senad@fabrika.com',1],
        ['SO 0003793','G.DOURDAN@MAC.COM',1],
        ['SO 0003797','fsavoir@amazingdigitalstudios.com',1],
        ['SO 0003815','meat@mac.com',1],
        ['SO 0003825','chris@dvinfo.net',1],
        ['SO 0003838','patrick@geniusmonkeys.com',1],
        ['SO 0003841','cinenomada@mac.com',1],
        ['SO 0003850','bowmanc@shaw.CA',1],
        ['SO 0003858','gastonfazio@gmail.com',1],
        ['SO 0003865','polyakov@irecords.ru',1],
        ['SO 0003870','goodman@histories.com',1],
        ['SO 0003871','rizibo@hotmail.com',1],
        ['SO 0003874','zac@ultravioletproductions.com',1],
        ['SO 0003879','brad@videoresources.com',1],
        ['SO 0003885','pryczko@mac.com',1],
        ['SO 0003887','barabjorn@gmail.com',1],
        ['SO 0003912','bigsky@ns.sympatico.ca',1],
        ['SO 0003941','john.zubrzycki@rd.bbc.co.uk',1],
        ['SO 0003949','edecarpe@gmail.com',1],
        ['SO 0003950','navigatorstudio@mail.ru',1],
        ['SO 0003965','Sean Daniel Solowiej <solowiej@unm.edu>',1],
        ['SO 0003969','luxart@gmx.de',1],
        ['SO 0003989','daniel@graetzmedia.com',1],
        ['SO 0004005','ross@rossrichardson.com',1],
        ['SO 0003302','levan@sarke.ge',1],
        ['SO 0004011','LITEIT1@SBCGLOBAL.NET',1],
        ['SO 0004021','dpfocus@hotmail.com',1],
        ['SO 0004025','khibi@mac.com',1],
        ['SO 0004033','alex@hula.net',1],
        ['SO 0004045,SO-0005002','kris@tellavision.CA',2],
        ['SO 0004047','pete@42productions.com',1],
        ['SO 0004050','christersande@gmail.com',1],
        ['SO 0004075','DigiPix@VideoTography.com',1],
        ['SO 0004077','pierre@evergreenfilms.com',2],
        ['SO 0004101','michelgraphics@gmail.com',1],
        ['SO 0004116,SO-0004629','etiennecaron@hotmail.com',2],
        ['SO 0000883','moniCA@simplemente.net',1],
        ['SO 0004138','talal7s@hotmail.com',1],
        ['SO 0004140','sebastian@leon.se',1],
        ['SO 0004161','cmunoz@equilibriofilms.com',1],
        ['SO 0004179','SWEETAFRIKA@YAHOO.COM',1],
        ['SO 0004190','pen_sound@yahoo.co.jp',1],
        ['SO 0004191','info@simonrudholm.com',1],
        ['SO 0004193','aaronjones42@yahoo.com',1],
        ['SO 0004194','airsealand@gmail.com',1],
        ['SO 0004195','gtpurchase@hotmail.com',1],
        ['SO 0004207','john.gillies@unsw.edu.au',1],
        ['SO 0004229','gisle.sverdrup@gmail.com',1],
        ['SO 0004232','richard@richardsalazar.com',1],
        ['SO-0004244','stanley@stanleyfilms.cl',1],
        ['SO-0004261','gustavo@elcaiman-films.com',1],
        ['SO-0004278','b.loyer@saint-thomas.net',1],
        ['SO-0004285','lee@cavision.com',1],
        ['SO-0004292','tony@marvellouspictures.com',1],
        ['SO-0004296','ivfilms@gmail.com',1],
        ['SO-0004361','propaganda@deadworkers.com',1],
        ['SO-0004368','steve@steveharryman.com',1],
        ['SO-0004369','nino@delpadre.com',1],
        ['SO-0004376','guillaume@32degres.com',1],
        ['SO-0004401','CGrandel@ArcaneVFX.com',1],
        ['SO-0004412','jeffocamera@yahoo.com',1],
        ['SO-0004415,SO-0004587','sasha_malorita@yahoo.co.uk',2],
        ['SO-0004420','Quincy@linkn.net',1],
        ['SO-0004433','djones@visionon.com',2],
        ['SO-0004454','wagner@niss.no',1],
        ['SO-0004468','purchasing@colsa.com',1],
        ['SO-0004473','contact@justplay.ch',1],
        ['SO 0003047','mail@scramer.com',1],
        ['SO-0004492','ha_ngocluu@yahoo.com',1],
        ['SO-0004494','gerald.stahlmann@gmail.com',1],
        ['SO-0004501','kristianappel@mac.com',1],
        ['SO-0004526','vanroyko@gmail.com',1],
        ['SO-0004530','seb@art-com.ch',1],
        ['SO-0004538','depe@sysplex.hu',1],
        ['SO-0004540','bjorn@syndicate.se',1],
        ['SO-0004542','diazinfo@yahoo.com',1],
        ['SO-0004571','frankvfx@aol.com',1],
        ['SO-0004579','selm.fr@gmail.com',1],
        ['SO-0004605','ttweeten@omnikino.com',1],
        ['SO-0004612','eric@eyebooger.com',1],
        ['SO-0004614','latvis@swbell.net',1],
        ['SO-0004615','ranson@theujima.com',1],
        ['SO-0004621','obin@dv3productions.com',1],
        ['SO-0004627','cine_ojo@yahoo.com',1],
        ['SO-0004633','rental@eye-lite.com',1],
        ['SO-0004636','penfever@gmail.com',1],
        ['SO-0004637','karuna.moller@3.dk',1],
        ['SO-0004652','oztinato@gmail.com',1],
        ['SO-0004657','paul@advancemedia.ca',1],
        ['SO-0004661','mark.sullivan@sparkdigitalmedia.com',1],
        ['SO-0004556','axel@magnamana.com',1],
        ['SO-0004670','lennywood@mac.com',1],
        ['SO-0004671','Dennis@postproductionoffice.com',1],
        ['SO-0004672','v.grigorash@richyfilms.com',1],
        ['SO-0004675','joselmartinezdiaz@mac.com',1],
        ['SO-0004679','alexsugich@mac.com',1],
        ['SO-0004692','ludwig@rental.de',1],
        ['SO-0004698','c.silveri@e-motion.tv',1],
        ['SO-0004700','tommychock@gmail.com',1],
        ['SO-0004701','radkinternational@gmail.com',1],
        ['SO-0004735','info@phildale.net',1],
        ['SO-0004745','digitalmedia@telenet.be',1],
        ['SO 0000709','larconx@aol.com',1],
        ['SO-0004764','jerome.larnou@gmail.com',1],
        ['SO-0004765','ENGDB@aol.com',1],
        ['SO-0004768','ge.diego@gmail.com',1],
        ['SO-0004793','1405comunicaciones@speedy.com.pe',1],
        ['SO-0004801','kc@qoobee.de',1],
        ['SO-0004815','manduck2000@gmail.com',1],
        ['SO-0004820','fred@izomo.com',1],
        ['SO-0004843','josecyrne@wiseguys.pt',1],
        ['SO 0002718','jbrun@capitolcreek.com',1],
        ['SO 0003752','info@j-b.gr',1],
        ['SO-0004866','ajit@8mm.co.in',1],
        ['SO-0004885','bjorn@ljud-bildmedia.se',1],
        ['SO-0004920','andreas.sulzer@proomnia.tv',1],
        ['SO-0004930','josteen@mac.com',1],
        ['SO 0000881','popapple@mac.com',1],
        ['SO-0004943','tbird@kih.net',1],
        ['SO-0004965','seret1234@gmail.com',1],
        ['SO-0004980','angeli_tito@yahoo.gr',1],
        ['SO-0004992','contact@christopheclemendot.com',1],
        ['SO-0005005','jribarich@gmail.com',2],
        ['SO-0005012','nmitov@abv.bg',1],
        ['SO-0005033,SO-0005224','saida.medvedeva@gmail.com',2],
        ['SO-0005037','villetanttu@mac.com',1],
        ['SO-0005050','saschroth@msn.com',1],
        ['SO-0005052','gregg@mammothpro.com',1],
        ['SO-0005069','storm35mm@hotmail.com',1],
        ['SO-0005071','sopesan@gmail.com',1],
        ['SO-0005076','ingevall@ebh.dk',1],
        ['SO-0005097','isabelle.albert@umontreal.ca',1],
        ['SO-0005127','thecompany@thecompany.dk',1],
        ['SO-0005146','warren@rvimedia.com',1],
        ['SO-0004858','anders@smartfilm.se',1],
        ['SO-0005172','fireforce@fireforce.com',1],
        ['SO-0005188','joebiscotti@gmail.com',1],
        ['SO-0005191','Cinewalt@gmail.com',1],
        ['SO-0005201','tech@postfactory.co.uk',2],
        ['SO 0002548','killbillfast@aol.com',1],
        ['SO-0005206','koaboy@gmail.com',1],
        ['SO-0005214,SO-0005215','fhashiba@gmail.com',4],
        ['SO-0005221','planetearth@sympatico.ca',1],
        ['SO-0005226,SO-0005227','rr@conspira.com.br',6],
        ['SO-0005232','fabbianni@hotmail.com',1],
        ['SO-0005250','karl@storyhaus.com',1],
        ['SO-0005259','barry@fiftv.com',1],
        ['SO-0005262','maprod@otenet.gr',1],
        ['SO-0005288','mikedcurtis@mac.com',1],
        ['SO-0005313','john_bradleyimages@yahoo.com',1],
        ['SO-0005319','sunshinesmind@hotmail.com',1],
        ['SO-0005329,SO-0006060','marktoia@zoomfilmtv.com.au',4],
        ['SO-0005370','dinindu@hotmail.com',1],
        ['SO-0005378','pldc@mac.com',1],
        ['SO-0005390','jgrillomx@mac.com',1],
        ['SO-0005395','jlehmber@lee.edu',1],
        ['SO-0005414,SO-0005688','Intelkhan@hotmail.com',2],
        ['SO-0005416','tbouklas@optonline.net',1],
        ['SO-0005423','kurt@222films.com',1],
        ['SO-0005427','motives829@yahoo.com',1],
        ['SO-0005431','rafikhajiyev@gmail.com',1],
        ['SO-0005443','markus@filmfatale.com',1],
        ['SO-0005447','evi@utopiaCAm.com',1],
        ['SO-0005467','studio@vedadovision.com',1],
        ['SO-0005469','bill.chapman@turner.com',1],
        ['SO-0005476','ekuke@kubestudios.com',1],
        ['SO-0005485','hdfilm@bresnan.net',1],
        ['SO-0005486','info@hdargentina.com',1],
        ['SO-0005488','gabbeaud@hotmail.com',1],
        ['SO-0005493','jose@loasur.com',1],
        ['SO-0005535','venkataraman@realimage.com',1],
        ['SO-0005537','jsipola@taik.fi',1],
        ['SO-0005552,SO 0001013','bennettrxrep@mac.com',2],
        ['SO 0001602','benztel@yahoo.com',1],
        ['SO-0005576','mike@mytrashmail.com',9],
        ['SO-0005584','ancorafilms@free.fr',1],
        ['SO-0005592','jared@pixelchefmedia.com',1],
        ['SO-0005593','mpallikonda@gmail.com',1],
        ['SO-0005595','themusic@mac.com',1],
        ['SO-0005608','sCArley@rogers.com',1],
        ['SO-0005523','lotero@frontiernet.net',1],
        ['SO-0005611','power.lock@yahoo.com',1],
        ['SO-0005620','cineditor@gmail.com',1],
        ['SO-0005625','jorch@latuerCA.tv',1],
        ['SO-0005649','info@bmovieitalia.com',1],
        ['SO-0005650','christian@christianswegal.com',1],
        ['SO-0005654','rsip@mirage3d.nl',1],
        ['SO-0005657','aaron@studiobfilms.com',1],
        ['SO-0005676','tims@blacklistfilm.com',1],
        ['SO-0005677','marco@docsandcuts.com',1],
        ['SO 0002661','melani.zerrudo@wetdesign.com',1],
        ['SO-0005682','kreagan@bhphotovideo.com',1],
        ['SO-0005700','muzzlefish@gmail.com',1],
        ['SO 0003075','richcada@redshift.com',1],
        ['SO-0005712','john@jchalfant.com',1],
        ['SO-0005612','ross@marsprod.com',1],
        ['SO-0005733','streetlightcinema@gmail.com',1],
        ['SO-0005543','david@litchfieldmedia.co.uk',1],
        ['SO-0005760','andy@archipelagofilms.com',1],
        ['SO-0005765','michael@abiyoyoproductions.com',1],
        ['SO-0005770','lkelly010@hotmail.com',1],
        ['SO-0005771','Dave@neatapps.com',1],
        ['SO-0005774','damien@earthling-prod.net',1],
        ['SO-0005775','journeyfilm@yahoo.com',1],
        ['SO-0005800','jmh@3xplus.com',1],
        ['SO-0005801','smilingdog@telus.net',1],
        ['SO-0005804','saitom@jp.seika.com',2],
        ['SO-0005806','guivarandas@gmail.com',1],
        ['SO-0005813','marty@oppenheimerCAmera.com',2],
        ['SO-0005828','vol_k@1plus1.net',1],
        ['SO-0005835','mihow2007@mytekdigital.com',1],
        ['SO-0005839','Moemoney@bigboyz.tv',1],
        ['SO-0005280','scott@atmospherepictures.com',1],
        ['SO-0005858','nodebased@gmail.com',1],
        ['SO-0005857','pennywatier@psps.com',1],
        ['SO-0005864','ruairi@ruairirobinson.com',1],
        ['SO 0002987','jordi@iopost.cz',1],
        ['SO-0005908','ziadoakes@mac.com',1],
        ['SO-0005919','anja.soejberg@azartechnologies.com',1],
        ['SO 0000715','naudir@gmail.com',1],
        ['SO-0005922','CAmaratv@terra.es',1],
        ['SO 0001331','kward@kennanward.com',1],
        ['SO-0005928','wowholdings88@yahoo.com.hk',1],
        ['SO-0005934','florian.iacobucci@chello.at',1],
        ['SO-0005941','maheelrp@dcinemanetworks.com',1],
        ['SO-0005942','video.jason@gmail.com',1],
        ['SO-0005979','rwt2@mac.com',1],
        ['SO-0006006','greg@eyecut.net',1],
        ['SO-0006019','hwanwook_kim@hotmail.com',1],
        ['SO-0006027','dusty@sandust.com',1],
        ['SO-0006030','ralphmadison@hotmail.com',1],
        ['SO-0006038','omen@venom.hr',1],
        ['SO-0006052','johnfiege@gmail.com',1],
        ['SO-0006062','ianfstewart@ya.com',1],
        ['SO-0006073','triCAm@telia.com',1],
        ['SO-0006078','rich@sentinel-entertainment.co.za',1],
        ['SO-0006094','magicmtp@netvigator.com',2],
        ['SO-0006100','rd@polifi.com',1],
        ['SO-0006106','storm@dvshop.ca',1],
        ['SO 0000185','malms@sprintmail.com',1],
        ['SO-0006114','jared_026@hotmail.com',1],
        ['SO-0006131','tmorten@savagegames.com',1],
        ['SO-0006141','greattoe@bigpond.net.au',1]
      ].each do |r|
        ax_order_numbers = r[0]
        email_address = r[1]
        quantity = r[2]
        ax_account = AxAccount.find_by_email(email_address)
        ax_account_number = ax_account ? ax_account.ax_account_number : ""
        first_name = ax_account ? ax_account.cust_first_name : ""
        last_name = ax_account ? ax_account.cust_last_name : ""
        
        self.create(
          :ax_account_number => ax_account_number,
          :ax_order_numbers  => ax_order_numbers,
          :first_name        => first_name,
          :last_name         => last_name,
          :email_address     => email_address,
          :quantity          => quantity,
          :sid               => self.sid_generator
        )
      end
      
    end
  end
  
  def send_mail
    options = {
      :subject => "Price Adjustment Notice: Nikon Mount",
      :from    => "RED <orders@red.com>"
    }
    super(options)
  end
end