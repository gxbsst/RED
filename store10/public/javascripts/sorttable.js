//=========================================================
//
//  在本机对浏览器页面表格中的数据行进行排序的javascript函数
//  
//  author Berek  QQ: 393688974 
//  create date 2008-05-27
//  version 1.0
//=========================================================

 //column index for sort
 var indexCol;
 //比较函数，用于Array.sort()排序时比较用。
 //本函数比较数组元素array1[indexCol]和元素array2[indexCol]Unicode值的大小
 function arrayCompare(array1,array2){
  //alert(array1.length+"--"+array1[indexCol]);
  if (indexCol == '3'){
  var i = array1[indexCol], j = array2[indexCol] ;
  i = i.split(">"); i = i[1].split("<");
  j = j.split(">"); j = j[1].split("<");
  if(i[0] < j[0] ) return -1;
  if(i[0] > j[0] ) return 1;
  return 0;
  }
  if (array1[indexCol] < array2[indexCol])
   return -1;
  if (array1[indexCol] > array2[indexCol])
   return 1;
  
  return 0;
 
 }
 //比较数组元素array1[indexCol]和元素array2[indexCol]的数值大小
 function arrayCompareNumber(array1,array2){
  
  if (parseInt(array1[indexCol]) < parseInt(array2[indexCol]))
   return -1;
  if (parseInt(array1[indexCol]) > parseInt(array2[indexCol]))
   return 1;
  
  return 0;
 }

 //与arrayCompare相反方式比较大小，用于倒序使用
 function arrayCompareRev(array1,array2){
  //alert(indexCol);
  if (indexCol == '3'){
  var i = array1[indexCol], j = array2[indexCol] ;
  i = i.split(">"); i = i[1].split("<");
  j = j.split(">"); j = j[1].split("<");
  if(i[0] < j[0] ) return 1;
  if(i[0] > j[0] ) return -1;
  return 0;
  }
  if (array1[indexCol] < array2[indexCol])
   return 1;
  if (array1[indexCol] > array2[indexCol])
   return -1;
  
  return 0;
 
 }
 //与arrayCompareNumber相反方式比较大小，用于倒序使用
 function arrayCompareNumberRev(array1,array2){
  if (parseInt(array1[indexCol]) < parseInt(array2[indexCol]))
   return 1;
  if (parseInt(array1[indexCol]) > parseInt(array2[indexCol]))
   return -1;
  
  return 0;
 }
 
 //define a 2-dimension array 
 function BiArray(rows,cols){
  
  //simulate multidimension array
  this.rows = rows;
  this.cols = cols;
  
  //construct array
  var lines = new Array(rows);
  for(var i = 0;i < lines.length; i++){
   lines[i] = new Array(cols);
  }
  
  
  // 设置数组在(i,j)的元素值为value
  this.setElement = function(i,j,value){ lines[i][j] = value; };
  
  // 获取数组在(i,j)处元素的值
  this.getElement = function(i,j){return lines[i][j];};
  
  // 返回数组第i行所在的数组
  this.getLine = function(i){return lines[i];};
  
  // 根据第j列字符串的值,对数组的行进行排序,排序结果为升序
  this.sortLine = function(j){
       indexCol = j;
       lines.sort(arrayCompare);
      };
  
  // 根据第j列数值的值,对数组的行进行排序,排序结果为升序
  this.sortLineByNumber = function(j){
       indexCol = j;
       lines.sort(arrayCompareNumber);
      };
  
  // 根据第j列字符串的值,对数组的行进行排序,排序结果为倒序
  this.sortLineRev = function(j){
       indexCol = j;
       lines.sort(arrayCompareRev);
      };
  
  // 根据第j列数值的值,对数组的行进行排序,排序结果为倒序
  this.sortLineByNumberRev = function(j){
       indexCol = j;
       lines.sort(arrayCompareNumberRev);
      };
  //将二维数组转为字符串格式
  this.toString = function(){
       var rst ="";
       for(var i = 0; i < lines.length; i++){
        for(var j = 0; j < lines[i].length; j++){
         rst += lines[i][j];
         rst += '\t';
        }
        rst += '\n';
       }
       return rst;
      };
 } // end of BiArray define
 
 //ascending or descending 
 var asce = true;

 /**
  对表格中指定范围的数据进行排序
  tableId    要排序的表格的id,值格式为 <table id="tb1" >
  sortCol    用于排序的列号,从1开始计数
  compareType   排序时比较方式，s-按字符串比较,n-按数值比较
  startRow   排序范围起始行号,从1开始计数
  endRow     排序范围结束行号,从1开始计数
  startCol   排序范围起始列号,从1开始计数
  endCol     排序范围结束列号,从1开始计数
 */
 function sortTableInRange(tableId,sortCol,compareType,startRow,endRow,startCol,endCol){
  
  
  try{
   var table = document.getElementById(tableId);
   // get all row object of the table
   var objRows = table.getElementsByTagName("tr");
   //alert(objRows.length);
   
   endRow = (endRow < objRows.length ? endRow : objRows.length);
   
   var sortRows = endRow - startRow + 1;
   //alert("sortRows "+sortRows);
   if (sortRows < 2) //only one line,don't sort
    return ;
   
   
   endCol = (endCol < objRows[1].getElementsByTagName("td").length ? endCol :
     objRows[1].getElementsByTagName("td").length);
   
   
   // column number of sort
   //var cols = objRows[1].childNodes.length;
   var cols = endCol - startCol + 1;
    
   
    
   // define a array to store table cell and sort them
   var tabData = new BiArray(sortRows,cols);
   
   
   var ari = 0;
   // retrived table cell data save to array
   for(i = startRow - 1; i < endRow; i++){
    //retrived all <td> cell
    var cells = objRows[i].getElementsByTagName("td");
    
    var arj = 0;
    for(var j = startCol - 1; j < endCol; j++){
     tabData.setElement(ari,arj,cells.item(j).innerHTML);
     arj++;
     
    }
    ari++;
   }
   
   if (asce){
    if (compareType == "n" || compareType == 'N')
     tabData.sortLineByNumber(sortCol- startCol);
    else
     tabData.sortLine(sortCol - startCol);
    asce = false;
   }else{
    if (compareType == "n" || compareType == 'N')
     tabData.sortLineByNumberRev(sortCol - startCol);
    else
     tabData.sortLineRev(sortCol - startCol);
    asce = true;
   }
   ari = 0;
   //update table data with array
   for(i = startRow -1; i < endRow; i++){
    //retrived all <td> cell
    var cells = objRows[i].getElementsByTagName("td");
    
    arj = 0;
    for(var j = startCol - 1; j < endCol; j++){
     cells.item(j).innerHTML = tabData.getElement(ari,arj);
     arj++;
    }
    ari++;
   }

  }catch(e){
   alert(e);
  }
 }

 /**
  对表格除第一行外的数据行排序,是sortYableInRange(tableId,sortCol,compareType,2,tabRows,1,tabCols)
  的特例。
  tableId    要排序的表格的id,值格式为 <table id="tb1" >
  用于排序的列号,从1开始计数
  compareType   排序时比较方式，s-按字符串比较,n-按数值比较
 */
 function sortTable(tableId,sortCol,compareType){
  
  
  try{
   var table = document.getElementById(tableId);
   // get all row object of the table
   var objRows = table.getElementsByTagName("tr");
   //alert(objRows.length);
   
   
   var endRows = objRows.length;
   
   if (endRows < 2) //only one line,don't sort
    return ;
   
   // column number of table
   var cols = objRows[1].getElementsByTagName("td").length;
   
   
   sortTableInRange(tableId,sortCol,compareType,2,endRows,1,cols);
   
  }catch(e){
   alert(e);
  }
 }
