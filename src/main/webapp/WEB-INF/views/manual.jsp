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
    var fileNameData = new Array();
    var dataTable;
    
	load();
	
	function load() {
		$.ajax({
			url: '/api/file/manualFileList',
			type: 'GET',
			success: function (data) {
				if(data.length > 0) {	    
					data.forEach(function (name) {
					    var dataArr = new Array();
					    if (name.indexOf(".") == -1) {	// .jpg 확장자 붙이기
					        dataArr = ["<input type='checkbox' class ='fileChbox'>", name + ".jpg"];
					    } else {
					        dataArr = ["<input type='checkbox' class ='fileChbox'>", name];
					    }	    
					    fileNameData.push(dataArr);
					});
				}
				
				if(fileNameData) {
				    dataTable = $('#manualListTable').DataTable( {
				        data: fileNameData,
				        deferRender:    true,
				        scrollY:        300,
				        scrollCollapse: true,
				        scroller:       true,
				        stateSave:      true,
				        dom: '<"top"f>t'
				    });
				}
			}
		});
	}
    
    $(document).on("change", "#allChBox", function() {
        if ($("#allChBox").is(":checked")) {
            $(".fileChbox").prop('checked', true);
        } else {
            $(".fileChbox").prop('checked', false);
		}
	});

    /* 파일명 dblclick 하면 download */
    $(document).on("dblclick", "#manualListTable tr", function() {	
        console.log($(this).text());
        manualDownload($(this).text());
	});
    
    $(document).on("click", "#manualUploadBtn", function() {
	   var input = document.createElement("input");
       input.setAttribute("type", "file");
       input.setAttribute("name", "files");
       input.setAttribute("multiple", "multiple");
       input.setAttribute("id", "uploadFiles");

       document.getElementById("hidden-div").appendChild(input);
       var uploadFiles = document.getElementById("uploadFiles");

       uploadFiles.click();
       uploadFiles.onchange =function (ev) {
          var formData = new FormData();
          var files = document.getElementById("uploadFiles").files;

          for(var idx=0; idx<files.length; idx++) {
             formData.append("files", files[idx]);
          }

          $.ajax({
             url: '/api/file/manualUploader',
             type: 'POST',
             enctype: "multipart/form-data",
             data: formData,
             contentType : false,
             processData : false,
             success: function (data) {
                 console.log(data.data);
                 if(data.data.length > 0) {	    
                     data.data.forEach(function (name) {
 					   if (name.indexOf(".") == -1) {	// .jpg 확장자 붙이기
 	                     dataTable.row.add( ["<input type='checkbox' class ='fileChbox'>", name + ".jpg"] ).draw( false );
	 				    } else {
	 				        dataTable.row.add( ["<input type='checkbox' class ='fileChbox'>", name] ).draw( false );
	 				    }
				  });
				}            
             }
          });

          uploadFiles.remove();
       }
	});

    $(document).on("click", "#manualDownloadBtn", function() {
        var fileNameArr = new Array();

        $("tbody").find("tr").each(function() {
            var tr = $(this);
            var td = tr.children();

            if ($(this).find(".fileChbox").is(":checked")) {	// 선택한 파일이름들 배열에 저장
                fileNameArr.push(td.eq(1).text());
            }
        });
        for (var i = 0; i < fileNameArr.length; i++) {
            var a = document.createElement("a");
            a.setAttribute("href", "/api/file/manualDownloader?fileName="+fileNameArr[i]);
            a.click();
            a.remove();
            console.log(fileNameArr[i]);
            //manualDownload(fileNameArr[i]);
    	}
   });

    function manualDownload(fileName) {
       var a = document.createElement("a");
       a.setAttribute("href", "/api/file/manualDownloader?fileName="+fileName);
       a.click();
       a.remove();
    }
});

</script>

</head>

<body>

<div class = "card col-12" id = "manualCard">
   <div class = "card-header">
      <div class="left card-title">Manual</div>
   </div>
   <div class = "card-body" id = "manualCardBody">
      <div class="post" id = "manualListDiv">
         <table id = "manualListTable" class="display">
            <thead>
               <tr>
                  <th><input type="checkbox" id="allChBox"/></th>
                  <th>파일</th>
               </tr>
            </thead>
            <tbody>
               <tr>
                  <th><input type="checkbox" class ="fileChbox"></th>
                  <th>gggg</th>
               </tr>
            </tbody>
         </table>
      </div>

      <div id = "manualBtnDiv" class="post">
         <button type="button" class="btn btn-info" id = "manualUploadBtn">Upload</button>
         <button type="button" class="btn btn-info" id ="manualDownloadBtn">Download</button>
      </div>
   </div>
</div>

<div id="hidden-div">
</div>

</body>
</html>