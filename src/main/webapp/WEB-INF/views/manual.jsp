<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Simulator - Manual</title>
<!-- Made CSS -->
<link rel="stylesheet" href="/resources/dist/madecss/manual.css">
<!-- Font Awesome -->
<link rel="stylesheet" href="/resources/plugins/fontawesome-free/css/all.min.css">
<!-- Ionicons -->
<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
<!-- Tempusdominus Bbootstrap 4 -->
<link rel="stylesheet" href="/resources/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
<!-- iCheck -->
<link rel="stylesheet" href="/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
<!-- JQVMap -->
<link rel="stylesheet" href="/resources/plugins/jqvmap/jqvmap.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="/resources/dist/css/adminlte.min.css">
<!-- overlayScrollbars -->
<link rel="stylesheet" href="/resources/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
<!-- Daterange picker -->
<link rel="stylesheet" href="/resources/plugins/daterangepicker/daterangepicker.css">
<!-- summernote -->
<link rel="stylesheet" href="/resources/plugins/summernote/summernote-bs4.css">

<!-- DataTables -->
<!-- <link rel="stylesheet" href="/resources/plugins/jquery-ui/jquery-ui.css"> -->
<link rel="stylesheet" href="/resources/plugins/datatables/datatables.css">
<link rel="stylesheet" href="/resources/plugins/datatables-checkboxes/css/dataTables.checkboxes.css">

<!-- Google Font: Source Sans Pro -->
<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
<!-- jQuery -->
<script src="/resources/plugins/jquery/jquery.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="/resources/plugins/jquery-ui/jquery-ui.min.js"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
  $.widget.bridge('uibutton', $.ui.button)
</script>
<!-- Bootstrap 4 -->
<script src="/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- ChartJS -->
<script src="/resources/plugins/chart.js/Chart.min.js"></script>
<!-- Sparkline -->
<script src="/resources/plugins/sparklines/sparkline.js"></script>
<!-- JQVMap -->
<script src="/resources/plugins/jqvmap/jquery.vmap.min.js"></script>
<script src="/resources/plugins/jqvmap/maps/jquery.vmap.usa.js"></script>
<!-- jQuery Knob Chart -->
<script src="/resources/plugins/jquery-knob/jquery.knob.min.js"></script>
<!-- daterangepicker -->
<script src="/resources/plugins/moment/moment.min.js"></script>
<script src="/resources/plugins/daterangepicker/daterangepicker.js"></script>
<!-- Tempusdominus Bootstrap 4 -->
<script src="/resources/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
<!-- Summernote -->
<script src="/resources/plugins/summernote/summernote-bs4.min.js"></script>
<!-- overlayScrollbars -->
<script src="/resources/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
<!-- AdminLTE App -->
<script src="/resources/dist/js/adminlte.js"></script>
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<script src="/resources/dist/js/pages/dashboard.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="/resources/dist/js/demo.js"></script>

<!-- DataTables -->
<script src="/resources/plugins/datatables/datatables.js"></script>
<script src="/resources/plugins/datatables-checkboxes/js/dataTables.checkboxes.js"></script>


<!-- 우리의 유틸 -->
<script src="/resources/plugins/util/ajaxUtil.js"></script>
<script src="/resources/plugins/util/cookiesUtil.js"></script>


<script type="text/javascript">
$(document).ready(function() {
    
    $('#manualListTable').DataTable( {
        columnDefs: [
            {
               targets: 0,
               checkboxes: {
                  selectRow: true
               }
            }
         ],
         select: {
            style: 'multi'
         },
         order: [[1, 'asc']],
        deferRender:    true,
        scrollY:        300,
        scrollCollapse: true,
        scroller:       true,
        stateSave:      true,
        dom: '<"top"f>t'
    });
    
    /* manual search */        
    $(document).on("keyup search", "#searchManual", function() {
        searchLogic("searchManual", "manual");
    });
    
    $(document).on("click", "#manualUploadBtn", function() {
        openTextFile();
	});
    
    $(document).on("click", "#manualDownloadBtn", function() {
        /* var all=[];		// 모든 option
        $('.manual').each(function(i, selected){ 
            all[i] = $(selected).text(); 
        });
        
        var foo = [];	// selected option
        $('#manualListSelect :selected').each(function(i, selected){ 
            console.log($(selected).text());
            foo[i] = $(selected).text(); 
        });
        
        var de= $.grep(all, function(element) {	// unselected option
            return $.inArray(element, foo) !== -1;
        });
        
        if (de.length == 0) {
            alert("DownLoad 할 파일을 선택하세요.");
        } */
	});
    
    $(document).on("dblclick", ".manual", function() {
        console.log($(this).text());
	});
});

function searchLogic(inputBoxId, searchClass) {	// (input type = search "ID", 검색할 "class")
    var input, filter, txtValue;
    input = document.getElementById(inputBoxId);
    filter = input.value.toUpperCase();
    
    $("." + searchClass).each(function () {
        txtValue = $(this).text();
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            $(this).show();
        } else {
            $(this).removeAttr("style").hide();
        }
    }); 
}

function openTextFile() {
    var input = document.createElement("input");

    input.type = "file";
    input.accept = ".xml";

    input.onchange = function (event) {
        processFile(event.target.files[0]);
    };

    input.click();
}
</script>

</head>

<body>

<div class = "card col-12" id = "manualCard">
	<div class = "card-header">
		<div class="left card-title">Manual</div>
	</div>
	<div class = "card-body" id = "manualCardBody">
	<!-- 	<div class="post input-group input-group-sm" id = "searchManualDiv">
			<input id = "searchManual" class="form-control form-control-navbar filter" type="search" placeholder="Search">
			<div class="input-group-append">
				<button class="btn btn-navbar" type="submit">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</div> -->
		<div class="post" id = "manualListDiv">
			<table id = "manualListTable" class="display">
				<thead>
					<tr>
						<th></th>
						<th>파일</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th></th>
						<th>asdf</th>
					</tr>
					<tr>
						<th></th>
						<th>ssss</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
					<tr>
						<th></th>
						<th>gggg</th>
					</tr>
				</tbody>
			</table>
			<!-- <select id = "manualListSelect" class="form-control post" multiple="multiple">
				<option class = "manual">aaaaaaaaa</option>
				<option class = "manual">bbbbbbbbbbb</option>
				<option class = "manual">ccccccccc</option>
				<option class = "manual">ssssss</option>
				<option class = "manual">haaaassd</option>
			</select> -->
		</div>

		<div id = "manualBtnDiv" class="post">
			<button type="button" class="btn btn-info" id = "manualUploadBtn">Upload</button>
			<button type="button" class="btn btn-info" id ="manualDownloadBtn">Download</button>
		</div>
			
	</div>
</div>

</body>
</html>