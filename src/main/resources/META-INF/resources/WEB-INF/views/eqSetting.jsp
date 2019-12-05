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
    <link rel="stylesheet" href="/resources/dist/madecss/eqSetting.css">
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
    <script src="/resources/plugins/util/cookiesUtil.js"></script>
    <script src="/resources/plugins/util/ajaxUtil.js"></script>

    <script type="text/javascript">
        var saveeqSettinginfo;
        var eqName;
        var eqList = new Array();
        var clickname;
        var maintext;
        var update_eqinfo = true;
        var targetEq = '';
        var _browserState = 'unknown';
        
        $(document).ready(function () {
            var filePath = ajaxPath()
            console.log(filePath)
            cardHeight();
            $("#updateeqsetting").hide();
            $("#inserteqsetting").show();
            /* 처음  페이지 로드 */
            // if (document.cookie.indexOf("eq : eqName") != -1) { 	// eqName cookie 있으면
            //     var ckData = JSON.parse(getCookie("eq : eqName"));
            //     $("#eqSelect").val(ckData.eqName).prop("selected", true);
            //     load(ckData.eqName);
            //     eqName = ckData.eqName;
            //
            // } else {
            //     console.log("eqName cookie 가 없음 : error");
            // }
            load("pump1");
            eqName = "pump1";

            /* EQ 바꿀 때 마다 페이지 새로드 */
            $('body').on("change", "#eqSelect", function () {
                eqName = $("#eqSelect").val();
                msgElement = new Array;
                $("#eqfirstsetting *").remove();
                $(".eqNamebtn *").remove();
                if (document.cookie.indexOf("eq : eqName") != -1) {		// eqName cookie 있으면
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
                var response = ajaxEqSetting("GET", null, null);
                if (response.code == 200) {
                    for (var i = 0; i < response.data.length; i++) {
                        eqList.push(response.data[i]);

                        $(".eqNamebtn").append("<button type='button' class='btn col-sm-2 btn-block btn-default eqbtn' id = '" + eqList[i].name + "' onmousedown='clicked(this.id)'>" + eqList[i].name + "</button>");
                        var eq = {
                            "name": eqList[i].name,
                            "electricalInterface": eqList[i].electricalInterface,
                            "synchronizationMethod": eqList[i].synchronizationMethod,
                            "communicationSpeed": eqList[i].communicationSpeed,
                            "dataLength": eqList[i].dataLength,
                            "stopBit": eqList[i].stopBit,
                            "parity": eqList[i].parity,
                            "errorControl": eqList[i].errorControl,
                            "busyControl": eqList[i].busyControl
                        }
                        setGlobalValue("Eq : " + eqList[i].name, JSON.stringify(eq), 1);
                    }
                } else {
                    console.log(response.message);
                }
            }

            // length에 숫자만 입력
            $(document).on("keydown", "#CS, #DL, #SB", function(e) {
                $(this).val($(this).val().replace(/[^0-9]/gi, ''));
            });

            //한글 입력 막기
            $(document).on("keyup", "#eqN, #EI, #SM,#EC,#BC", function(e) {
                $(this).val($(this).val().replace(/[^a-zA-Z0-9]/g, ''));
            });

            //새로운 eq만드는 버튼 클릭시 이벤트
            $("#inserteq").click(function () {
                targetEq='';
                $("#eqfirstsetting *").remove();
                $("#updateeqsetting").hide();
                $("#inserteqsetting").show();
                $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                update_eqinfo = true;
                maintext = "<tbody class='neweq'>" + "<tr class='eName' >" + "<td>EQ Name</td>" + "<td>" + "<input type='text' id='eqN' >" + "</td>" + "</tr>"
                    + "<tr class='eqEI' >" + "<td>ElectricalInterface</td>" + "<td>" + "<input type='text' id='EI'  >" + "</td>" + "</tr>"
                    + "<tr class='eqSM' >" + "<td>SynchronizationMethod</td>" + "<td>" + "<input type='text' id='SM' >" + "</td>" + "</tr>"
                    + "<tr class='eqCS' >" + "<td>CommunicationSpeed</td>" + "<td>" + "<input type='number' id='CS'>" + "</td>" + "</tr>"
                    + "<tr class='eqDL'>" + "<td>DataLength</td>" + "<td>" + "<input type='number'id='DL'>" + "</td>" + "</tr>"
                    + " <tr class='eqSB' >" + " <td>StopBit</td>" + "<td>" + "<input type='number'id='SB'>" + "</td>" + "</tr>"
                    + "<tr class='eqPR' >" + "<td>Parity</td>" + "<td>" + "<select id='PR'><option>None</option><option>Odd</option><option>Even</option><option>Mark</option><option>Spark</option></select>" + "</td>" + " </tr>"
                    + " <tr class='eqEC' >" + " <td>ErrorControl</td>" + "<td>" + "<input type='text'id='EC'>" + "</td>" + "</tr>"
                    + " <tr class='eqBC' >" + " <td>BusyControl</td>" + "<td>" + "<input type='text'id='BC'>" + "</td>" + "  </tr>" + "</tbody>";
                $("#eqfirstsetting").append(maintext);
                clickname="";
            });

            //입력한 eq정보를 저장하는 이벤트
            $("#inserteqsetting").click(function () {
                $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                var counting=0;
                var eqN = $("#eqN").val();

                for(var i=0;i<eqList.length;i++) {
                    counting++;
                    if (eqN == eqList[i].name){
                        break;
                    }
                }
                if(eqN != null){
                    if(counting<eqList.length && update_eqinfo != false){
                        alert("이미 존재하는 장비 이름입니다. 다른 이름을 입력해주세요.");
                    }
                    else{
                        var EI = $("#EI").val();
                        var SM = $("#SM").val();
                        var CS = $("#CS").val();
                        var DL = $("#DL").val();
                        var SB = $("#SB").val();
                        var PR = $("#PR option").index($("#PR option:selected"));
                        var EC = $("#EC").val();
                        var BC = $("#BC").val();
                        
                        var eq = {
                            "name": eqN,
                            "electricalInterface": EI,
                            "synchronizationMethod": SM,
                            "communicationSpeed": CS,
                            "dataLength": DL,
                            "stopBit": SB,
                            "parity": PR,
                            "errorControl": EC,
                            "busyControl": BC,
                            "targetEq":targetEq
                        };
                        targetEq = '';
                        if (eqinfoCkNull() != false) {
                            if (update_eqinfo == true) {
                                console.log(eq);
                                var result = ajaxEqSetting("post", eqN, JSON.stringify(eq));
                                if (result.code == 200) {
                                    setGlobalValue("Eq : " + eqN, JSON.stringify(eq), 1);
                                    eqList.push(eq);
                                    alert(eqN+"이(가) 생성되었습니다.");
                                    clickname="";
                                    $("<option value='" +  eqN + "'>" + eqN + "</option>").appendTo("#eqSelect");
                                    $(".eqNamebtn").append("<button type='button' class='btn col-sm-2 btn-block btn-default eqbtn' id = '" + eqN + "' onmousedown='clicked(this.id)'>" + eqN + "</button>");

                                } else {
                                    console.log(result.code);
                                }
                            } else {
                                var result = ajaxEqSetting("put", eqN, JSON.stringify(eq));
                                if (result.code == 200) {
                                    setGlobalValue("Eq : " + eqN, JSON.stringify(eq), 1);
                                    alert(clickname+"의 정보가 수정되었습니다.");
                                } else {
                                    console.log(result.code);
                                }
                            }
                            $("#eqfirstsetting *").remove();
                        }
                    }
                }else {
                    alert("만들어진 장비의 이름 및 테이블이 없습니다.");
                }

            });

            //이미 작성된 eq정보 수정 버튼 클릭시 이벤트
            $("#updateeqsetting").click(function () {
                targetEq='';
                update_eqinfo = false;
                if (clickname == ""||clickname==null) {
                    alert("수정할 장비의 이름을 선택해주세요.");
                } else {
                    var eiinfo = $("#eiinfo").text();
                    var sminfo = $("#sminfo").text();
                    var csinfo = $("#csinfo").text();
                    var dlinfo = $("#dlinfo").text();
                    var sbinfo = $("#sbinfo").text();
                    var prinfo = $("#prinfoSelect option").index($("#prinfoSelect option:selected"));
                    var ecinfo = $("#ecinfo").text();
                    var bcinfo = $("#bcinfo").text();

                    $("#eqfirstsetting *").remove();
                    maintext = "<tbody class='neweq'>" + "<tr class='eName' >" + "<td>EQ Name</td>" + "<td>" + "<input type='text' id='eqN'  value = '" + clickname + "' disabled >" + "</td>" + "</tr>"
                        + "<tr class='eqEI' >" + "<td>ElectricalInterface</td>" + "<td>" + "<input type='text' id='EI' value = '" + eiinfo + "'>" + "</td>" + "</tr>"
                        + "<tr class='eqSM' >" + "<td>SynchronizationMethod</td>" + "<td>" + "<input type='text' id='SM'  value = '" + sminfo + "'>" + "</td>" + "</tr>"
                        + "<tr class='eqCS' >" + "<td>CommunicationSpeed</td>" + "<td>" + "<input type='number' id='CS' value = '" + csinfo + "'>" + "</td>" + "</tr>"
                        + "<tr class='eqDL'>" + "<td>DataLength</td>" + "<td>" + "<input type='number'id='DL'  value = '" + dlinfo + "'>" + "</td>" + "</tr>"
                        + " <tr class='eqSB' >" + " <td>StopBit</td>" + "<td>" + "<input type='number'id='SB'  value = '" + sbinfo + "'>" + "</td>" + "</tr>"
                        + "<tr class='eqPR' >" + "<td>Parity</td>" + "<td>" + "<select id='PR'><option>None</option><option>Odd</option><option>Even</option><option>Mark</option><option>Spark</option></select>" + "</td>" + " </tr>"
                        + " <tr class='eqEC' >" + " <td>ErrorControl</td>" + "<td>" + "<input type='text'id='EC'  value = '" + ecinfo + "'>" + "</td>" + "</tr>"
                        + " <tr class='eqBC' >" + " <td>BusyControl</td>" + "<td>" + "<input type='text'id='BC'  value = '" + bcinfo + "'>" + "</td>" + "  </tr>" + "</tbody>";
                    $("#eqfirstsetting").append(maintext);
                    // 패리티 선택 만들기
                    console.log(prinfo);
                    $("#PR option:eq(" + prinfo + ")").attr("selected", "selected");
                }
                $("#updateeqsetting").hide();
                $("#inserteqsetting").show();
                clickname="";
            });

            //작업중이던 화면 취소 이벤트
            $("#canceleqsetting").click(function () {
                targetEq='';
                clickname="";
                $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                $("#eqfirstsetting *").remove();
                $("#updateeqsetting").hide();
                $("#inserteqsetting").show();
            });

            //만들어진 eq정보 삭제 이벤트
            $("#deleteeqsetting").click(function () {
                targetEq='';
                if (clickname == ""||clickname==null) {
                    alert("삭제할 장비의 이름을 선택해주세요.");
                }else{
                    if(confirm("정말 삭제하시겠습니까?")==true){
                        targetEq = '';
                        $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                        var result = ajaxEqSetting("delete", clickname, clickname);
                        if (result.code == 200) {
							deleteGlobalValue("Eq : " + clickname);
							eqList.splice(eqList.indexOf(clickname), 1);
							
							var eqNamebtnTxt = $('.eqNamebtn').find('button#' + clickname).text();
							var selectTxt = $("select#eqSelect option[value='" + clickname + "']").val();
												
							$('.eqNamebtn').find('button#' + clickname).remove();
	                        $("#eqfirstsetting *").remove();
	                        alert("삭제 되었습니다.");
							$("select#eqSelect option[value='" + clickname + "']").remove();
                            $("#updateeqsetting").hide();
                            $("#inserteqsetting").show();
							$(".contextmenu").hide();
							// select test == button 이면 삭제하고 select index 1 로 바꾸고 eqname 바꾸기
							if (eqNamebtnTxt == selectTxt) {
								$("#eqSelect option:eq(0)").prop("selected", true);							
								setCookie("eq : eqName", JSON.stringify({"eqName": $("#eqSelect option:eq(0)").val()}), 1);
							}
                        } else {
                            targetEq = '';
							console.log(result.code);
                        }
                    }
                }
            });

            //장비 복사
            $("#cloneeeqsetting").click(function () {
                targetEq='';
                if (clickname == ""||clickname==null) {
                    alert("복사할 장비를 선택해주세요.");
                }else{
                    // 이름과 중복 검사
                    var idx = 1;
                    for (var i = 0; i < eqList.length; i++) {
                        if(eqList[i].name == clickname + '_' + idx) idx++;
                    }
                    var newName = clickname + '_' + idx;

                    var eqData = JSON.parse(getGlobalValue("Eq : " + clickname));
                    eqData.name = newName;

                    $("#eqfirstsetting *").remove();
                    $("#updateeqsetting").hide();
                    $("#inserteqsetting").show();
                    $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                    update_eqinfo = true;
                    maintext = "<tbody class='neweq'>" + "<tr class='eName' >" + "<td>EQ Name</td>" + "<td>" + "<input type='text' id='eqN' value="+eqData.name+">" + "</td>" + "</tr>"
                        + "<tr class='eqEI' >" + "<td>ElectricalInterface</td>" + "<td>" + "<input type='text' id='EI' value="+ eqData.electricalInterface + "></td>" + "</tr>"
                        + "<tr class='eqSM' >" + "<td>SynchronizationMethod</td>" + "<td>" + "<input type='text' id='SM' value='"+eqData.synchronizationMethod+"'></td>" + "</tr>"
                        + "<tr class='eqCS' >" + "<td>CommunicationSpeed</td>" + "<td>" + "<input type='number' id='CS' value=" + eqData.communicationSpeed + "></td>" + "</tr>"
                        + "<tr class='eqDL'>" + "<td>DataLength</td>" + "<td>" + "<input type='number'id='DL' value='"+eqData.dataLength+"'></td>" + "</tr>"
                        + " <tr class='eqSB' >" + " <td>StopBit</td>" + "<td>" + "<input type='number'id='SB' value='"+eqData.stopBit+"'></td>" + "</tr>"
                        + "<tr class='eqPR' >" + "<td>Parity</td>" + "<td>" + "<select id='PR'><option>None</option><option>Odd</option><option>Even</option><option>Mark</option><option>Spark</option></select>" + "</td>" + " </tr>"
                        + " <tr class='eqEC' >" + " <td>ErrorControl</td>" + "<td>" + "<input type='text'id='EC' value='"+eqData.errorControl+"'></td>" + "</tr>"
                        + " <tr class='eqBC' >" + " <td>BusyControl</td>" + "<td>" + "<input type='text'id='BC' value='"+eqData.busyControl+"'></td>" + "</tr>" + "</tbody>";
                    $("#eqfirstsetting").append(maintext);

                    $("#PR option:eq(" + eqData.parity + ")").attr("selected", "selected");
                    clickname="";
                }
            });

            //import 버튼 클릭시 이벤트
            $("#importbtn").click(function () {
                targetEq='';
                console.log(clickname);
                if (clickname == ""||clickname==null) {
                    // 파일 열어서 불러오기
                    
                }
            });

            //export 버튼 클릭시 이벤트
            $("#exportbtn").click(function () {
                targetEq='';
                console.log(clickname);
                if (clickname == ""||clickname==null) {
                    alert("Export 할 장비를 선택해주세요.");
                }else{
                    //export 하는 부분
                    exportXml(clickname);
                }
            });

        });

        // 공백 체크
        function eqinfoCkNull() {
            var eqN = $("#eqN").val();
            var EI = $("#EI").val();
            var SM = $("#SM").val();
            var CS = $("#CS").val();
            var DL = $("#DL").val();
            var SB = $("#SB").val();
            var PR = $("#PR").val();
            var EC = $("#EC").val();
            var BC = $("#BC").val();

            if (eqN == "" || EI == "" || SM == "" || CS == "" || DL == "" || SB == "" || PR == "" || EC == "" || BC == "") {
                alert("공백이 있습니다. 모든 값을 입력해주세요.");
                return false;
            }
        }

        //장비 리스트에서 장비 클릭시 이벤트
        function clicked(clicked_id) {
            targetEq='';
            if (event.which == 1) {
                for (var i = 0; i < eqList.length; i++) {
                    if (eqList[i].name == clicked_id) {
                        var eqData = JSON.parse(getGlobalValue("Eq : " + clicked_id));
                        $("#eqfirstsetting *").remove();
                        clickname = clicked_id; update_eqinfo = true;
                        //버튼 클릭시 색상 변화 css
                        $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                        $(".eqNamebtn").find('#' + clickname).css({'background-color': '#66696B', 'color': 'white'});
                        $("#updateeqsetting").show();
                        $("#inserteqsetting").hide();
                        var text = "<tbody class='clickinfo'>" +
                            "<tr class='eqEI' >" + "<td>ElectricalInterface</td>" + "<td id='eiinfo'>" + eqData.electricalInterface + "</td>" + "</tr>"
                            + "<tr class='eqSM' >" + "<td>SynchronizationMethod</td>" + "<td id='sminfo'>" + eqData.synchronizationMethod + "</td>" + "</tr>"
                            + "<tr class='eqCS' >" + "<td>CommunicationSpeed</td>" + "<td id='csinfo'>" + eqData.communicationSpeed + "</td>" + "</tr>"
                            + "<tr class='eqDL'>" + "<td>DataLength</td>" + "<td id='dlinfo'>" + eqData.dataLength + "</td>" + "</tr>"
                            + " <tr class='eqSB' >" + " <td>StopBit</td>" + "<td id='sbinfo'>" + eqData.stopBit + "</td>" + "</tr>"
                            + "<tr class='eqPR' >" + "<td>Parity</td>" + "<td id='prinfo'><select id='prinfoSelect'><option>None</option><option>Odd</option><option>Even</option><option>Mark</option><option>Spark</option></select></td>" + " </tr>"
                            + " <tr class='eqEC' >" + " <td>ErrorControl</td>" + "<td id='ecinfo'>" + eqData.errorControl + "</td>" + "</tr>"
                            + " <tr class='eqBC' >" + " <td>BusyControl</td>" + "<td id='bcinfo'>" + eqData.busyControl + "</td>" + "  </tr>" + "</tbody>";
                        $("#eqfirstsetting").append(text);
                        // 패리티 선택 값 보여주기
                        console.log(eqData.parity);
                        $("#prinfoSelect option:eq(" + eqData.parity + ")").attr("selected", "selected");
                        $('#prinfoSelect').attr('disabled', 'true');
                        // 변경 못하게 막기
                        break;
                    }
                }
            }
            if (event.which == 3) {
                targetEq = clicked_id;
                $("#btnExport").click(function () {
                    if(targetEq == null || targetEq == '') {
                        alert("Export 할 장비를 선택해주세요.");
                    } else {
                        exportXml(targetEq);
                        clicked_id='';
                    }
                });
                
                $('#' + clicked_id).contextmenu(function (e) {
                    $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                    $(".eqNamebtn").find('#' + clicked_id).css({'background-color': '#66696B', 'color': 'white'});
                    $("#eqfirstsetting *").remove();
                    $("#updateeqsetting").hide();
                    $("#inserteqsetting").show();

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
                        "left": posLeft,
                        "top": posTop
                    }).show();
                    //Prevent browser default contextmenu.
                    return false;
                });
                //Hide contextmenu:
                $(document).contextmenu(function () {
                    $(".contextmenu").hide();
                });
                $(document).click(function () {
                    $(".contextmenu").hide();
                    $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                });
                $("#btnDelete").off().click(function () {
                    targetEq='';
                    if(confirm("정말 삭제하시겠습니까?")==true){
                        var result = ajaxEqSetting("delete", clicked_id, clicked_id);
                        if (result.code == 200) {
							deleteGlobalValue("Eq : " + clicked_id);
							eqList.splice(eqList.indexOf(clicked_id), 1);
							
							var eqNamebtnTxt = $('.eqNamebtn').find('button#' + clicked_id).text();
							var selectTxt = $("select#eqSelect option[value='" + clicked_id + "']").val();
							
							$('.eqNamebtn').find('button#' + clicked_id).remove();
	                        $("#eqfirstsetting *").remove();
	                        alert("삭제 되었습니다.");
							$("select#eqSelect option[value='" + clicked_id + "']").remove();
                            $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
							$(".contextmenu").hide();
							// select test == button 이면 삭제하고 select index 1 로 바꾸고 eqname 바꾸기
							if (eqNamebtnTxt == selectTxt) {
								$("#eqSelect option:eq(0)").prop("selected", true);							
								setCookie("eq : eqName", JSON.stringify({"eqName": $("#eqSelect option:eq(0)").val()}), 1);
							}
                        } else {
							console.log(result.code);
                        }
                    }
                });
                
                // clone
                $("#btnClone").click(function () {
                    // 이름과 중복 검사
                    var idx = 1;
                    for (var i = 0; i < eqList.length; i++) {
                        if(eqList[i].name == targetEq + '_' + idx) idx++;
                    }
                    var newName = targetEq + '_' + idx;
                    
                    var eqData = JSON.parse(getGlobalValue("Eq : " + targetEq));
                    eqData.name = newName;
    
                    $("#eqfirstsetting *").remove();
                    $("#updateeqsetting").hide();
                    $("#inserteqsetting").show();
                    $(".eqNamebtn").find('button').css({'background-color': '#f7f7f7', 'color': 'black'});
                    update_eqinfo = true;
                    maintext = "<tbody class='neweq'>" + "<tr class='eName' >" + "<td>EQ Name</td>" + "<td>" + "<input type='text' id='eqN' value="+eqData.name+">" + "</td>" + "</tr>"
                            + "<tr class='eqEI' >" + "<td>ElectricalInterface</td>" + "<td>" + "<input type='text' id='EI' value="+ eqData.electricalInterface + "></td>" + "</tr>"
                            + "<tr class='eqSM' >" + "<td>SynchronizationMethod</td>" + "<td>" + "<input type='text' id='SM' value='"+eqData.synchronizationMethod+"'></td>" + "</tr>"
                            + "<tr class='eqCS' >" + "<td>CommunicationSpeed</td>" + "<td>" + "<input type='number' id='CS' value=" + eqData.communicationSpeed + "></td>" + "</tr>"
                            + "<tr class='eqDL'>" + "<td>DataLength</td>" + "<td>" + "<input type='number'id='DL' value='"+eqData.dataLength+"'></td>" + "</tr>"
                            + " <tr class='eqSB' >" + " <td>StopBit</td>" + "<td>" + "<input type='number'id='SB' value='"+eqData.stopBit+"'></td>" + "</tr>"
                            + "<tr class='eqPR' >" + "<td>Parity</td>" + "<td>" + "<select id='PR'><option>None</option><option>Odd</option><option>Even</option><option>Mark</option><option>Spark</option></select>" + "</td>" + " </tr>"
                            + " <tr class='eqEC' >" + " <td>ErrorControl</td>" + "<td>" + "<input type='text'id='EC' value='"+eqData.errorControl+"'></td>" + "</tr>"
                            + " <tr class='eqBC' >" + " <td>BusyControl</td>" + "<td>" + "<input type='text'id='BC' value='"+eqData.busyControl+"'></td>" + "</tr>" + "</tbody>";
                    $("#eqfirstsetting").append(maintext);
                    $("#PR option:eq(" + eqData.parity + ")").attr("selected", "selected");
                    clickname="";
                });
                
                
            }
        }

        function cardHeight() { /* card height 화면 꽉 차게 */
            var h2 = window.innerHeight;
            $(".card").height(h2 * 0.80);
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

        function processFile(file) {
            var reader = new FileReader();
            reader.onload = function () {
                var response = ajaxFile(reader.result, "import");
                alert(response.message);
                location.reload();
            };

            reader.readAsText(file, "utf-8");
        }
        
        (function checkBrowser(){
            var agent = navigator.userAgent.toLowerCase();
            if(agent.indexOf("chrome")!=-1){_browserState="Chrome";}
            else if(agent.indexOf("safari")!=-1){_browserState="safari";}
            else if(agent.indexOf("firefox")!=-1){_browserState="firefox";}
            else if(agent.indexOf("msie")!=-1 || agent.indexOf('trident')!=-1){_browserState="IE"}
            for(let i=0;i<5;i++){ console.warn("connected Browser is "+_browserState);}
        })();

        // Extension Download reProduction Code
        function _downloadEx(filename,contents){
            if(_browserState.toLowerCase() ==='chrome'){
                var element = document.createElement('a');
                element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(contents));
                element.setAttribute('download', filename);
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);
            }
            //not in Chrome
            else{
                var a = document.createElement("a"),
                        file = new Blob([contents], { type: "text/plain;charset=utf-8" });
        
                if (window.navigator.msSaveOrOpenBlob) // IE10+
                    window.navigator.msSaveOrOpenBlob(file, filename);
                else { // Others
                    var url = URL.createObjectURL(file);
                    a.href = url;
                    a.download = filename;
                    document.body.appendChild(a);
            
                    a.click();
                    setTimeout(function () {
                        document.body.removeChild(a);
                        window.URL.revokeObjectURL(url);
                    }, 0);
                }
            }
        }
        
        function exportXml(name) {
            var response = ajaxFile(name, "export");
    
            switch (response.code) {
                case 200:
                    _downloadEx(name+".xml",response.data);
                    break;
                case 404:
                    alert(response.message);
                    break;
                case 500:
                    alert(response.message);
                    break;
                default:
                    alert("Export Error");
                    break;
            }
        }
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
                    <div class="col-md-12">
                        <div class="card content">
                            <div class="card-header">
                                <div class="left card-title">EqSetting</div>
                                <div class="btn-group" style="float: right">
                                    <button type="button" class="btn btn-info" onclick="openTextFile()">Import</button>
                                    <button type="button" class="btn btn-info" id="exportbtn">Export</button>
                                    <button type="button" id="inserteq" class="btn btn-info">+</button>
                                </div>
<%--                                <button class="btn btn-info float-right" type="button" id="inserteq">+</button>--%>
                            </div>
                            <div class="card-body">
                                <div class="eqNamebtn row">

                                </div>
                                <div class="row eqinfo">
                                    <table class="table table-bordered" id="eqfirstsetting">

                                    </table>
                                </div>
                                <div class="row">
                                        <button class="btn btn-block btn-success activebtn "
                                                id="inserteqsetting" >Save<!-- btn-success btn-sm-->
                                        </button>
                                        <button class="btn btn-block btn-secondary activebtn "
                                                id="updateeqsetting" >Update<!--btn-block btn-secondary btn-sm-->
                                        </button>
                                        <button class="btn btn-block btn-warning activebtn "
                                                id="canceleqsetting" >Cancel
                                        </button>
                                        <button class="btn btn-block btn-danger activebtn "
                                                id="deleteeqsetting" >Delete
                                        </button>
                                        <button class="btn btn-block btn-primary activebtn "
                                                id="cloneeeqsetting" >Clone
                                        </button>
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
<ul class="contextmenu">
    <li><a id="btnClone">Clone</a></li>
    <li><a id="btnExport">Export</a></li>
    <li><a id="btnDelete">Delete</a></li>
</ul>
</body>
</html>