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
<style type="text/css">
        
        body {
            font-family:"Malgun Gothic";
            font-size: 0.8em;

        }
        /*TAB CSS*/

        ul.tab_head_list {
            margin: 0;
            padding: 0;
            float: left;
            list-style: none;
            height: 32px; /*--Set height of tabs--*/
            border-bottom: 1px solid #999;
            border-left: 1px solid #999;
            width: 100%;
        }
        ul.tab_head_list li {
            float: left;
            margin: 0;
            padding: 0;
            height: 31px; /*--Subtract 1px from the height of the unordered list--*/
            line-height: 31px; /*--Vertically aligns the text within the tab--*/
            border: 1px solid #999;
            border-left: none;
            margin-bottom: -1px; /*--Pull the list item down 1px--*/
            overflow: hidden;
            position: relative;
            background: #e0e0e0;
        }
        ul.tab_head_list li a {
            text-decoration: none;
            color: #000;
            display: block;
            font-size: 1.2em;
            padding: 0 20px;
            /*--Gives the bevel look with a 1px white border inside the list item--*/
            border: 1px solid #fff; 
            outline: none;
        }
        ul.tab_head_list li a:hover {
            background: #ccc;
        }
        html ul.tab_head_list li.active, html ul.tab_head_list li.active a:hover  {
             /*--Makes sure that the active tab does not listen to the hover properties--*/
            background: #fff;
            /*--Makes the active tab look like it's connected with its content--*/
            border-bottom: 1px solid #fff; 
        }

        /*Tab Conent CSS*/
        .tab_body_list {
            border: 1px solid #999;
            border-top: none;
            overflow: hidden;
            clear: both;
            float: left; 
            width: 100%;
            height: 490;
            background: #fff;
        }
        .tab_body {
            padding: 20px;
            font-size: 1.2em;
        }
    </style>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
    <script type="text/javascript">
    var comport = new Array ("com1","com2","com3");
        $(document).ready(function() {
            set_tab("left_tab");
            set_tab("right_tab");

            //On Click Event
            $(document).on("click", "ul.tab_head_list li", function(e) {
                var clicked_id = $(this).attr('id');
                var clicked_class = $(this).attr('class');
                var side = "#"+clicked_class+" ";
                $(side+"ul.tab_head_list li").removeClass("active"); //Remove any "active" class
                $(this).addClass("active"); //Add "active" class to selected tab
                $(side+".tab_body").hide(); //Hide all tab content
                var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
                $(activeTab).fadeIn(); //Fade in the active ID content
                return false;
            });
            
        });
        function set_tab(side){
            var use = "#"+side+" ";
            var i = 1;
            comport.forEach(function (com){
                var head = "<li class ='"+side+"'><a href='"+use+"#"+com+"'>"+com+"</a></li>";
                var body = "<div class='tab_body' id='"+com+"'>"+com+"</div>";
                $(use+" .tab_head_list").append(head);
                $(use+" .tab_body_list").append(body);
                i++;
            })
            
            //When page loads...
            $(use+".tab_body").hide(); //Hide all content
            $(use+"ul.tab_head_list li:first").addClass("active").show(); //Activate first tab
            $(use+".tab_body:first").show(); //Show first tab content
        }
    </script>
<body>
<!------------------------------------------------------ Tab1 ------------------------------------------------------>
<div class = 'col' id="left_tab">    
    <!--탭 메뉴 영역 -->
    <ul class="tab_head_list"></ul>

    <!--탭 콘텐츠 영역 -->
    <div class="tab_body_list"></div>

</div>
<!------------------------------------------------------ Tab2 ------------------------------------------------------>
<div class = 'col' id="right_tab">    
        <!--탭 메뉴 영역 -->
    <ul class="tab_head_list"></ul>

    <!--탭 콘텐츠 영역 -->
    <div class="tab_body_list"></div>
</div>
<!------------------------------------------------------ Tab2 ------------------------------------------------------>
</body>
</html>