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
	<a href="#" class="brand-link"> <span
			class="brand-text font-weight-light">Multi Simulator</span>
	</a>

	<!-- Sidebar -->
	<div class="sidebar">

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
                    with font-awesome or any other icon font library -->
				<li class="nav-item"><a href="#" class="nav-link" id="side-eqSetting"> <i class="nav-icon fas fa-cog"></i>
					<p>
						Setting <i class="right fas fa-angle-left"></i>
					</p>
				</a><ul class="nav nav-treeview">
					<li class="nav-item"><a href="/setting" class="nav-link" id="side-physiInterface"> <i class="far fa-circle nav-icon"></i>
						<p>Physical Interface</p>
					</a></li>
					<li class="nav-item"><a href="/modeling/message" class="nav-link" id="side-message"> <i class="far fa-circle nav-icon"></i>
						<p>Message</p>
					</a></li>
					<li class="nav-item"><a href="/modeling/scenario" class="nav-link" id="side-scenario"> <i class="far fa-circle nav-icon"></i>
						<p>Scenario</p>
					</a></li>
				</ul></li>
				<!--             <li class="nav-item has-treeview menu-open"><a href="#" class="nav-link" id="side-modeling"> <i class="nav-icon fas fa-border-all"></i>
                                  <p>
                                     Modeling <i class="right fas fa-angle-left"></i>
                                  </p>
                            </a>
                               <ul class="nav nav-treeview">
                                  <li class="nav-item"><a href="/modeling/message" class="nav-link" id="side-message"> <i class="far fa-circle nav-icon"></i>
                                        <p>Message</p>
                                  </a></li>
                                  <li class="nav-item"><a href="/modeling/scenario" class="nav-link" id="side-scenario"> <i class="far fa-circle nav-icon"></i>
                                        <p>Scenario</p>
                                  </a></li>
                               </ul></li> -->
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
	var eqSetting = document.getElementById('side-eqSetting');
	var message   = document.getElementById('side-message');
	var scenario  = document.getElementById('side-scenario');
	var execution = document.getElementById('side-execution');
	var modeling  = document.getElementById('side-modeling');

	switch (location.pathname) {
		case "/":
			eqSetting.classList.add('active');
			break;
		case eqSetting.getAttribute('href') :
			eqSetting.classList.add('active');
			break;
		case message.getAttribute('href') :
			modeling.classList.add('active');
			message.classList.add('active');
			break;
		case scenario.getAttribute('href') :
			modeling.classList.add('active');
			scenario.classList.add('active');
			break;
		case execution.getAttribute('href') :
			execution.classList.add('active');
			break;
	}
</script>