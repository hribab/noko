<?php

include_once('../autoloader.php');
include_once('../idn/idna_convert.class.php');
include "../../AlchemyAPI_PHP5-0.8/module/AlchemyAPI.php";
include "originalink.php";

include "../../alchemyapiimage/ie.php";

$con=new Mongo("mongodb://localhost");
$dbname = $con->selectDB('feedurl'); // this is where feed urls stores
$collection = $dbname->selectCollection("feedurl");
$res=$collection->find();

$dbname = $con->selectDB('feedarticles');
$feedarticles = $dbname->selectCollection("feedarticles");
$noncrawled = $dbname->selectCollection("errorurl");
$oneword = $dbname->selectCollection("onewordnames");
$feedsdb = $dbname->selectCollection("feeds");

// Create an AlchemyAPI object.
$alchemyObj = new AlchemyAPI();

// Load the API key from disk.
$alchemyObj->loadAPIKey("api_key.txt");

$namedEntityParams = new AlchemyAPI_NamedEntityParams();
$namedEntityParams->setSentiment(1);

$i=0;
foreach($res as $b) { 
	echo $i."\n";
	echo "feed---".$b['link']."\n";
	$update=date("j M Y, g:i a", strtotime( '-50 days' ) );
	$feed = new SimplePie();
	$feed->set_feed_url($b['link']);
	$feed->enable_order_by_date(false);
	$feed->force_feed(true);

	// Initialize the whole SimplePie object.  Read the feed, process it, parse it, cache it, and
	// all that other good stuff.  The feed's information will not be available to SimplePie before
	// this is called.
	$success = $feed->init();
	
	// We'll make sure that the right content type and character encoding gets set automatically.
	// This function will grab the proper character encoding, as well as set the content type to text/html.
	$feed->handle_content_type();

	if ($success )
	{	
	foreach($feed->get_items() as $item)
	{
		$feeddate=$item->get_date('j M Y, g:i a');
		echo "in time--".$b['time']."\n"."--feed time---".$feeddate."\n";
		if( date_create($b['time']) < date_create($feeddate) )
			{
			echo "link--".$item->get_link()."\n";
			// update feedurl time stamp
			$url=originalink($item->get_link());
			$title=$item->get_title();
			$datetime=$item->get_date('j M Y, g:i a');
			if(date_create($update)<date_create($datetime))
			$update=$datetime;
			//$content=$item->get_content();
			if(is_null($feeddate)) $feeddate=date('j M Y, g:i a');
			$feedpeopletag="";
			$feedcompanytag="";
			$feedproducttag="";
			$feedauthor="";
			$feedlines="";
			$feedsource=$b['name'];
			$feedimage=getimage($url);
			set_time_limit(10000);
			
		
			if( $url != null )//&& filter_var($url, FILTER_VALIDATE_URL ))
			{
				try{
					$turl="http://haribabu:Wo0sVXeBGQ@paygo.crawlera.com:8010/fetch?url=".$url;
					$alcEntities = @$alchemyObj->URLGetRankedNamedEntities($turl,'json', $namedEntityParams) ;
					$alcRelations = @$alchemyObj->URLGetRelations($turl,'json');
					$alcAuthor = json_decode(@$alchemyObj->URLGetAuthor($turl,'json')) ? json_decode($alchemyObj->URLGetAuthor($turl,'json'))->author : $b['name'];
					}
				catch(Exception $e) {
					echo "error--".$e;
					$cel=array("url"=>$url);
					$noncrawled->insert($cel);// we should re-crawl it
					//sleep(300);
					continue;
					}
			
				$alcEntityArr = json_decode($alcEntities, true); 
				$alcResponseArr = json_decode($alcRelations, true);
				$feedauthor= $alcAuthor;
				
				foreach($alcEntityArr['entities'] as $e)
				{	 
				
				if(trim($e['type']) == "Person" && str_word_count($e['text']) <2 ) {
				echo "oneword name--".$e['text']."\n"; 
				$ow=array("name"=>$e['text'], "link"=>$url);
				$oneword->insert($ow); 
				}
  	
				if(trim($e['type']) == "Person" && str_word_count($e['text']) >=2 ) 
				{
				$lines[]=array();
				$s="";
						
				if ($alcResponseArr['status'] == 'OK') 
				{
				foreach ($alcResponseArr['relations'] as $relation) {

					if (array_key_exists('subject', $relation)) {
					$s=$s.$relation['subject']['text']." ";
					}
				
					if (array_key_exists('action', $relation)) {
					$s=$s.$relation['action']['text']." ";
					}
				
					if (array_key_exists('object', $relation)) {
					$s=$s.$relation['object']['text']." , ";
					}
			
				if(strstr($s, $e['text'])){ $lines[]= array('line'=>$s); }//echo " ".$s."<br/><br/>";}
				
					$s="";
				}
				}
				$allLines="";
				if(count($lines)>0){
				$tempLines = array_column($lines, 'line');
				$allLines = implode(',', $tempLines);
				}
				$type="";
				$score="";
				if(isset($e['sentiment']['type'])) $type=$e['sentiment']['type'];
				if(isset($e['sentiment']['score'])) $score=$e['sentiment']['score'];
				
				$feedpeopletag[]=array("name"=>$e['text'],"relevance"=>$e['relevance'],"lines"=>$allLines);
	 
				$cel = array('name'=>$e['text'], 'relevance'=>$e['relevance'],'lines'=>$allLines, 'title' =>$title, 'link'=>$url, 'author'=>$alcAuthor, 'source'=>$b['name'], 'date'=>$datetime, 'sentiment'=>$type, 'sscore'=>$score, 'type'=>'Person');
				//fputcsv($people, $cel);	 
				$feedarticles->insert($cel);
   
				}	
				
				
				if(trim($e['type']) == "Company")
				{
				
  				$lines[]=array();
				$s="";
						
				if ($alcResponseArr['status'] == 'OK') 
				{
				foreach ($alcResponseArr['relations'] as $relation) {

					if (array_key_exists('subject', $relation)) {
					$s=$s.$relation['subject']['text']." ";
					}
				
					if (array_key_exists('action', $relation)) {
					$s=$s.$relation['action']['text']." ";
					}
				
					if (array_key_exists('object', $relation)) {
					$s=$s.$relation['object']['text']." , ";
					}
			
				if(strstr($s, $e['text'])){ $lines[]= array('line'=>$s); }//echo " ".$s."<br/><br/>";}
				
					$s="";
				}
				}
			
				$allLines="";
				if(count($lines)>0){
				$tempLines = array_column($lines, 'line');
				$allLines = implode(',', $tempLines);
				}
			
				$type="";
				$score="";
				if(isset($e['sentiment']['type'])) $type=$e['sentiment']['type'];
				if(isset($e['sentiment']['score'])) $score=$e['sentiment']['score'];
				
				$feedcompanytag[]=array("name"=>$e['text'],"relevance"=>$e['relevance'],"lines"=>$allLines);
	 
				$cel = array('name'=>$e['text'], 'relevance'=>$e['relevance'],'lines'=>$allLines, 'title' =>$title, 'link'=>$url, 'author'=>$alcAuthor, 'source'=>$b['name'], 'date'=>$datetime, 'sentiment'=>$type, 'sscore'=>$score, 'type'=>'Company');
				//fputcsv($people, $cel);	 
				$feedarticles->insert($cel);
   
			
				}
	
	
				if(trim($e['type']) == "Product") 
				{
			
  
				$lines[]=array();
				$s="";
						
				if ($alcResponseArr['status'] == 'OK') 
				{
				foreach ($alcResponseArr['relations'] as $relation) {

					if (array_key_exists('subject', $relation)) {
					$s=$s.$relation['subject']['text']." ";
					}
				
					if (array_key_exists('action', $relation)) {
					$s=$s.$relation['action']['text']." ";
					}
				
					if (array_key_exists('object', $relation)) {
					$s=$s.$relation['object']['text']." , ";
					}
			
				if(strstr($s, $e['text'])){ $lines[]= array('line'=>$s); }//echo " ".$s."<br/><br/>";}
				
					$s="";
				}
				}
			
				$allLines="";
				if(count($lines)>0){
				$tempLines = array_column($lines, 'line');
				$allLines = implode(',', $tempLines);
				}
				$lines="";
			
				$type="";
				$score="";
				if(isset($e['sentiment']['type'])) $type=$e['sentiment']['type'];
				if(isset($e['sentiment']['score'])) $score=$e['sentiment']['score'];
				
				$feedproducttag[]=array("name"=>$e['text'],"relevance"=>$e['relevance'],"lines"=>$allLines);
	 
				$cel = array('name'=>$e['text'], 'relevance'=>$e['relevance'],'lines'=>$allLines, 'title' =>$title, 'link'=>$url, 'author'=>$alcAuthor, 'source'=>$b['name'], 'date'=>$datetime, 'sentiment'=>$type, 'sscore'=>$score, 'type'=>'Product');
				//fputcsv($people, $cel);	 
				$feedarticles->insert($cel);
   
				}
				
				
				if ($alcResponseArr['status'] == 'OK') 
				{
				foreach ($alcResponseArr['relations'] as $relation) {

					if (array_key_exists('subject', $relation)) {
					$s=$s.$relation['subject']['text']." ";
					}
				
					if (array_key_exists('action', $relation)) {
					$s=$s.$relation['action']['text']." ";
					}
				
					if (array_key_exists('object', $relation)) {
					$s=$s.$relation['object']['text']." , ";
					}
			
				   $feedlines[]=array('line'=>$s);
					$s="";
				}
				}

				}
			}
			$tempLines = array_column($feedlines, 'line');
			$summary = implode(',', $tempLines);
			
			$feeds=array("link"=>$url, "title"=>$title, "image"=>$feedimage, "people"=>$feedpeopletag, "companies"=>$feedcompanytag, "product"=>$feedproducttag,"author"=>$feedauthor, "date"=>$feeddate, "source"=>$feedsource, "summary"=>$summary);
			$feedsdb->insert($feeds);
			$feedpeopletag="";
			$feedcompanytag="";
			$feedproducttag="";
			$feedlines="";
			
			}
			
	}
	$i++;
	

	}
		if($update==null) {echo "--update is null-";$update=date('j M Y, g:i a');}
	$tmpd=array('$set'=>array('time'=>$update));
	$collection->update(array('link'=>$b['link']), $tmpd);

	} 
  
		
  
?>
