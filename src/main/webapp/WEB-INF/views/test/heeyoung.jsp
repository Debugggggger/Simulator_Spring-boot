<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Heeyoung</title>
</head>
<body>
<div id="sticky_test2" style="position:block;">
	■■■■■■■■<br>
	b1ix_custom_sticky<br>
	■■■■■■■■
</div>

<script>
function stiky_custom(id)
{
	var tid = $(id)
	var tid_t = tid.offset().top
	var window_t = $(window).scrollTop()
	// console.log(tid_t, window_t)

	if( origin_val.top <= window_t )
	{
		tid.css('position', 'fixed').css('top',0).css('width','100%')
	}
	else
	{
		tid.css('position', origin_val.position).css('top',origin_val.top)
	}
}

var sticky_id = '#sticky_test2'
var sticky_id_d = $(sticky_id)
var origin_val = {}
origin_val.top = $(sticky_id).offset().top
origin_val.position = $(sticky_id).css('position')

$(window).scroll(function(){
	stiky_custom(sticky_id)
})
</script>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>
**<br/>

</body>
</html>