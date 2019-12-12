<%--
  Created by IntelliJ IDEA.
  User: seo
  Date: 2019-10-29
  Time: 11:02
  To change this template use File | Settings | File Templates.
--%>
<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
	<!-- Brand Logo -->
	<div>
		<span class="logo_symbol"></span>
		<a href="#" class="brand-link"> 
			<span class="logo_img"></span>
		</a>
	</div>

	<!-- Sidebar -->
	<div class="sidebar">

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
                    with font-awesome or any other icon font library -->
				<li class="nav-item" id="li-setting"><a href="#" class="nav-link" id="side-setting"> <i class="nav-icon fas fa-cog"></i>
					<p>
						Setting <i class="right fas fa-angle-left"></i>
					</p>
				</a><ul class="nav nav-treeview">
					<li class="nav-item"><a href="/setting/physical-interface" class="nav-link" id="side-physiInterface"> <i class="far fa-circle nav-icon"></i>
						<p>Physical Interface</p>
					</a></li>
					<li class="nav-item"><a href="/setting/message-frame" class="nav-link" id="side-message"> <i class="far fa-circle nav-icon"></i>
						<p>Message</p>
					</a></li>
					<li class="nav-item"><a href="/setting/scenario" class="nav-link" id="side-scenario"> <i class="far fa-circle nav-icon"></i>
						<p>Scenario</p>
					</a></li>
				</ul></li>
				<li class="nav-item"><a href="/execution" class="nav-link" id="side-execution"> <i class="nav-icon fas fa-caret-square-right"></i>
					<p>Execute</p>
				</a></li>
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<!-- /.sidebar -->
</aside>

<script type="text/javascript">
	var li_setting = document.getElementById('li-setting');
    var setting = document.getElementById('side-setting');
	var physiInterface = document.getElementById('side-physiInterface');
    var message   = document.getElementById('side-message');
    var scenario  = document.getElementById('side-scenario');
    var execution = document.getElementById('side-execution');
    
	switch (location.pathname) {
		case "/":
            physiInterface.classList.add('active');
            setting.classList.add('active');
            li_setting.classList.add('menu-open');
			break;
		case physiInterface.getAttribute('href') :
            physiInterface.classList.add('active');
            setting.classList.add('active');
            li_setting.classList.add('menu-open');
            break;
		case message.getAttribute('href') :
			message.classList.add('active');
			setting.classList.add('active');
            li_setting.classList.add('menu-open');
            break;
		case scenario.getAttribute('href') :
			scenario.classList.add('active');
			setting.classList.add('active');
            li_setting.classList.add('menu-open');
            break;
		case execution.getAttribute('href') :
			execution.classList.add('active');
			break;
	}
</script>