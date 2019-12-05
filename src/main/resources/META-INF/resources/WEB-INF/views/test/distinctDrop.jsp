<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<head>
<meta charset="UTF-8">
<title>Title</title>
<style>
.box {
	border: 1px solid black;
	width: 100px;
	height: 100px;
	display: inline-block;
	background-color: red;
	margin-left: 100px;
}

.drop {
	border: 1px solid grey;
	width: 400px;
	height: 400px;
	margin-left: 100px;
}
</style>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
</head>

<div id="main">
	<div id="box1" class="box">Cucumber</div>
	<div id="box2" class="box">Apple</div>
	<div id="box3" class="box">PineApple</div>
	<hr />
	<div class="drop"></div>
</div>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script>
<script>
     $( function (){
         //ë“œëž˜ê·¸
         $( '#box1, #box2' ).draggable({
             revert : true ,
             scope: 'ok'
         });
         $( '#box3' ).draggable({
            revert: true
         });
         //ë“œë¡­
         $( '.drop' ).droppable({
             scope: 'ok' ,
             drop: function (e, ui) {
                 $( this ).html($( this ).html() + ui.draggable.text() + 'ë“¤ì–´ì™”ìŠµë‹ˆë‹¤.<br/>' );
             }
         });
     });
</script>