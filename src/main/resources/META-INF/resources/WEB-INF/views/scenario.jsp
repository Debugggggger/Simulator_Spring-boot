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

<title>Simulator</title>
<!-- Made CSS -->
<link rel="stylesheet" href="/resources/dist/madecss/scenario.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="/resources/plugins/fontawesome-free/css/all.min.css">
<!-- Ionicons -->
<link rel="stylesheet"
	href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
<!-- Tempusdominus Bbootstrap 4 -->
<link rel="stylesheet"
	href="/resources/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
<!-- iCheck -->
<link rel="stylesheet"
	href="/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
<!-- JQVMap -->
<link rel="stylesheet" href="/resources/plugins/jqvmap/jqvmap.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="/resources/dist/css/adminlte.min.css">
<!-- overlayScrollbars -->
<link rel="stylesheet"
	href="/resources/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
<!-- Daterange picker -->
<link rel="stylesheet"
	href="/resources/plugins/daterangepicker/daterangepicker.css">
<!-- summernote -->
<link rel="stylesheet"
	href="/resources/plugins/summernote/summernote-bs4.css">
<!-- Google Font: Source Sans Pro -->
<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700"
	rel="stylesheet">
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
<script
	src="/resources/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
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
<!-- 우리의 유틸 -->
<script src="/resources/plugins/util/ajaxUtil.js"></script>
<script src="/resources/plugins/util/cookiesUtil.js"></script>

<script type="text/javascript">
    //EQ, HOST 라디오 버튼 확인 변수
    var lineNumber=0;
    var scenList =new Array(); //저장된 시나리오 리스트
    let rstData = [];
    var scenarioName;
    var eqName;
    $(document).ready(function () {
      cardHeight();


      /* 처음  페이지 로드 */
      if (document.cookie.indexOf("eq : eqName") != -1) { 	// eqName cookie 있으면
        var ckData = JSON.parse(getCookie("eq : eqName"));
        $("#eqSelect").val(ckData.eqName).prop("selected", true);
        load(ckData.eqName);
        eqName = ckData.eqName;
      } else {
        console.log("eqName cookie 가 없음 : error");
      }

      /* EQ 바꿀 때 마다 페이지 새로드 */
      $('body').on("change", "#eqSelect", function() {
        eqName = $("#eqSelect").val();
        msgElement = new Array;
        cmpList = new Array();

        $(".btn.btn-block.btn-primary").remove();
        $(".btn.btn-block.bg-gradient-danger").remove();
        $(".btn.btn-block.btn-default").remove();
        clear();
        if (document.cookie.indexOf("eq : eqName") != -1) {		// eqName cookie 있으면
          clearAllCookies();
          clearAllGlobalValue();
          setCookie("eq : eqName", JSON.stringify({"eqName" : eqName}), 1);
          var ckData = JSON.parse(getCookie("eq : eqName"));
          $("#eqSelect").val(ckData.eqName).prop("selected", true);
          load(ckData.eqName);
        } else {
          console.log("eqName cookie 가 없음 : error");
        }
      });

      function load(eqName) {
          $("body").addClass("sidebar-collapse");
        var response = ajaxMessageFrame("GET", eqName, null);
        if (response.code == 200) {
          var i=0;
          response.data.forEach(function (msgFrames) {
            if (msgFrames.type == "command") {
              $("#CmdList").append("<button class = 'btn btn-block btn-primary' id = '" + msgFrames.name + "' value = '" + msgFrames.type + "' onmousedown=\"clickCommand(this.id)\" >" + msgFrames.name + "</button>");
            } else if (msgFrames.type == "response") {
              $("#ResList").append("<button class = 'btn btn-block bg-gradient-danger' id = '" + msgFrames.name + "' value = '" + msgFrames.type + "' onmousedown=\"clickCommand(this.id)\" >" + msgFrames.name + "</button>");
            }
          })
        } else {
          console.log(response.message);
        }

        var scenariolist = ajaxScenario("GET", eqName, null);
        if (scenariolist.code == 200) {
          scenariolist.data.forEach(function (scenarioName) {
            var scenario = {
              "name" : scenarioName.name,
              "side" : scenarioName.side,
              "messageFrames" : scenarioName.messageFrames,
              "timer" : scenarioName.timer,
              "transaction" : scenarioName.transaction
            }
            scenList.push(scenarioName.name);
            $("#scenList").append("<button class = 'btn btn-block btn-default scenarioBtn' id = '" + scenarioName.name + "' value = '" + scenarioName.name + "' onmousedown=\"clickedline(this.id)\" >"+scenarioName.name +"</button>");
            scenarioName = scenarioName.name;
            setGlobalValue("Scenario : " + scenarioName, JSON.stringify(scenario),1);
          })

        }else{
          console.log(scenariolist.message);
        }
      }

      $(document).on("keydown", ".timer", function(e) {
        $(this).val($(this).val().replace(/[^0-9]/gi,''));
      });

    //타이머 일괄추가
        $(".timerIn").click(function() {
            if (radio_check() == "client") {
                $(".timerH").each(function(i, e) {
                    console.log(i+"번째, length = "+$(this).find(".timer").length);
                    if ($(this).find(".timer").length == 0){
                        $(this).append("<input type='number' class = 'timer' placeholder='timer' max='2147483648 '>");
                    }
                })
            } else {
                $(".timerE").each(function(i, e) {
                    console.log(i+"번째, length = "+$(this).find(".timer").length);
                    if ($(this).find(".timer").length == 0){
                        $(this).append("<input type='number' class = 'timer' placeholder='timer' max='2147483648 '>");
                    }
                })
            }
        });

    //타이머 일괄삭제
        $(".timerOut").click(function() {
            if (radio_check() == "client") {
                $(".timerH *").remove();
            } else {
                $(".timerE *").remove();
            }
        });

        //HOST, EQ별 timer 보여지기
        $(document).off().on("click", ".radio", function() {
            if (radio_check() == "client") {
                //$(".radio").removeClass("active");
                $(this).addClass("active");
                $('#HostName').css('color', 'red');
                $('#EqName').css('color', 'gray');
                $('.timerE').css('display', 'none');
                $('.timerH').css('display', 'block');
            } else if (radio_check() == "eq") {
                //$(".radio").removeClass("active");
                $(this).addClass("active");
                $('#HostName').css('color', 'gray');
                $('#EqName').css('color', 'red');
                $('.timerE').css('display', 'block');
                $('.timerH').css('display', 'none');
            }
        });

		//검색 이벤트
		$(document).on("keyup search", "#searchScenario", function() {
			searchLogic("searchScenario", "scenarioBtn");
		});
		$(document).on("keyup search", "#searchCommand", function() {
			searchLogic("searchCommand", "btn-primary");
		});
		$(document).on("keyup search", "#searchResponse", function() {
			searchLogic("searchResponse", "bg-gradient-danger");
		});

        //시나리오 만들기 취소 버튼
        $("#cancelscenario").click(function() {
            clear();
        });

        $(".timer").draggable({ /* 끌어올떄 */
        appendTo : 'body',
        containment : '#scenariotest',
        scroll : false,
        helper : 'clone',
        opacity : "0.3"
        });
        //timer drag&drop
        $(document).on("mousedown", ".timer", function() {
            if (radio_check() == "client") {
                $('.timerH').droppable({
                accept : ".timer", // 드롭시킬 대상 요소
                activeClass : function (){
                    $(this).css('border', 'solid 1px gray');
                },
                drop : function(event, ui) {
                    if ($(this).find(".timer").length == 0) {
                        $(this).append("<input type='number' class = 'timer' placeholder='timer' max='2147483648 '>");
                    }
                },
                deactivate:function(e, ui){
                    $(this).css('border','');
                }
                });
            } else {
                $('.timerE').droppable({
                accept : ".timer", // 드롭시킬 대상 요소
                activeClass : function (){
                    $(this).css('border', 'solid 1px gray');
                },
                active : function(event, ui) {

                },
                drop : function(event, ui) {
                    if ($(this).find(".timer").length == 0) {
                        $(this).append("<input type='number' class = 'timer' placeholder='timer' max='2147483648 '>");
                    }
                },
                deactivate:function(e, ui){
                    $(this).css('border','');
                }
                });
            }
        });

        //시나리오 만들기 저장 버튼
        $("#insertscenario").click(function() {
            ValueCheck();
            var scenarioName = $(".scenarioName").val();
            var side = radio_check();
            var messageFrames = new Array();
            var timer = new Array();
            var transaction = $(".transaction").val();

            if (scenarioName == "") {
                alert("Scenarioname 이름을 입력하세요.");
            } else if (rstData.length == 0) {
                alert("메세지를 선택하고 저장해주세요.");
            } else {
                timer = get_timer(side);
                for (var i = 0; i < scenList.length; i++) { // 중복된 이름 확인
                    if (scenarioName == scenList[i]) {
                        if (confirm("같은 이름의 시나리오 이름이 있습니다. \n해당 이름의 내용을 수정하겠습니까? ") == true) {
                            frames = insertScenarioData();
                            messageFrames = frames;

                            alert("등록되었습니다");
                            var scenario = {
                            "name" : scenarioName,
                            "side" : side,
                            "messageFrames" : messageFrames,
                            "timer" : timer,
                            "transaction" : transaction
                            }

                            var result = ajaxScenario("put", eqName, JSON.stringify(scenario));
                            if (result.code == 200) {
                                setGlobalValue("Scenario : " + scenarioName, JSON.stringify(scenario), 1);
                            } else {
                                console.log(result.code);
                            }
                        } else {
                            alert("수정이 아니면 같은 이름은 등록할 수 없습니다.");
                            return;
                        }
                        break;
                    }
                }
                if (i == scenList.length) { //이름이 중복되지 않았을 때
                    scenList.push(scenarioName);
                    frames = insertScenarioData();
                    messageFrames = frames;

                    var scenario = {
                    "name" : scenarioName,
                    "side" : side,
                    "messageFrames" : messageFrames,
                    "timer" : timer,
                    "transaction" : transaction
                    }

                    var result = ajaxScenario("POST", eqName, JSON.stringify(scenario));
                    if (result.code == 200) {
                        $("#scenList").append("<button class = 'btn btn-block btn-default scenarioBtn' id = '" + scenarioName + "' value = '" + scenarioName + "' onmousedown=\"clickedline(this.id)\" >" + scenarioName + "</button>");
                        setGlobalValue("Scenario : " + scenarioName, JSON.stringify(scenario), 1);
                    } else {
                        console.log(result.code);
                    }
                    clear();
                }
            }
        });
        
     	// 공백 입력 막기
        $(document).on("keyup", ".scenarioName", function(e) {
            console.log("");
            $('.scenarioName').val($('.scenarioName').val().replace(/ /gi, ''));
            
        });

        //시나리오 삭제 클릭시 이벤트
        $("#deletescenario").click(function() {
            var scenarioName = $(".scenarioName").val();
            var i = 0;
            if (scenarioName == "") {
                alert("삭제할 Scenarioname 이름을 입력하세요.");
            } else {
                for (i; i < scenList.length; i++) { // 중복된 이름 확인
                    if (scenarioName == scenList[i]) {
                        alert("삭제되었습니다");
                        $('#scenarioList').find('#scenList #' + scenarioName).remove();
                        scenList.splice(scenList.indexOf(scenarioName), 1);
                        break;
                    }
                    if (i == scenList.length) {
                        alert("입력한 이름의 시나리오가 존재하지 않습니다.");
                    }
                }
            }
            var result = ajaxScenario("delete", eqName, scenarioName);
            if (result.code == 200) {
                deleteGlobalValue("Scenario : " + scenarioName);
            } else {
                console.log(result.code);
            }
            clear();
        });

        //시나리오 메세지프레임 리스트 드래그
        $(function() {
            $("#sortable").sortable({
            containment : "#sortable",
            axis : "y"
            });
            $("#sortable").disableSelection();
        });
		scenList
		/* Scenario sort */
		var scenDesc = false;
		$("#scenSortBtn").click(function() {
			sortUnorderedList("scenList", scenDesc);
			scenDesc = !scenDesc;
			return false;
		});
		/* cmd sort */
		var cmdDesc = false;
		$("#cmdSortBtn").click(function() {
			sortUnorderedList("CmdList", cmdDesc);
			cmdDesc = !cmdDesc;
			return false;
		});
		/* rsp sort */
		var rspDesc = false;
		$("#rspSortBtn").click(function() {
			sortUnorderedList("ResList", rspDesc);
			rspDesc = !rspDesc;
			return false;
		});
    });


	function scrollDown() {
		var objDiv = document.getElementById("addhosteq");
		objDiv.scrollTop = objDiv.scrollHeight;
	}

    //addhosteq 정리
    function clear() {
        $(".transactionTimer").val("");
        $("#sortable *").remove();
        $("#unsort *").remove();
        $(".scenarioName").val("");
        lineNumber = 0;
    }

    function ValueCheck() {
        rstData = [];
        $('#addhosteq').find('.c_name').each(function(i, e) {
            rstData.push($(e).text());
        })
    }

    //페이지의 timer 정보를 가져옴
    function get_timer(side) {
        var timer = new Array();
        var time = 0;
        if (isNaN(time = $(".transactionTimer").val() - ''))
            time = 0;
        timer.push(time);
        var count = $(".line").length;
        if (side == "client") {
            $('#addhosteq').find('.line').each(function(i, e) {
                if (isNaN(time = $(e).find(" .timerH" + " .timer").val() - ''))
                    time = 0;
                timer.push(time);
            })
        } else {
            $('#addhosteq').find('.line').each(function(i, e) {
                if (isNaN(time = $(e).find(" .timerE" + " .timer").val() - ''))
                    time = 0;
                timer.push(time);
            })
        }
        return timer;
    }

    //command, response 클릭시 이벤트 처리
    function clickCommand(clicked_id) {
        ////lineNumber
        if (event.which == 1) {
            clicked_class = $("#" + clicked_id).attr('class');
            if (clicked_class == 'btn btn-block btn-primary') { //command클릭시
                mkLine('command', lineNumber, clicked_id);
            } else if (clicked_class == 'btn btn-block bg-gradient-danger') { //response클릭시
                mkLine('response', lineNumber, clicked_id);
            }
			scrollDown();
        }
        lineNumber++;
    }

    //시나리오 데이터 뽑기
    function insertScenarioData() {
        ValueCheck();
        var frames = new Array();
        var frametype;
        /* 메세지 갯수만큼 내용 뽑기 */
        for (var i = 0; i < rstData.length; i++) {
            // 리스트에 생성된 객체 삽입
            frametype = $("#" + rstData[i]).attr('value');
            var frame = new Object();
            frame.name = rstData[i];
            frame.type = frametype;
            frames.push(frame);
        }
        return frames;
    }

    function cardHeight() { /* card height 화면 꽉 차게 */
        var h2 = window.innerHeight;
        $(".card").height(h2 * 0.80);
    }

    function radio_check() {
        if ($('input[name="radio"]:checked').val() == "client")
            return "client";
        else
            return "eq";
    }

    //쿠키의 timer정보를 입력받아 화면에 뿌림
    function mkTimer(timer) {
        var time;
        $(".transactionTimer").val(timer.splice(0, 1));
        var count = $(".line").length;
        side = radio_check();
        if (side == "client") {
            $('#addhosteq').find('.line').each(function(i, e) {
                if ((time = timer.splice(0, 1)) != 0) {
                    $(e).find(" .timerH").append("<input type='number' class = 'timer' value = "+time+" placeholder='timer'>");
                }
            });
        } else {
            $('#addhosteq').find('.line').each(function(i, e) {
                if ((time = timer.splice(0, 1)) != 0) {
                    $(e).find(" .timerE").append("<input type='number' class = 'timer' value = "+time+" placeholder='timer'>");
                }
            });
        }
    }

    //시나리오 모델링 부분
    function mkLine(side, lineNumber, lineName) {

        var timerH = "";
        var timerE = "";
        if (radio_check() == "client") {
            timerH = "<div class='timerH' style ='display:block'/>";
            timerE = "<div class='timerE' style ='display:none'/>";
        } else {
            timerH = "<div class='timerH' style ='display:none'/>";
            timerE = "<div class='timerE' style='display: block'/>";
        }
        if (lineNumber == 0) {
            var add = "<div class='line row addtimer' id = 'line0'>"
            + "<div class='col-md-2'>" + timerH + "</div>" 
            + "<div class='col-md-1'><div class='host_l' ></div></div>" 
            + "<div class='col-md-6'/>" 
            + "<div class='col-md-1'><div class='eq_1'></div></div>" 
            + "<div class='col-md-2'>" + timerE + "</div>" 
            + "</div>";
            $(add).appendTo("#unsort");
        }
        lineNumber++;
        if (side == 'command') {
            timerE = "";
            arrow = "<div class='col-md-6' style='padding: 0px;'>" 
            + "<div class='row' style='padding: 0px;'>" 
            + "<div class = 'col-md-11' style='padding: 0px;'>" 
            + "<div class='c_name' style='padding: 0px;'>" + lineName + "</div>" 
            + "<hr/>"+"</div>" 
            + "<div class='arrowright'style='padding: 0px;' >▷</div>" 
            + "</div>"
            + "</div>";
        } else {
            timerH = "";
			arrow = "<div class='col-md-6' style='padding: 0px;'>" 
			+ "<div class='row' style='padding: 0px;'>" 
			+ "<div class='arrowleft' style='padding: 0px;'>◁</div>" 
			+ "<div class = 'col-md-11' style='padding: 0px;'>" 
			+ "<div class='c_name' style='padding: 0px;'>" + lineName + "</div>" 
			+ "<hr/>"+"</div>" 
			+ "</div>"
			+ "</div>";
        }
        var text = "<div class='line row' id = 'line" + lineNumber + "' onmousedown=\"clickedline(this.id)\"' >" 
        + "<div class='col-md-2' >" + timerH + "</div>" 
        + "<div class='col-md-1'><div class='host_l' ></div></div>" 
        + arrow 
        + "<div class='col-md-1'><div class='eq_1'></div></div>" 
        + "<div class='col-md-2'>" + timerE + "</div>" 
        + "</div>";
        $(text).appendTo("#sortable");
    }



    // 메세지프레임, 시나리오버튼 클릭/우클릭
    function clickedline(clicked_id) {
        clicked_class = $('#' + clicked_id).attr('class');
        if (event.which == 1) {
            if (clicked_class == "btn btn-block btn-default scenarioBtn") {
                clear();
                var ckData = JSON.parse(getGlobalValue("Scenario : " + clicked_id));
                var frame = ckData.messageFrames; //messageFrames
                var timer = ckData.timer;
				if (ckData.side == 'client') {
					$("#Hostbtn").prop("checked", true).change();
					$("#Eqbtn").prop("checked", false).change();
					$('#HostName').css('color', 'red');
					$('#EqName').css('color', 'gray');
					$('.timerE').css('display', 'none');
					$('.timerH').css('display', 'block');
				} else {
					$("#Eqbtn").prop("checked", true).change();
					$("#Hostbtn").prop("checked", false).change();
					$('#HostName').css('color', 'gray');
					$('#EqName').css('color', 'red');
					$('.timerE').css('display', 'block');
					$('.timerH').css('display', 'none');
				}
                frame.forEach(function(frame) {
					if(frame.type=='command'){
						mkLine('command', lineNumber, frame.name);}
					else {mkLine('resopnse', lineNumber, frame.name);}
                    lineNumber++;
                });
                mkTimer(timer);
                $("#scenarioname").val(clicked_id);
            }
        } else if (event.which == 3) {
            var clickdivname;
            if (clicked_class == "btn btn-block btn-default scenarioBtn") {
                clickdivname = 'div button#'
            } else
                clickdivname = 'div#';
            $(clickdivname + clicked_id).contextmenu(function(e) {
                //Get window size:
                var winWidth = $(document).width();
                var winHeight = $(document).height();
                //Get pointer position:
                var posX = e.pageX;
                var posY = e.pageY;
                //Get contextmenu size:
                var menuWidth = $(".contextmenu").width();
                var menuHeight = $(".contextmenu").height();
                //Security margin:
                var secMargin = 10;
                //Prevent page overflow:
                if (posX + menuWidth + secMargin >= winWidth && posY + menuHeight + secMargin >= winHeight) {
                    //Case 1: right-bottom overflow:
                    posLeft = posX - menuWidth - secMargin + "px";
                    posTop = posY - menuHeight - secMargin + "px";
                } else if (posX + menuWidth + secMargin >= winWidth) {
                    //Case 2: right overflow:
                    posLeft = posX - menuWidth - secMargin + "px";
                    posTop = posY + secMargin + "px";
                } else if (posY + menuHeight + secMargin >= winHeight) {
                    //Case 3: bottom overflow:
                    posLeft = posX + secMargin + "px";
                    posTop = posY - menuHeight - secMargin + "px";
                } else {
                    //Case 4: default values:
                    posLeft = posX + secMargin + "px";
                    posTop = posY + secMargin + "px";
                }
                //Display contextmenu:
                $(".contextmenu").css({
                "left" : posLeft,
                "top" : posTop
                }).show();
                //Prevent browser default contextmenu.
                return false;
            });
            //Hide contextmenu:
            $(document).contextmenu(function() {
                $(".contextmenu").hide();
            });
            $(document).click(function() {
                $(".contextmenu").hide();
            });
            $("#btnDelete").off().click(function() {
                if (clicked_class == "btn btn-block btn-default scenarioBtn") {
                    $('#scenarioList').find('#scenList #' + clicked_id).remove();
                    scenList.splice(scenList.indexOf(clicked_id), 1);
                    var result = ajaxScenario("delete", eqName, clicked_id);
                    if (result.code == 200) {
                        deleteGlobalValue("Scenario : " + clicked_id);
                    } else {
                        console.log(result.code);
                    }
                } else {
                    ValueCheck();
                    if (rstData.length == 1) {
                        $('#unsort').find('div').remove();
                        lineNumber = 0;
                    }
                    $(document).find('div#' + clicked_id).remove();
                }
                $(".contextmenu").hide();
            });
        }
    };

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

	//내림차순 오름차순 정렬
	function sortUnorderedList(ul, sortDescending) {	// sort 함수
		if (typeof ul == "string")
			ul = document.getElementById(ul);
		var lis = ul.getElementsByTagName("button");
		var vals = [];

		for (var i = 0, l = lis.length; i < l; i++)
			vals.push(lis[i].outerHTML);

		vals.sort();

		if (sortDescending)
			vals.reverse();

		for (var i = 0, l = lis.length; i < l; i++)
			lis[i].outerHTML = vals[i];

	}
</script>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<!-- common nav -->
		<%@include file="include/common_nav.jsp"%>
		<!-- /.common nav -->

		<!-- common side -->
		<%@include file="include/common_side.jsp"%>
		<!-- ./common side -->

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Main content -->
			<section class="content">
			<div class="container-fluid">
				<div class="row">
					<!--시나리오 리스트-->
					<div class="scenario-div col-md-3">
						<div class="card">
							<div class="card-header">
								<div class="left card-title">Scenario List</div>
								<button id="scenSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="scenarioList">
								<div class="post" id="searchScenario-div">
									<div class="input-group input-group-sm">
										<input id = "searchScenario" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="scenList"></div>
							</div>
						</div>
					</div>
					<!--Command 리스트-->
					<div class="commandList-div col-md-2">
						<div class="card">
							<div class="card-header">
								<div class="center card-title">Command</div>
								<button id="cmdSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="commandList">
								<div class="post" id="searchCommand-div">
									<div class="input-group input-group-sm">
										<input id = "searchCommand" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="CmdList"></div>
							</div>
						</div>
					</div>
					<!--시나리오 실행 부분-->
					<div class="scenariotest-div col-md-5">
						<div class="card">
							<div class="card-body" id="scenariotest">
								<div class="row">
									<div class="col-md-5" id="ckHostEq">
										<div class="btn-group " data-toggle="buttons">
											<label class="btn btn-secondary"> <input type="radio"
												class="radio" name="radio" id="Hostbtn" value="client"
												checked="checked" />Client
											</label> <label class="btn btn-secondary"> <input
												type="radio" class="radio" name="radio" id="Eqbtn"
												value="eq" />EQ
											</label>
										</div>
									</div>
									<div>
										<div class="row">
											<div class="timer"
												style="margin-left: auto; margin-right: auto; height: auto; width:auto;text-align: center;">timer(ms)</div>
										</div>
										<div class="row">
											<button class="timerIn page-link"
												style="width: auto; margin-top: 2%;">+</button>
											<button class="timerOut page-link"
												style="width: auto; margin-top: 2%;">-</button>
										</div>
									</div>
									<!--트랜잭션 타이머-->
									<div class="col-md-3" style="margin-left: 10%;">
										<input type="number" class='transactionTimer'
											placeholder="Transaction Timer">
									</div>
								</div>
								<div class="row" style="margin-top: 5%">
									<div class="col-md-6">
										<!--style="border: 1px solid green;"-->
										<h3 id="HostName">Client</h3>
									</div>
									<div class="col-md-6">
										<!--style="border: 1px solid green;"-->
										<h3 id="EqName">EQ(HOST)</h3>
									</div>
								</div>
								<!--Host 실행되는 부분-->
								<div class="host-div row make" id="addhosteq">
									<div class="host-div row" id="sortable"></div>
									<div class="host-div row" id="unsort"></div>
								</div>
								<!--시나리오 이름 및 저장 취소 부분-->
								<div class="row" id="buttonZone">
									<div class="col-md-6 scenarioinsertname">
										Name:<input type="text" class='scenarioName' id="scenarioname"
											value="" style="width: 80%">
									</div>
									<div class="col-md-6">
										<div class="row">
											<button class="btn btn-block btn-success btn-sm"
												id="insertscenario">Save</button>
											<button class="btn btn-block btn-secondary btn-sm"
												id="cancelscenario">Cancel</button>
											<button class="btn btn-block btn-danger btn-sm"
												id="deletescenario">Delete</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!--Response 리스트-->
					<div class="responseList-div col-md-2">
						<div class="card">
							<div class="card-header">
								<div class="center card-title">Response</div>
								<button id="rspSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="responseList">
								<div class="post" id="searchResponse-div">
									<div class="input-group input-group-sm">
										<input id = "searchResponse" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="ResList"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /.container-fluid -->

			</section>
			<!-- /.content -->
		</div>

		<!-- common footer -->
		<%@include file="include/common_footer.jsp"%>
		<!-- ./common footer -->

	</div>
	<ul class="contextmenu">
		<li><a id="btnDelete">Delete</a></li>
	</ul>
</body>
</html>