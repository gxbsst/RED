<?php 

function insertTransactions($batch_number, $transaction, $settle_id){

    $transaction_list = str_replace("\n", "", $transaction);
    $transaction_list = explode("\r", $transaction_list);

    $db_link = connectDB();

        $q = "show fields from viaklix_transactions";
        $result = mysql_query($q, $db_link);
       
       $i = 0;
       $transaction_columns = array();
       while ($row = mysql_fetch_assoc($result)){
            $c_name = $row['Field'];
            $transaction_columns[$c_name] = "1";
            $i++;
        }
        unset($i);


#    if ($count_error){

        $q = "INSERT INTO viaklix_batches(batch_number, download_date, settle_id) VALUES (".quote_smart($batch_number, $db_link).",now(),".quote_smart($settle_id, $db_link).")";
        $result = mysql_query($q, $db_link);

        unset($q);

       $batch_id = mysql_insert_id();

    $transaction_headers = explode("\t", $transaction_list['0']);

      for($i=1; $i<count($transaction_list); $i++){
    
            $transaction_field = explode("\t", $transaction_list[$i]);
            $trash_fields = array();

            # Build Insert Values List....
            for($j=0; $j<count($transaction_field); $j++){
                $search_key = $transaction_headers[$j];
                if (array_key_exists($search_key, $transaction_columns)){
    		        $values .= quote_smart($transaction_field[$j], $db_link).",";
                } else if ($j==0){
    		        $values .= quote_smart($transaction_field[$j], $db_link).",";
                } else {
                    $trash_fields[] = $search_key;
                    #echo "Only Trash shows up here... right? : $search_key\n";
                }
            }

            # Build Insert "Into" List...
            $k=1;
            $q = "INSERT INTO viaklix_transactions(";
            for ($j=0; $j<count($transaction_headers); $j++){
                # Fix up ViaKlix Trashy Field Headers...
                if ($j=="0"){
                    $transaction_headers[$j] = str_replace($batch_number."_", "", $transaction_headers[$j]);
                } else if($transaction_headers[$j]=="ssl_amount"){
                    if ($k=="2"){
                        $transaction_headers[$j] = "ssl_amount2";
                    }else {
                        $k++;
                    }
                }

                # Concat the "insert into" string...
                if (array_key_exists($transaction_headers[$j], $transaction_columns)) {
                    $q .= $transaction_headers[$j].","; 
                }
            }

            $q .= "batch_id) ";
            $q .= "VALUES(" . $values .$batch_id . ")";


        $insert_transaction = mysql_query($q, $db_link);
        $values = "";
        if (empty($insert_transaction)){
            print "****" .  $q . "\n";
        }
        
       }
    return true;
}

function connectDB(){

    $link = mysql_connect('localhost', 'root', 'ypg93ml5zkzp');
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

?>
