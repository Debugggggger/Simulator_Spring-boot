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

    <title>Simulator</title>
    <!-- Made CSS -->
    <link rel="stylesheet" href="/resources/dist/madecss/excution.css">
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
    <!-- timepicker -->
    <script src="/resources/plugins/timepicker/jquery.fugit.js"></script>
    <link rel="stylesheet" href="/resources/plugins/timepicker/jquery.fugit.css">
    <!-- inputMask -->
    <script src="/resources/plugins/inputmask/inputmask/jquery.inputmask.js"></script>
    <!-- 우리의 유틸 -->
    <script src="/resources/plugins/util/ajaxUtil.js"></script>
    <script src="/resources/plugins/util/cookiesUtil.js"></script>
    <script src="/resources/plugins/util/checksum.js"></script>
    <script src="/resources/plugins/util/madeChecksum.js"></script>

    <style type="text/css">
        input {
            width: 20%;
            height: 25px;
            margin: 1.5% 1% 1% 3%;
            text-align: center;
        }

        .scenarioBtn {
            width: 200px;
            height: auto;
            margin: auto;
        }

        .conDel {
        	position:fixed;
            top: 0; 
    		z-index: 999;
    		margin: 0;
    		padding: 0 10px;
        }

        .del {
            position: absolute;
            height: 24px;
            width: 24px;
            padding: 0;
            top: 0px;
            right: 0px;
        }

        .statistic * {
            padding-top: 0px;
            padding-bottom: 0px;
            padding-left: 3px;
            padding-right: 3px;
            margin: 0px;
        }

        .datepicker {
            width: 145px;
            padding: 0;
        }

        .timepicker {
            width: 20%;
            padding: 0;
        }

        .flowleft {
            float: left;
        }
    </style>

    <script type="text/javascript">
        var sock;
        var filePath;
        var requests = new Array();
        filePath = ajaxPath();
        var scenList = new Array(); // 저장된 시나리오 리스트
        var eqName; // 현재 선택된 기기의 이름
        var lineNumber; // 시나리오 내부의 line 번호 (mkline에서 사용)
        var lselect; // 현재 왼쪽에 선택된 컴포트
        var Rselect; // 현재 오른쪽에 선택된 컴포트
        var clicked_com; // 가장최근 선택된 컴포트
        var clicked_class;
        var nameList = new Array();
        var whatid;
        var console_data = new Array(); // 콘솔에 표기할 데이터(hex,ascii,length)
        var countScenario = 0;
        var excutionscenario = true; // 현재 프로그램이 실행중인지 판별
        var DisSuccess = new Array(); // 시나리오별 메세지 프레임의 갯수
        var clicklf = new Array();
        var clickedconsole = true;
        var save_end = new Array(); // 실행 직전 사용자가 end값을 선택했는지 판별
        
        
        $(document).ready(function () {

            sock = new WebSocket("ws://" + window.location.hostname + ":" + window.location.port + "/api/echo");
            // 소켓 오픈
            sock.onopen = function () {
            };
            // 메시지 수신
            sock.onmessage = function (event) {
                var result = JSON.parse(decodeURI(event.data));
                if (result.message == "Port") {
                    // alert("모든 포트 닫음");
                    countScenario = 0;
                } else if (result.message == "Statistics") {
                    insert_statistics(result, testResult);
                } else {
                    insert_con(result, testResult);
                }
            };
            cardHeight();
            $("#excutionbtn").show();
            $("#excutionstopbtn").hide();
            var testResult = ajaxPorts().data;
            if (testResult == null) { // port 연결 안됬을때
                alert("포트를 찾을 수 없습니다.");
                testResult = [ "non port"];
                //testResult = ["c1", "c2", "c3", "c4"];
                document.getElementById("excutionbtn").disabled = true;
                document.getElementById("excutionstopbtn").disabled = true;
            }
            for (var i = 0; i < testResult.length; i++) {
                deleteGlobalValue("Scenarioinfo : " + testResult[i]);
                save_end[i]=false; //배열 초기화
            }
            set_tab("left", testResult);
            set_tab("right", testResult);
            lselect = testResult[0];
            Rselect = testResult[0];
            $(".excutioncount:first").attr('disabled', false);
            /* 처음  페이지 로드 */
            if (document.cookie.indexOf("eq : eqName") != -1) {    // eqName cookie 있으면
                var ckData = JSON.parse(getCookie("eq : eqName"));
                $("#eqSelect").val(ckData.eqName).prop("selected", true);
                load(ckData.eqName);
                eqName = ckData.eqName;
            } else {
                console.log("eqName cookie 가 없음 : error");
            }
            //검색 이벤트
            $(document).on("keyup search", "#searchScenario", function () {
                searchLogic("searchScenario", "scenarioBtn");
            });

            $(document).on("mousedown", ".scenarioBtn", function (e) {
                $('.tab_body').droppable({
                    accept: ".scenarioBtn", // 드롭시킬 대상 요소
                    drop: function (event, ui) {
                        var drop_class = $(this).attr('class');
                        testResult.forEach(function (com) {
                            if (drop_class.indexOf(com) > 0) comport = com;
                        });

                        if (excutionscenario == true) {
                            var temp = "." + comport + " ";
                            $(temp + ".draw *").remove();
                            $(temp + ".draw").append("<div id = 'sortable'></div>");
                            $(temp + ".draw").append("<div id = 'unsort'></div>");
                            con_del(temp);
                            scenList.forEach(function (scen) {
                                if (scen.name == ui.draggable.attr('id')) {
                                    $(temp + ".transaction").val(scen.timer[0]);
                                    $(temp + ".side").val(scen.side);
                                    var i = 0;

                                    scen.messageFrames.forEach(function (msgf) {
                                        mkLine(temp, scen.side, msgf.type, i, msgf.name);
                                        i++;
                                    });
                                    mkTimer("#left " + temp, scen.side, scen.timer);
                                    mkTimer("#right " + temp, scen.side, scen.timer);
                                    var scenario = {
                                        "name": scen.name,
                                        "messageFrames": scen.messageFrames,
                                        "comport": comport,
                                        "side": scen.side,
                                        "timer": scen.timer,
                                    }

                                    makenameList(nameList, comport);

                                    $("#left ." + comport).find('.excutioncount').val("");
                                    $("#right ." + comport).find('.excutioncount').val("");
                                    setGlobalValue("Scenarioinfo : " + comport, JSON.stringify(scenario), 1);
                                }
                            });
                        } else {
                            alert("실행중에서는 시나리오를 추가 할 수없습니다.");
                            return false;
                        }
                    }
                });
            });

            /* EQ 바꿀 때 마다 페이지 새로드 */
            $('body').on("change", "#eqSelect", function () {
                eqName = $("#eqSelect").val();
                msgElement = new Array;
                cmpList = new Array();
                $(".scenarioList *").remove();
                scen_del("");
                con_del("");
                scenList = new Array();
                if (document.cookie.indexOf("eq : eqName") != -1) {      // eqName cookie 있으면
                    clearAllCookies();
                    clearAllGlobalValue();
                    setCookie("eq : eqName", JSON.stringify({"eqName": eqName}), 1);
                    var ckData = JSON.parse(getCookie("eq : eqName"));
                    $("#eqSelect").val(ckData.eqName).prop("selected", true);
                    load(ckData.eqName);
                } else {
                    console.log("eqName cookie 가 없음 : error");
                }
            });


            function load(eqName) {
                $("body").addClass("sidebar-collapse");
                var scenariolist = ajaxScenario("GET", eqName, null);
                console.log(scenariolist);
                if (scenariolist.code == 200) {
                    scenariolist.data.forEach(function (temp) {
                        scenList.push(temp);
                        $("#scenarioList").find('.scenarioList').append("<div class = 'btn btn-block btn-default scenarioBtn' id = '" + temp.name + "' value = '" + temp.name + "' >" + temp.name + "</div>");
                        setGlobalValue("Scenario : " + temp.name, JSON.stringify(scenario), 1);
                        clicked_com = testResult[0];
                    })
                } else {
                    console.log(scenariolist.message);
                }
                $(".scenarioBtn").draggable({ /* 끌어올떄 */
                    appendTo: 'body',
                    scroll: false,
                    helper: 'clone',
                    opacity: "0.3"
                });
            }

            //On Click Event
            clicklf.unshift(testResult[0]);
            clicklf.push(testResult[0]);
            $(document).on("click", "ul.tab_head_list li", function (e) {
                //클릭한 comport 왼쪽 오른쪽 저장
                clicked_com = $(this).text();
                var clicked_class = $(this).attr('class');
                var side = "#" + clicked_class + " ";

                if (clicked_class == "left") {
                    lselect = $(this).text();
                    clicklf.shift();
                    clicklf.unshift(lselect);
                } else {
                    Rselect = $(this).text();
                    clicklf.pop();
                    clicklf.push(Rselect);
                }
                if (excutionscenario == false) {
                    $(".excutioncount").attr('disabled', true);
                    $("#left .excutioncount").attr('disabled', true);
                } else {
                    if (lselect == Rselect) {
                        $(".excutioncount").attr('disabled', true);
                        $("#left .excutioncount").attr('disabled', false);
                    } else {
                        $(".excutioncount").attr('disabled', false);
                    }
                }
                $(side + "ul.tab_head_list li").removeClass("active"); //Remove any "active" class
                $(this).addClass("active"); //Add "active" class to selected tab
                $(side + ".tab_body").hide(); //Hide all tab content
                var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
                $(activeTab).fadeIn(); //Fade in the active ID content
                return false;
            });


            $(document).on("keyup", ".excutioncount", function (e) {
                content = $(this).val();
                var whatclass;
                whatclass = $(this).attr('class');
                // var scenDatas;
                var objTarget = e.srcElement || e.target;
                if (objTarget.type == 'text') {
                    var value = objTarget.value;
                    if ((nameList.length == 0 || nameList.indexOf(clicked_com) == -1) && clicklf.indexOf(clicked_com) != -1) {
                        alert("시나리오 선택 후 try를 입력해주세요");
                        $(this).val("");
                    } else {
                        if ((/[ㄱ-ㅎㅏ-ㅡ가-핳a-zA-Z]/.test(value) || value == 0) && objTarget.value != "infinity") {
                            objTarget.value = objTarget.value.replace(/[0ㄱ-ㅎㅏ-ㅡ가-핳a-zA-Z]/g, ''); // g가 핵심: 빠르게 타이핑할때 여러 한글문자가 입력되어 버린다.
                            alert("0이 아닌 숫자와 무한대만 선택하여 입력할 수 있습니다. ");
                            return false;
                        } else if (whatclass == "count right excutioncount") {
                            var count = $("#right ." + Rselect).find('.excutioncount').val();
                            $("#left ." + Rselect).find('.excutioncount').val(count);
                            clicked_com = clicklf[1];
                        } else {
                            var count2 = $("#left ." + lselect).find('.excutioncount').val();
                            $("#right ." + lselect).find('.excutioncount').val(count2);
                            clicked_com = clicklf[0];
                        }

                    }
                }
                return false;
            });

            $(document).on("click", ".scenDel", function (e) {
                var clicked_class = $(this).attr('class');
                var side = "";
                if (excutionscenario == true) {
                    if (clicked_class.indexOf('left') > 0) {
                        side = '.' + lselect + " ";
                        deleteGlobalValue("Scenarioinfo : " + lselect);
                        nameList.splice(nameList.indexOf(lselect), 1);
                    } else {
                        side = '.' + Rselect + " ";
                        deleteGlobalValue("Scenarioinfo : " + Rselect);
                        nameList.splice(nameList.indexOf(Rselect), 1);
                    }
                    scen_del(side);
                    con_del(side);
                } else {
                    alert("실행중에서는 시나리오를 지울 수 없습니다.");
                    return false;
                }
            });

            $(document).on("click", ".conDel", function (e) {
                if (excutionscenario == true) {
                    var clicked_class = $(this).attr('class');
                    var side = "";
                    if (clicked_class.indexOf('left') > 0) side = '.' + lselect + " ";
                    else side = '.' + Rselect + " ";
                    con_del(side);
                } else {
                    alert("실행중에서는 콘솔을 지울 수 없습니다.");
                    return false;
                }
            });

            //실행 버튼 클릭시 이벤트
            $("#excutionbtn").click(function () {
            	$(".datepicker").css("border","");
            	$(".datepicker").attr('disabled', true);
                requests.splice(0, requests.length);
                var scenData;
                var eqmaincontent = new Array();
                var eqcounting = new Array();
                var tryisnotnull = true;
                testResult.forEach(function (e, i) {
                    console_data.push(new Array);
                    console_data[i].push(e);
                })
                for (var i = 0; i < nameList.length; i++) {
                    scenData = JSON.parse(getGlobalValue("Scenarioinfo : " + nameList[i]));
                    eqmaincontent.push(scenData);
                }
                for (var i = 0; i < eqmaincontent.length; i++) {
                    var trycounting = $("." + eqmaincontent[i].comport).find('.excutioncount').val();
                    eqcounting.push(trycounting);
                    if (eqcounting.indexOf("") != -1) {
                        alert("실행 할 시나리오 중 try 횟수 공백이 있습니다. 다시 설정해주세요.");
                        console.log(eqcounting);
                        tryisnotnull = false;
                        break;
                    }
                    tryisnotnull = true;
                }
                if (tryisnotnull == true) {
                    countScenario = eqmaincontent.length;
                    for (var i = 0; i < eqmaincontent.length; i++) {
                    	var com_index_int = get_index(eqmaincontent[i].comport,testResult);
                        var s_dt = get_watch("s", eqmaincontent[i].comport);
                        var e_dt = 0;
                        if(save_end[com_index_int]){ //사용자가 날짜를 셋팅하지 않았다면 0을 넣음
                        	e_dt = get_watch("e", eqmaincontent[i].comport);
                        	save_end[com_index_int]=false;
                        }else{
                        	e_dt = 0;
                        	save_end[com_index_int]=false;
                        }
                        if(s_dt!=0||e_dt!=0){
                        	$(" ." + eqmaincontent[i].comport + " .console").append("<div class = 'consoletext'> 예약 시간 : "+s_dt+" ~ "+e_dt
                                    + "</div>");
                        }
                        con_del("." + eqmaincontent[i].comport + " ");
                        var trycounting = $("#left ." + eqmaincontent[i].comport).find('.excutioncount').val();
                        eqcounting.push(trycounting);
                        if (trycounting == "infinity") {
                            trycounting = -1;
                        }
                        var exeParam = {
                            "eqName": eqName,
                            "path": filePath,
                            "port": eqmaincontent[i].comport,
                            "scenarioName": eqmaincontent[i].name,
                            "loop": trycounting,
                            "reservationStart": s_dt,
                            "reservationEnd": e_dt
                        };
                        requests.push(exeParam);

                        $(".excutioncount").attr('disabled', true);
                        $("#left .excutioncount").attr('disabled', true);

                        $("#excutionbtn").hide();
                        $("#excutionstopbtn").show();
                        excutionscenario = false;
                    }
                }
                //console.log(requests);
                sock.send(JSON.stringify(requests));
            });
            
            

            function get_watch(s, com) {
                var date;
                if ((date = $("." + com + " ." + s + "_datepicker").val()) == "") {
                    date = 0;
                } else {
                    date = date + ".00"
                }
                return date;
            }

            // //실행 중지 클릭시 이벤트
            // $("#excutionstopbtn").click(function () {
            //     sock.send("CLOSE ALL PORT");
            //     $("#excutionbtn").show();
            //     $("#excutionstopbtn").hide();
            //     if (lselect == Rselect) {
            //         $(".excutioncount").attr('disabled', true);
            //         $("#left .excutioncount").attr('disabled', false);
            //     } else {
            //         $(".excutioncount").attr('disabled', false);
            //     }
            //     excutionscenario = true;
            // });

            $(document).on("mousedown", "#left", function (e) {	    // 왼쪽 tab console drag 했을 때 모션
                if (clicklf[0] == clicklf[1]) {	// 왼 == 오
                    consoleDragResize("#left_" + clicklf[0] + ", #right_" + clicklf[1]);
                } else {	// 왼 != 오 이면 왼쪽만 움직이기
                    consoleDragResize("#left_" + clicklf[0]);
                }
            });
            $(document).on("mousedown", "#right", function (e) {	    // 오른쪽 tab console drag 했을 때 모션
                if (clicklf[0] == clicklf[1]) {	// 왼 == 오
                    consoleDragResize("#left_" + clicklf[0] + ", #right_" + clicklf[1]);
                } else {	// 왼 != 오 이면 오른쪽만 움직이기
                    consoleDragResize("#right_" + clicklf[1]);
                }
            });

            dragAndDrawHeight();  	// .draw, .drag div 사이즈 조정

            $(".console").click(function(event){
                clickedconsole = false;
            });
            $('html').click(function(e) { 
                if(!$(e.target).hasClass("consoleText")) {
                clickedconsole = true;} 
            });
        });/*document load 끝!*/

     	// a가 배열 b의 몇번째인지 반환
        function get_index(a,b){
        	for(var i=0;i<b.length;i++){
        		if(a==b[i]) return i;
        	}
        	return -1;
        }
        
        function dragAndDrawHeight() { 	// .draw, .drag div 사이즈 조정
            var h = $(".tab_body").innerHeight() - $(".front_body").innerHeight() - $(".console").innerHeight();
            $(".draw").height(h * 0.65);
            $(".drag").height(h * 0.05);
            // 최대 최소 사이즈 조정
            var maxH = $(".tab_body").innerHeight() - $(".front_body").innerHeight();
            $(".console").css("max-height", maxH * 0.99);
            $(".draw").css("max-height", maxH * 0.8);
            $(".console").css("min-height", maxH - (maxH * 0.8) - $(".drag").innerHeight());
        }

        function consoleDragResize(tabId) {	// 콘솔창 사이즈 조정
            var drawH, consoleH;
        	var obj = $(".conDel").offset();
            $(tabId).find(".drag").draggable({
                axis: "y",
                start: function (event, ui) {
                    shiftInitial = ui.position.top;
                    drawH = $(tabId).find(".draw").height();
                    consoleH = $(tabId).find(".console").height();
                },
                drag: function (event, ui) {
                    var shift = ui.position.top;
                    $(tabId).find(".draw").height(drawH + shift - shiftInitial);
                    $(tabId).find(".console").height(consoleH - shift + shiftInitial);
                    $(tabId).find(".conDel").css("top", obj.top + shift - shiftInitial);
                }
            });
        }

        //stop 버튼 동작 이벤트
        function stopexcution() {
            sock.send("CLOSE ALL PORT");
                $("#excutionbtn").show();
                $("#excutionstopbtn").hide();
                if (lselect == Rselect) {
                    $(".excutioncount").attr('disabled', true);
                    $("#left .excutioncount").attr('disabled', false);
                } else {
                    $(".excutioncount").attr('disabled', false);
                }
                $(".datepicker").attr('disabled', false);
                excutionscenario = true;
        }

        //nameList 중복값 방지
        function makenameList(nameList, comport) {
            var dateIndex = nameList.indexOf(comport);
            if (dateIndex == -1) {
                nameList.push(comport);
            } else {
                nameList.splice(dateIndex, 1);
                nameList.push(comport);
            }
        }

        function insert_statistics(data, testResult) {
            var result;
            var text;
            var date;
            var color;
            var index;
            result = JSON.parse(data.data);
            var resultMessage = data.message;

            text = "<br/> runtime :" + result.runtime + "<br/>"
                + " totalScenarioCount :" + result.totalScenarioCount + "<br/>"
                + " successScenarioCount :" + result.successScenarioCount + "<br/>"
                + " totalMessageCount :" + result.totalMessageCount + "<br/>"
                + " successMessageCount :" + result.successMessageCount;
            color = "blue"
            s_s = result.successScenarioCount;
            f_s = result.failedScenarioCount;
            t_s = result.totalScenarioCount;
            s_m = result.successMessageCount;
            f_m = result.failedMessageCount;
            t_m = result.totalMessageCount;
            var milliseconds = parseInt((result.runtime%1000)/10)
            , seconds = parseInt((result.runtime/1000)%60)
            , minutes = parseInt((result.runtime/(1000*60))%60)
            , hours = parseInt((result.runtime/(1000*60*60))%24);
            var runtime = hours + ":" + minutes + ":" + seconds + "." + milliseconds;
            $(" ." + result.port).find(".runtime").val(runtime);
            $(" ." + result.port).find("#s_scen").val(s_s+"("+(s_s/t_s*100).toFixed(2)+"%)");
            $(" ." + result.port).find("#f_scen").val(f_s+"("+(f_s/t_s*100).toFixed(2)+"%)");
            $(" ." + result.port).find("#t_scen").val(t_s);
            $(" ." + result.port).find("#s_message").val(s_m+"("+(s_m/t_m*100).toFixed(2)+"%)");
            $(" ." + result.port).find("#f_message").val(f_m+"("+(f_m/t_m*100).toFixed(2)+"%)");
            $(" ." + result.port).find("#t_message").val(t_m);
            var date = result.resultDate;
            // $(" ." + result.port + " .console").append("<div class = 'consoleText console" + index + " " + result.port + " " + resultMessage + "' style='background:" + color + "'>"
            //     + time + text + "</div>");
            //console.log("통계");
            //console.log(result);
        }

        // 콘솔 추가
        function insert_con(data, testResult) {
            var result = JSON.parse(data.data);
            var text;
            var date;
            var color;
            var index;
            var indexCk = false;
            checksum = result.checksum;
            if (checksum == "" || checksum == null || checksum == undefined || (checksum != null && typeof checksum == "object" && !Object.keys(checksum).length)) {
                // checksum 빈 값 체크
            } else {
                //console.log(checksum.method);
            }
            var resultMessage = data.message;
            var dt = result.resultDate;
            var date = dt.split('.')[0];
            if (resultMessage == "Exception") { //예외에러
                console.log("에러")
            } else if (resultMessage == "Scenario") { // 시나리오
                init_DisSuccess(result.port);
                index = $("." + result.port).find(" .Scenario").length / 2;
                text = " " + result.scenarioName + " " + result.resultMessage;
                if (result.resultMessage != "OK") color = "red"
                else color = "green";
            } else if (resultMessage == "MessageFrame") { // 메세지 프레임
                var accrue = new Array();
                var temp = 0;
                result.componentsLength.forEach(function (e, i) {
                    for (var j = 0; j < e; j++) {
                        accrue.push(temp);
                    }
                    temp++;
                });
                testResult.forEach(function (e, i) {
                    if (e == result.port) {
                        console_data[i].push([result.hexStrings, result.ascStrings, accrue]);
                        DisSuccess[i]++;
                        var place = "." + result.port+" #line"+DisSuccess[i];
                    if (result.resultMessage == "OK") {
                            $(place).find("hr").css('border','solid 2px green');
                            $(place).find(".arrow").css('color','green');
                            }
                    else {
                        color = "red";
                        $(place).find("hr").css('border','solid 2px red');
                        $(place).find(".arrow").css('color','red');
                        }
                    }
                });
                var name = result.frameName;
                var length = result.ascStrings.length;
                index = $("." + result.port).find(" .MessageFrame").length / 2;
                var text = name + " | " + length + " | " + result.resultMessage;
                indexCk = true;
            } else if (resultMessage == "Start") {
                text = "START";
                init_DisSuccess(result.port);
                $(" ." + result.port).find(".s_datepicker").val(date);
            } else { // resultMessage == "End"
                text = "END"
                $(" ." + result.port).find(".e_datepicker").val(date);
                countScenario--;
                if (countScenario == 0) {
                    stopexcution();
                }
            }
            function init_DisSuccess(com){
                for(var i=0;i<testResult.length;i++){ //배열 초기화
                    DisSuccess[i]=0;
                }
                var place = "." + com
                $(place).find("hr").css('border','');
                $(place).find(".arrow").css('color','');
            }

            if (indexCk == true) {
                $(" ." + result.port + " .console").append("<div class = 'consoleText console" + index + " " + result.port + " " + resultMessage + "' style='background:" + color + "'>"
                    + "No." + index + " | " + dt + " | " + text + "</div>");
                scrollDown();
            } else {
                $(" ." + result.port + " .console").append("<div class = 'consoleText console" + index + " " + result.port + " " + resultMessage + "' style='background:" + color + "'>"
                    + dt + " | " + text + "</div>");
                scrollDown();
            }

        }

        // 콘솔 클릭
        $(document).on("mousedown", ".MessageFrame", function (e) {
            var clicked_class = $(this).attr("class").split(' ');
            var parent_class = $(this).parent().attr("class").split(' ');
            var index = parseInt(clicked_class[1].substring(7));
            if (parent_class.indexOf('left') > 0) {
                side = "left";
                com = "#left ." + lselect + " ";
            } else {
                side = "right";
                com = "#right ." + Rselect + " ";
            }
            var rawData = new Array();
            var ascData = new Array();
            console_data.forEach(function (e, i) {
                if (e[0] == clicked_class[2]) {
                    rawData = e[index + 1][0];
                    ascData = e[index + 1][1];
                    length = e[index + 1][2];
                }
            })
            if ($(this).find(".row").length <= 0) {
                $(com + ".consoleText *").remove();
                $(this).append("<div class = 'row detail'><div class = 'rawli'></div><div class = 'ascli'></div></div>");
                var append = com + "." + clicked_class[1];
                rawData.forEach(function (e, i) {
                    if ($(append).find(".raw" + length[i]).length == 0) {
                        $(append).find(".rawli").append("<div class='raw raw" + length[i] + " " + side + "'></div>");
                        $(append).find(".ascli").append("<div class='asc asc" + length[i] + " " + side + "'></div>");
                    }

                    $(append).find(".raw" + length[i]).append("<div class = 'ele' >" + e + "</div>");
                    $(append).find(".asc" + length[i]).append("<div class = 'ele' >" + ascData[i] + "</div>");
                })
            }
        });

        //예약시간 입력 이벤트
        $(document).on("keyup", "#s_date, #s_time, #e_date, #e_time", function (e) {
            datecontent = $(this).val();
            var whatclass;
            whatclass = $(this).attr('class');
            var parentclass = $(this).parents();
            var selectleftright;
            console.log(datecontent);
            for (var i = 0; i < parentclass.length; i++) {
                console.log("들어옴");
                selectleftright = $(parentclass[i]).attr('id');
                console.log(selectleftright);
                if (selectleftright == "left_" + lselect) {
                    console.log("왼쪽 들어옴");
                    console.log(selectleftright);
                    console.log(whatclass);
                    if (whatclass == "datepicker s_datepicker" || whatclass == "timepicker s_timepicker") {
                        var s_countdate = $('#left_' + lselect).find('.statistic #s_date').val();
                        // var s_counttime = $('#left_'+lselect).find('.statistic #s_time').val();
                        $('#right_' + lselect).find('.statistic #s_date').val(s_countdate);
                        // $('#right_'+lselect).find('.statistic #s_time').text(s_counttime);

                    } else {
                        var e_countdate = $('#left_' + lselect).find('.statistic #e_date').val();
                        // var e_counttime = $('#left_'+lselect).find('.statistic #e_time').val();
                        $('#right_' + lselect).find('.statistic #e_date').val(e_countdate);
                        // $('#right_'+lselect).find('.statistic #e_time').text(e_counttime);
                    }
                    break;
                } else if (selectleftright == "right_" + Rselect) {
                    if (whatclass == "datepicker s_datepicker" || whatclass == "timepicker s_timepicker") {
                        var s_countdate = $('#right_' + Rselect).find('.statistic #s_date').val();
                        // var s_counttime = $('#right_'+Rselect).find('.statistic #s_time').val();
                        $('#left_' + Rselect).find('.statistic #s_date').val(s_countdate);
                        // $('#left_'+Rselect).find('.statistic #s_time').text(s_counttime);

                    } else {
                        var e_countdate = $('#right_' + Rselect).find('.statistic #e_date').val();
                        // var e_counttime = $('#right_'+Rselect).find('.statistic #e_time').val();
                        $('#left_' + Rselect).find('.statistic #e_date').val(e_countdate);
                        // $('#left_'+Rselect).find('.statistic #e_time').text(e_counttime);
                    }
                    break;
                }
            }
        });

        $(document).on("click", ".raw", function (e) {
            var clicked_class = $(this).attr("class").split(' ');
            var index = parseInt(clicked_class[1].substring(3));
            var side = clicked_class[2];
            $("#" + side + " .raw").css({'background': '', 'color': ''});
            $("#" + side + " .asc").css({'background': '', 'color': ''});
            $(this).css({'background': 'white', 'color': 'black'});
            $("#" + side + " .asc" + index).css({'background': 'white', 'color': 'black'});
        });

        $(document).on("click", ".asc", function (e) {
            var clicked_class = $(this).attr("class").split(' ');
            var index = parseInt(clicked_class[1].substring(3));
            var side = clicked_class[2];
            $("#" + side + " .raw").css({'background': '', 'color': ''});
            $("#" + side + " .asc").css({'background': '', 'color': ''});
            $(this).css({'background': 'white', 'color': 'black'});
            $("#" + side + " .raw" + index).css({'background': 'white', 'color': 'black'});
        });


        function leadingZeros(n, digits) {
            var zero = '';
            n = n.toString();

            if (n.length < digits) {
                for (i = 0; i < digits - n.length; i++)
                    zero += '0';
            }
            return zero + n;
        }

        function scen_del(side) {
            $(side + ' .draw *').remove();
            $(side + ".transaction").val("");
            $(side + ".side").val("");
            $(side + ".excutioncount").val("");
        }

        function con_del(side) {
            $(side + '.console .consoleText').remove();
            $(side + '.statistic *').val("");
            $(side + ".datepicker").css("border","");
        }

      //포커스 이벤트
        function scrollDown() {
            var objDiv = document.getElementsByClassName("console");
            if(clickedconsole == true){
                for (var i = 0; i < objDiv.length; i++) {
                    objDiv[i].scrollTop = objDiv[i].scrollHeight;
                }
            }
        }

        function cardHeight() { /* card height 화면 꽉 차게 */
            var h2 = window.innerHeight;
            $(".card.content").height(h2 * 0.85);
            $(".tab_body_list").height(h2 * 0.70);
        }

        //쿠키의 timer정보를 입력받아 화면에 뿌림
        function mkTimer(to, side, timer) {
            var time;
            var count = lineNumber;
            $(to).find('.line').each(function (i, e) {
                if ((time = timer[i + 1]) != 0) {
                    if (side == "client") {
                        $(e).find(".timerH").append("<div class = 'timer' value = " + time + ">" + time + " ms" + "<div>");
                    } else {
                        $(e).find(".timerE").append("<div class = 'timer' value = " + time + ">" + time + " ms" + "<div>");
                    }
                }
            });
        }

        //시나리오 모델링 부분
        function mkLine(to, side, type, lineNumber, lineName) {
            var timerH = "";
            var timerE = "";
            if (side == "client") {
                timerH = "<div class='timerH' style ='display:block'/>";
                timerE = "<div class='timerE' style ='display:none'/>";
            } else {
                timerH = "<div class='timerH' style ='display:none'/>";
                timerE = "<div class='timerE' style='display: block'/>";
            }
            if (lineNumber == 0) {
                var add = "<div class='line row addtimer' id = 'line" + lineNumber + "'>" 
                + "<div class='col-md-2'>" + timerH + "</div>" 
                + "<div class='col-md-1'><div class=\"host_l\" ></div></div>" 
                + "<div class='col-md-6'/>" 
                + "<div class='col-md-1'><div class=\"eq_1\"></div></div>" 
                + "<div class='col-md-2'>" + timerE + "</div>" 
                + "</div>";
                $(add).appendTo(to + "#unsort");
            }
            lineNumber++;
            if (type == 'command') {
                timerE = "";
                arrow = "<div class='col-md-6' style='padding: 0px;'>" 
                + "<div class='row' style='padding: 0px;'>" 
                + "<div class = 'col-md-11' style='padding: 0px;'>" 
                + "<div class='c_name' style='padding: 0px;'>" + lineName + "</div>" 
                + "<hr/>"+"</div>" 
                + "<div class='arrow arrowright'style='padding: 0px;' >▶</div>" 
                + "</div>"
                + "</div>";
            } else {
                timerH = "";
    			arrow = "<div class='col-md-6' style='padding: 0px;'>" 
    			+ "<div class='row' style='padding: 0px;'>" 
    			+ "<div class='arrow arrowleft' style='padding: 0px;'>◀</div>" 
    			+ "<div class = 'col-md-11' style='padding: 0px;'>" 
    			+ "<div class='c_name' style='padding: 0px;'>" + lineName + "</div>" 
    			+ "<hr/>"+"</div>" 
    			+ "</div>"
    			+ "</div>";
            }
            var text = "<div class='line row' id = 'line" + lineNumber + "' >" 
            + "<div class='col-md-2' >" + timerH + "</div>" 
            + "<div class='col-md-1'><div class='host_l' ></div></div>" 
            + arrow 
            + "<div class='col-md-1'><div class='eq_1'></div></div>" 
            + "<div class='col-md-2'>" + timerE + "</div>" 
            + "</div>";
            $(text).appendTo(to + "#sortable");
        }

        function set_tab(side, comport) {
            var use = "#" + side + " ";
            var i = 1;
            var testResult = comport;
            comport.forEach(function (com) {
                var comport = use + "." + com + " ";
                var head = "<li class ='" + side + "'><a href='" + comport + "'>" + com + "</a></li>";
                $(use + " .tab_head_list").append(head);

                var body = "<div class='tab_body " + com + " " + side + "' id = " + side + "_" + com + ">"
                    + "<div class = 'front_body row' ></div>"
                    + "<div class = 'draw' ></div>"
                    + "<div class = 'drag' ></div>"
                    + "<div class = 'console " + side + "'>"
                    + "</div>"
                    + "<div class = 'statistic'></div>"
                    + "</div>";
                $(use + " .tab_body_list").append(body);

                var front_body = "<input type= 'number' class='transaction " + side + "' placeholder = 'Transaction' disabled='true'>"
                    + "<input type='text' class = 'side " + side + "' placeholder ='side' disabled='true'>"
                    + "<label class='col-form-label' >Try :</label><input list='trycountList' type='text'  class='count " + side + " excutioncount' disabled='true'>"
                    + "<datalist id=\"trycountList\">"
                    + "<option value=\"infinity\">"
                    + "</datalist>"
                    + "<button class = 'del scenDel " + side + "'>x</button>"
                $(comport + " .front_body").append(front_body);

                var console = "<div class = 'consoletext'>" + "</div>";
                $(comport + ".console").append("<button class = 'del conDel " + side + "' >x</button>");
                $(comport + " .console").append(console);
                i++;
                var statistic =
                    "<label class='col-form-label' > time :</label><input type='text' class='" + com + " datepicker s_datepicker' id = 's_date' name='date'>"
                    + "<label class='col-form-label' > ~ </label><input type='text' class='" + com + " datepicker e_datepicker' id = 'e_date' name='date'>"
                    + "<label class='col-form-label' > total run : </label>"+"<input type='text' class='runtime' id ='date' disabled='true'></br>"
                    + "<label class='col-form-label' > [ Scenario ] success : </label><input type='text' class='number' id = 's_scen' disabled='true'>"
                    + "<label class='col-form-label' > fail : </label><input type='text'  class='number ' id = 'f_scen' disabled='true'>"
                    + "<label class='col-form-label' > total : </label><input type='text'  class='number ' id = 't_scen' disabled='true'></br>"
                    + "<label class='col-form-label' > [ Message ]  success : </label><input type='text'  class='number' id = 's_message' disabled='true'>"
                    + "<label class='col-form-label' > fail : </label><input type='text'  class='number ' id = 'f_message' disabled='true'>"
                    + "<label class='col-form-label' > total : </label><input type='text'  class='number ' id = 't_message' disabled='true'>";
                $(comport + " .statistic").append(statistic);
            })
            $('.datepicker').daterangepicker({
                    singleDatePicker: true,
                    showDropdowns: true,
                    timePicker: true,
                    timePickerSeconds: true,
                    timePicker24Hour: true,
                    drops: 'up',
                    minDate: getToday(),
                    startDate: getToday() + getNowTime(),
                    locale: {
                        format: 'YYYY-MM-DD HH:mm:ss',
                        cancelLabel: 'Clear'
                    }
                });
            $('.datepicker').val('');
                $('.datepicker').on('cancel.daterangepicker', function (ev, picker) {
                    //do something, like clearing an input
                    var select = clicked_class = $(this).attr("class").split(' ');
                    $("." + select[0] + " ." + select[2]).val("");
                    $(this).css("border","");
                });

                $('.datepicker').on('apply.daterangepicker', function (ev, picker) {
                	$(this).css("border","solid skyblue");
                    var select = $(this).attr("class").split(' ');
                    var date = $(this).val();
                    $("." + select[0] + " ." + select[2]).val(date);
                    if($(this).attr("id")=="e_date"){
                    	save_end[get_index(select[0],testResult)] = true;
                    }
                });
            //When page loads...
            $(use + ".tab_body").hide(); //Hide all content
            $(use + " ul.tab_head_list li:first").addClass("active").show(); //Activate first tab
            $(use + ".tab_body:first").show(); //Show first tab content
        }

        //검색
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

        function getToday() {
            var now = new Date();

            var year = now.getFullYear();
            var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
            var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();

            var chan_val = year + '-' + mon + '-' + day;

            return chan_val;
        }

        function getNowTime() {
            var now = new Date();

            var dateString = "";
            dateString += ("0" + now.getHours()).slice(-2) + ":";
            dateString += ("0" + now.getMinutes()).slice(-2) + ":";
            dateString += "00";

            return dateString;
        }

        //새로고침, 나가기, 다른 페이지로 이동시 이벤트
        window.onbeforeunload = function (e) {
            var dialogText = 'Dialog text here';
            e.returnValue = dialogText;
            return dialogText;
        };
        
    </script>

</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <!-- common nav -->
    <%@include file="include/common_nav.jsp" %>
    <!-- /.common nav -->

    <!-- common side -->
    <%@include file="include/common_side.jsp" %>
    <!-- ./common side -->

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <!--시나리오 리스트-->
                    <div class="scenario-div col-md-2">
                        <div class="card content">
                            <div class="card-header">
                                <div class="left card-title">Scenario List</div>
                            </div>
                            <div class="card-body" id="scenarioList">
                                <div class="post" id="searchScenario-div">
                                    <div class="input-group input-group-sm">
                                        <input id="searchScenario" class="form-control form-control-navbar"
                                               type="search" placeholder="Search">
                                        <div class="input-group-append">
                                            <button class="btn btn-navbar" type="submit">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="post scenarioList"></div>
                            </div>
                        </div>
                    </div>

                    <!--시나리오 실행 부분-->
                    <div class="scenarioexcution-div col-md-10">
                        <div class="card content">
                            <div class="card-body" id="scenarioexcution">
                                <div class="row">
                                    <div class="col-md-2">
                                    </div>
                                    <button class="btn btn-block btn-success col-md-2" id="excutionbtn" type="button">
                                        Start
                                    </button>
                                    <button class="btn btn-block btn-danger col-md-2" id="excutionstopbtn"
                                            type="button" onmousedown="stopexcution()">Stop
                                    </button>
                                    <div class="col-md-2">
                                    </div>
                                </div>
                                <div class="row">
                                    <!--첫번째 실행 탭-->
                                    <div class="col-md-6">
                                        <div class="row" style="margin-top: 10px;">
                                            <div class='col' id="left">
                                                <!--탭 메뉴 영역 -->
                                                <ul class="tab_head_list"></ul>

                                                <!--탭 콘텐츠 영역 -->
                                                <div class="tab_body_list">

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--두번째 실행 탭-->
                                    <div class="col-md-6">
                                        <div class="row" style="margin-top: 10px;">
                                            <div class='col' id="right">
                                                <!--탭 메뉴 영역 -->
                                                <ul class="tab_head_list"></ul>

                                                <!--탭 콘텐츠 영역 -->
                                                <div class="tab_body_list">

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- /.container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <!-- common footer -->
    <%@include file="include/common_footer.jsp" %>
    <!-- ./common footer -->

</div>
</body>
</html>