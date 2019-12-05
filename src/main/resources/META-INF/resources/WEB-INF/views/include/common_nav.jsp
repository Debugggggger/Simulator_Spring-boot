<%--
  Created by IntelliJ IDEA.
  User: seo
  Date: 2019-10-29
  Time: 11:01
  To change this template use File | Settings | File Templates.
--%>
<!-- Navbar -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
	<!-- Left navbar links -->
	<ul class="navbar-nav">
		<li class="nav-item"><a class="nav-link" data-widget="pushmenu"
			href="#"><i class="fas fa-bars"></i></a></li>
	</ul>

	      
	    
	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto">
		<form class="form-inline ml-3">
			<button type="button" class="btn btn-sm btn-info" id="manual">Manual</button>  
			<select class="form-control form-control-sm" id="eqSelect">
			</select>
		</form>
	</ul>
</nav>
<!-- /.navbar -->

<script type="text/javascript">
	response = ajaxEq("GET", null, null);
	if(response.code == 200){
	   	for (var i = 0; i < response.data.length; i++) {
			$("<option value='" +  response.data[i] + "'>" + response.data[i] + "</option>").appendTo("#eqSelect");
	   	}
	    
	    if (document.cookie.indexOf("eq : eqName") == -1) {		// eqName 없으면 cookie 만들기
			console.log("no eq cookie");
	        
	        $("#eqSelect option:eq(0)").prop("selected", true);
		    setCookie("eq : eqName", JSON.stringify({"eqName" : $("#eqSelect").val()}), 1);
		    console.log(document.cookie);
	    }
	} else {
	    console.log(response.message);
	}
	
	$(document).on("click", "#manual", function() {
        var url = "/manual";  
        window.open(url, "_blank", "width = 600, height = 600, resizable=no");            
	});
</script>