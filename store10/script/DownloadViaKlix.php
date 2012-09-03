<?php

# Table Names
$GLOBALS['TRANSACTIONS'] = "viaklix_transactions2";
$GLOBALS['BATCHES'] = "viaklix_batches2";

# Database and Viaklix Configurations...
define('DB_HOST','localhost');
define('DB_USER','root');
define('DB_PASS','ypg93ml5zkzp');
define('ACCT_ID','408748');
define('ACCT_USER','joanne');
define('ACCT_PASS','july2007');

$BAD = array(
'2E2BD841-1515-42B0-9AF1-24CCBD420FF3',
'E122665F-FE3B-49C5-8367-3C6BB98A46D9',
'6089DB7A-E8D9-4AED-9C23-4E22E7EFFCF1',
'B8C09D5D-AEE5-4DF9-9275-F5F217E0CE8F',
'B5AC13F0-A8AC-4301-A5DF-E7B5B07B3E45',
'4CA82E47-343D-41D5-8BCC-6B70E02BD5D2',
'4BE20136-0D0B-43A4-A4A5-51CE916CB1A7',
'E33A8526-BC8A-4CA8-96FB-04481FBC400C',
'2A8BD0BD-C9E4-4DE6-9B95-51D12E90F7B4',
'31C7A340-420C-43B8-852D-01790C8E9336',
'AA611F7B-52F2-4C17-8097-0BCA86523870',
'7202346E-9F11-4543-88E8-ABEA9B983EEB',
'B2648F65-5ACE-4610-AA07-98BBFA337861',
'99BE3437-6B7D-45E5-B750-628478A97261',
'2ADF68FD-DE76-4CD7-A32B-3EF784246FD1',
'0AF7897A-C677-4B3B-8203-842C9C3A1905',
'80E1B69E-9741-43B3-8822-789E05921E4D',
'1331A98E-2BDB-440A-8DA5-73DEADBB30A9',
'C79B1511-EF37-457A-AFF0-F1C74D7CC2E0',
'A5F750B0-B740-4D5A-9FFB-0982842505E1',
'F2249780-3067-4729-BB4A-398F1835B6B4',
'ADD6DE2A-59F5-44C3-9752-6BEDF908772F',
'1AD3C38E-6AE6-482D-8F0C-92E3C7B514FB',
'4F9A731B-FFA4-4685-8D22-BB12ECBA53D5',
'31E2DE02-7937-4C6E-AECC-8093AE214B17',
'304EA8AE-3FB5-499E-BFE8-76916E113BA4',
'43FF669F-1524-4A5B-A3D7-2BB0836400A6',
);


function connectDB(){
  $link = mysql_connect(constant('DB_HOST'),constant('DB_USER'),constant('DB_PASS'));
  if (!$link){
    die ("Could Not Connect To The Database");
  }
  $selected_db = mysql_select_db('store', $link);
  if (!$selected_db) {
    die ('Could Not Find Database : ' . mysql_error());
  }
  return $link;
}

function quote_smart($value, $db_link){
  $value=((get_magic_quotes_gpc())?stripslashes($value):$value);
  $value=((!is_numeric($value))?"'".mysql_real_escape_string($value, $db_link)."'":$value);
  return  strip_tags($value);
}

function post($array) {
  $vars=null;
  foreach($array as $key=>$value) {
    if($key && $value) {
      $vars.=$key."=".urlencode($value)."&";
    }
  }
  return $vars;
}

$post_data = array();
$post_data['vid'] = constant('ACCT_ID');
$post_data['uid'] = constant('ACCT_USER');
$post_data['pwd'] = constant('ACCT_PASS');
$post_data['action'] = 'Login';
$post_data['forcedpwdchange'] = 'False';
$post_data['nextpage'] = '';



$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://www2.viaklix.com/Admin/login.asp");
curl_setopt($ch, CURLOPT_REFERER, "https://www2.viaklix.com/Admin/login.asp");
curl_setopt($ch, CURLOPT_POST, TRUE);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
curl_setopt($ch, CURLOPT_COOKIESESSION, TRUE);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
curl_setopt($ch, CURLOPT_COOKIEJAR, "/tmp/cookie_jar.viaklix");
curl_setopt($ch, CURLOPT_POSTFIELDS, post($post_data) );

curl_exec($ch);
unset($post_data);
echo "Requested ViaKlix Session Login Credentials\n";

$post_data = array();
$post_data['ssl_Pin'] = 'N4SZJH';
curl_setopt($ch, CURLOPT_URL, "https://www2.viaklix.com/Admin/setterminal.asp?target=/Admin/VirtualTerminal/terminal.asp?s=1");
curl_setopt($ch, CURLOPT_POSTFIELDS, post($post_data) );
curl_exec($ch);
unset($post_data);
echo "Selected ViaKlix 'INTERNET' Terminal\n";

$post_data = array();
$post_data['PageSize'] = '1000000000';
$post_data['batchtype'] = 'CLOSED';
$post_data['s'] = '1';
$post_data['page'] = '1';
$post_data['action'] = "";
$post_data['sortfield'] = "";
$post_data['batchfilter'] = '';
# https://www2.viaklix.com/Admin/VirtualTerminal/terminal.asp?PageSize=999&page=1&action=&sortfield=&batchfilter=&batchtype=CLOSED&s=1

#curl_setopt($ch, CURLOPT_URL, "https://www2.viaklix.com/Admin/VirtualTerminal/terminal.asp?s=1");
curl_setopt($ch, CURLOPT_URL, "https://www2.viaklix.com/Admin/VirtualTerminal/terminal.asp");
curl_setopt($ch, CURLOPT_POSTFIELDS, post($post_data) );
$html_list = curl_exec($ch);
echo "Requested ViaKlix Transaction List\n";
$batch_details = array();
# "javascript:batchdetail('1844991','GBOK 00804120111','04-12-2007 01:11:06')" 
#  javascript:batchdetail('1837592','GBOK 00604100115','04-10-2007 01:15:20')
# Note that *every* item is listed twice, so be sure to only capture unique items

$batch_list = array();
preg_match_all( '/"javascript:batchdetail[^"]+"/' , $html_list, $batch_details );
foreach($batch_details[0] as $key => $val) {
  $matches = array();
  preg_match("/javascript:batchdetail\('([\d]+)','([^']+)','([^']+)'.*/", $val, $matches);
  #$settlement_number = $matches[2];
  #$batch_id = $matches[1];
  #$settlement_data = $matches[3];
  $batch_list[$matches[2]] = array( $matches[1], $matches[3] );
}

$post_data = array();
$post_data['filetype'] = 'tab-delimited';
$post_data['version'] = '2';
$post_data['qualifier'] = '0';
$post_data['batchtype'] = 'CLOSED';
$db_link = connectDB();
$q = "show fields from {$GLOBALS['TRANSACTIONS']} ";
$result = mysql_query($q, $db_link);
if (!$result) {
  die("SQL: Unable to download field list for {$GLOBALS['TRANSACTIONS']} " . mysql_error());
}
#$viaklix_table_def = mysql_fetch_assoc($result);
$i = 0;
$transaction_columns = array();
while ($row = mysql_fetch_assoc($result)){
  $c_name = $row['Field'];
  $table_fields[$c_name] = "1";
  $i++;
}
unset($i);

foreach($batch_list as $key => $val) {
  $post_data['settleid'] = $key;
  $post_data['batchid'] = $val[0]; #'1860365';
  #$post_data['settleid'] = $val[2]; #'GBOK 02004171801';

  $db_link = connectDB();
  $q = "SELECT count(*) FROM {$GLOBALS['BATCHES']} WHERE settlement_number='$key'";
  #$q = "SELECT count(*) FROM {$GLOBALS['BATCHES']} WHERE settle_id=";
  #$q .= quote_smart($post_data['settleid'], $db_link);
  #$q .= " AND batch_number=".quote_smart($post_data['batchid'], $db_link);
  $result = mysql_query($q, $db_link);
  if (!$result) {
    echo("NOTICE: SQL Problem searching for Settlement #$key\n");
    echo("Query:  $q\n");
    continue; # Skip to next record in Batch List
  }
  $row = mysql_fetch_row($result);
  if ($row[0] > 0){
    echo("NOTICE: Skipping already downloaded Settlement #$key\n");
    continue; # Very Normal! Skip...
  }
  unset($row); unset($q);

  #print $post_data['batchid'] . " => " . $post_data['settleid'] . "\n";
  curl_setopt($ch,CURLOPT_SSL_VERIFYPEER, FALSE);
  curl_setopt($ch,CURLOPT_POSTFIELDS,post($post_data) );
  curl_setopt($ch,CURLOPT_URL,"https://www2.viaklix.com/Admin/VirtualTerminal/batchdownload.klx");
  curl_setopt($ch,CURLOPT_POST,TRUE);
  echo("Downloading 3 Copies of Settlement #$key\n");
  $html = '';
  $html1 = curl_exec($ch);
  $html2 = curl_exec($ch);
  $html3 = curl_exec($ch);
  $md51 = md5($html1);
  $md52 = md5($html2);
  $md53 = md5($html3);

  # Just to be safe... Download 3 copies of *each* Settlement Report
  if ( $md51 == $md52 and $md52 == $md53 ) {
    $html = $html1;
  } else {
    echo "NOTICE: One of the 3 Settlement Files DID NOT MATCH\n";
    if ( $md51 == $md52 ) {
      $html = $html1;
    } else if ( $md51 == $md53 ) {
      $html = $html1;
    } else if ( $md52 == $md53 ) {
      $html = $html2;
    } else {
      die( "ERROR: Unable to download reliable Report Files\n" );
    }
  }

  $html_lines = explode("\r\n", $html);

  $field_names = explode("\t", $html_lines['0']);
  $unique_field_names = array();
  for($j=0;$j<=count($field_names);$j++) {
    $base_name = $field_names[$j];
    $field_name = $base_name;
    if ($base_name == false ) {
      continue; # Just grab the next record -- this one is blank
    }
    if (!strpos($field_name,'_transactionid') === false ) {
      $base_name = preg_replace('/^.*_/','',$field_name);
    }
    $i = 1;
    while(! array_search($field_name, $unique_field_names) === false) {
      $i++;
      $field_name = $field_names[$j] . $i;
      if ($i > 10) { 
        die("Problem with $field_name!");
      }
    }
    $unique_field_names[$j] = $field_name;
    $field_names[$j] = $field_name;
  }



  for($i=1; $i<count($html_lines); $i++){
    $transaction_field = explode("\t", $html_lines[$i]);
    $trash_fields = array();
    # Build Insert Values List....
    for($j=0; $j<count($transaction_field); $j++) {
      $search_key = $field_names[$j];
      if (array_key_exists($search_key, $table_fields)) {
        $values .= quote_smart($transaction_field[$j], $db_link).",";
      } else if ($j==0){
        $values .= quote_smart($transaction_field[$j], $db_link).",";
      } else {
        $trash_fields[] = $search_key;
        echo "Only Trash shows up here... right? : $search_key\n";
      }
    }
    #var_dump($field_names);
    #var_dump($trash_fields);
    #var_dump($values);
    #die();

    # Build Insert "Into" List...
    $k=1;
    $q = "INSERT INTO {$GLOBALS['TRANSACTIONS']} (";
    for ($j=0; $j<count($field_names); $j++){
      # Fix up ViaKlix Trashy Field Headers...
      if ($j=="0"){
        $field_names[$j] = preg_replace('/^[^_]+_/','',$field_names[$j]);
      } else if($field_names[$j]=="ssl_amount"){
        if ($k > 1){
          $field_names[$j] = "ssl_amount$k";
        } #end
        $k++;
      } #end

      # Concat the "insert into" string...
      if (array_key_exists($field_names[$j], $table_fields)) {
        $q .= $field_names[$j].","; 
      }
    }
    $q .= "settlement_number) ";
    $q .= "VALUES(" . $values . "'$key'" . ")";
    $result = mysql_query($q, $db_link);
    $values = "";
    if (empty($result)){
        #echo("HTML FILE...\n\n");
        #echo("$html\n\n");
        #die("SQL ERROR: $q, " . mysql_error() . "\n\n");
        print "ERROR****" .  $q . "\n";
    }
  } # Loop foreach Settlement Download Row...
  $q = "INSERT INTO {$GLOBALS['BATCHES']} ";
  $q .= "(batch_number, download_date, settlement_number) VALUES (";
  $q .= quote_smart($val[0], $db_link).",".quote_smart($val[1],$db_link).",".quote_smart($key, $db_link).")";
  #$post_data['settleid'] = $key;
  #$post_data['batchid'] = $val[0]; #'1860365';
  $result = mysql_query($q, $db_link);
  unset($q);
  $batch_id = mysql_insert_id();
}



?>
