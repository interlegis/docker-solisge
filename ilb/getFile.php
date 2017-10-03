<?php
if($_GET['img'] && $_GET['ct']) {
	$caminho='../modules/basic/upload/' . $_GET['img'];
	$contenttype=$_GET['ct'];
}
else {
	$caminho='../modules/basic/upload/dummy';
	$contenttype=$_GET['image/png'];
}

$image = file_get_contents($caminho);
header("Content-type: $contenttype;");
header("Content-Length: " . strlen($image));
echo $image;
?>
