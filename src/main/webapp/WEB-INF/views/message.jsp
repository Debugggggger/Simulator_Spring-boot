<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<link rel="stylesheet" href="/resources/dist/madecss/message.css">
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
<!-- <script src="/resources/plugins/jqvmap/jquery.vmap.min.js"></script> -->
<!-- <script src="/resources/plugins/jqvmap/maps/jquery.vmap.usa.js"></script> -->
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
<!-- 우리의 유틸 -->
<script src="/resources/plugins/util/ajaxUtil.js"></script>
<script src="/resources/plugins/util/cookiesUtil.js"></script>
<script src="/resources/plugins/util/checksum.js"></script>
<script src="/resources/plugins/util/madeChecksum.js"></script>
<!-- <script src="/resources/plugins/dist/checksum1/Checksum1.js"></script>
<script src="/resources/plugins/dist/checksum1/crc32.js"></script>
<script src="/resources/plugins/dist/checksum1/fnv32.js"></script> -->

<script type="text/javascript">
    $(document).ready(function() {
        var msgElement = new Array();
        var cmpList = new Array();
        var clicked_id;
        var parentId;
        var response;
        var eqName;
        
        cardHeight();/* card height 화면 꽉 차게  + frame tab 동작하는거*/

        cmpList = load("pump1", cmpList);
        eqName = "pump1";
        /* 처음  페이지 로드 */
        // if (document.cookie.indexOf("eq : eqName") != -1) { // eqName cookie 있으면
        //     var ckData = JSON.parse(getCookie("eq : eqName"));
        //     $("#eqSelect").val(ckData.eqName).prop("selected", true);
        //     cmpList = load(ckData.eqName, cmpList);
        //     eqName = ckData.eqName;
        // } else {
        //     console.log("eqName cookie 가 없음 : error");
        // }
        /* EQ 바꿀 때 마다 페이지 새로드 */
        $(document).on("change", "#eqSelect", function() {
            deleteCookie("FromTo : fromto");
            csDrop = false;
            eqName = $("#eqSelect").val();
            msgElement = new Array;
            cmpList = new Array();

            $(".msgEle").remove();
            $(".cmp").remove();
            $(".cmdBtn").remove();
            $(".rspBtn").remove();
            $("#msgName").val("");

            delMsgFrameTable();
            delMsgFrameCS();
            delCmpTable();

            if (document.cookie.indexOf("eq : eqName") != -1) { // eqName cookie 있으면
                clearAllCookies();
                clearAllGlobalValue();
                setCookie("eq : eqName", JSON.stringify({"eqName" : eqName}), 1);
                var ckData = JSON.parse(getCookie("eq : eqName"));
                $("#eqSelect").val(ckData.eqName).prop("selected", true);
                cmpList = load(ckData.eqName, cmpList);
            } else {
                console.log("eqName cookie 가 없음 : error");
            }

        });

        function load(eqName, cmpList) {
            $("body").addClass("sidebar-collapse");
            var ck = false;
            response = ajaxComponent("get", eqName, null);
            if (response.code == 200) {
                response.data.forEach(function(component) {
                    if (component.name == "Checksum") {
                        ck = true;
                    }
                    $("#cmpList").append("<div class = 'cmp ui-draggable ui-draggable-handle' id = '"+component.name+"'>" + component.name + "</div>");
                    $(".cmp").draggable({
	                    appendTo : 'body',
	                    containment : 'window',
	                    scroll : false,
	                    helper : 'clone',
	                    opacity : "0.3"
                    });
                    cmpList.push(component.name);
                    setGlobalValue("Compo : " + component.name, JSON.stringify(component), 1);
                });
                
                if (ck == false) {		// checksum 없으면 cmp 만들기
                    var component = {
                            "name" : "Checksum",
                            "type" : "hex",
                            "value" : [""],
                            "length" : 1,
                            "description" : "Checksum",
                            "svid" : "",
                            "multiValue" : false
                    };
                    response = ajaxComponent("post", eqName, JSON.stringify(component));		//xml checksum component 없으니까 넣어주기
                    if (response.code == 200) {
                        $("#cmpList").append("<div class = 'cmp ui-draggable ui-draggable-handle' id = '"+component.name+"'>" + component.name + "</div>");
                        $(".cmp").draggable({
    	                    appendTo : 'body',
    	                    containment : 'window',
    	                    scroll : false,
    	                    helper : 'clone',
    	                    opacity : "0.3"
                        });
                        cmpList.push(component.name);
                        setGlobalValue("Compo : " + component.name, JSON.stringify(component), 1);
                    } else {
                        console.log(response.message);
                    }
                }         
            } else {
                console.log(response.message);
            }

            response = ajaxMessageFrame("get", eqName, null);
            if (response.code == 200) {
                response.data.forEach(function(msgFrames) {
                    if (msgFrames.type.toLowerCase() == "command") {
                        $("#tabCmd").append("<div class = 'cmdBtn btn btn-block btn-outline-primary' id = '" + msgFrames.name + "'>" + msgFrames.name + "</div>");
                        setGlobalValue("CmdFrame : " + msgFrames.name, JSON.stringify(msgFrames), 1);
                    } else if (msgFrames.type.toLowerCase() == "response") {
                        $("#tabRsp").append("<div class = 'rspBtn btn btn-block btn-outline-primary' id = '" + msgFrames.name + "'>" + msgFrames.name + "</div>");
                        setGlobalValue("RspFrame : " + msgFrames.name, JSON.stringify(msgFrames), 1);
                    }             
                });
            } else {
                console.log(response.message);
            }
            return cmpList;
        }

        /* + 클릭하면 cmp table 생성 */
        $("#plusBtn").click(function() {
            madeCmpTable();
        });
         
        /* component search */        
        $(document).on("keyup search", "#searchCmp", function() {
            searchLogic("searchCmp", "cmp");
        });
        /* cmdBtn search */
        $(document).on("keyup search", "#searchCmd", function() {
            searchLogic("searchCmd", "cmdBtn");
        });
        /* rspBtn search */
        $(document).on("keyup search", "#searchRsp", function() {
            searchLogic("searchRsp", "rspBtn");
        });
        
		/* component sort */
        var cmpDesc = false;
        $("#cmpSortBtn").click(function() {
            sortUnorderedList("cmpList", cmpDesc);
            cmpDesc = !cmpDesc;
            return false;
        });
        /* cmd sort */
        var cmdDesc = false;
        $("#cmdSortBtn").click(function() {
            sortUnorderedList("tabCmd", cmdDesc);
            cmdDesc = !cmdDesc;
            return false;
        });
        /* rsp sort */
        var rspDesc = false;
        $("#rspSortBtn").click(function() {
            sortUnorderedList("tabRsp", rspDesc);
            rspDesc = !rspDesc;
            return false;
        });
          
        $(document).on("click", "#addCmp", function() {
            var name = $('#tableinfo').find("input#name").val();
            var type = $('#tableinfo').find("#type").val();
            var value = $('#tableinfo').find("input#value").val();
            var length = $('#tableinfo').find("input#length").val();
            var description = $('#tableinfo').find("input#description").val();
            var svid = $('#tableinfo').find("input#svid").val();
            var multiValue = $('#tableinfo').find("#multiValue").val();

            var component = {
            "name" : name,
            "type" : type,
            "value" : value,
            "length" : length,
            "description" : description,
            "svid" : svid,
            "multiValue" : multiValue
            };

            var result = madeCmpJson(component);
            if (result.check == true) {
                var i = 0;
                var updateCk = false; // insert인지 update 인지 check
                for (i; i < cmpList.length; i++) { // 중복된 이름 확인
                    if (name == cmpList[i]) {
                        if ($('#tableinfo').find("input#name").is('[disabled=disabled]') == false) {
                            alert("동일한 이름이 존재합니다.");
                            break;
                        } else {
                            updateCk = true;
                        }
                    }
                }
                if (i == cmpList.length && cmpCheckNull() != false && result.checkmultivalue != false) { //중복되지 않았을때
                    if (updateCk != true) {			// insert
                        response = ajaxComponent("post", eqName, JSON.stringify(result.component));
                        if (response.code == 200) {
                            console.log(response.message);
                            $("#cmpList").append("<div class = 'cmp ui-draggable ui-draggable-handle' id = '"+name+"'>" + name + "</div>");
                            $(".cmp").draggable({
    	                        appendTo : 'body',
    	                        containment : 'window',
    	                        scroll : false,
    	                        helper : 'clone',
    	                        opacity : "0.3"
                            });
                            cmpList.push(name);
                            setGlobalValue("Compo : " + name, JSON.stringify(result.component), 1);
                            delCmpTable();
                            alert("Component 가 저장되었습니다.");
                        } else {
                            console.log(response.message);
                        }
                    } else {		// update
                        response = ajaxComponent("put", eqName, JSON.stringify(result.component));
                        if (response.code == 200) {
                            console.log(response.message);
                            setGlobalValue("Compo : " + name, JSON.stringify(result.component), 1);
                            delCmpTable();
                            alert("Component 가 수정되었습니다.");
                        } else {
                            console.log(response.message);
                        }
                    }
                }
            }
        });

        $(document).on("click", "#cancelCmp", function() {
            delCmpTable();
        });

        // 한글입력 막기
        $(document).on("keyup", "#name, .mtName, #value, .mtValue, #description, .mtDescription, #svid, .mtSvid", function(e) {
            var objTarget = e.srcElement || e.target;
            if (objTarget.type == 'text') {
                var value = objTarget.value;
                if (/[ㄱ-ㅎㅏ-ㅡ가-핳]/.test(value)) {
                    objTarget.value = objTarget.value.replace(/[ㄱ-ㅎㅏ-ㅡ가-핳]/g, ''); // g가 핵심: 빠르게 타이핑할때 여러 한글문자가 입력되어 버린다.
                }
            }
        });
        
     	// 공백 입력 막기
        $(document).on("keyup", "#msgName", function(e) {
            $('#msgName').val($('#msgName').val().replace(/ /gi, ''));
        });

        //컴포넌트 클릭/우클릭  
        $(document).on("click", ".cmp", function() {
            clicked_id = this.id;
            leftClick(clicked_id);
        });
        $(document).on("mouseup", ".cmp", function() {
            if (event.which == 3) {
                clicked_id = this.id;
                rightClick(clicked_id);
            }
        });

        //mspElement 클릭/우클릭  
        $(document).on("click", ".msgEle", function() {
            msgEleClicked();
            $(this).addClass("active");

            var label = $(this).text();
            if (label == "Checksum") {
                msgElement = new Array;
                $(".msgEle").each(function() {
                    if (label == $(this).text()) { // checksum 앞까지의 항목만 출력되게
                        return false; // return false: break  / return true: continue  
                    }
                    msgElement.push($(this).text());
                });
                madeMsgFrameCS(msgElement);
            } else {
                delMsgFrameCS();
            }
            madeMsgFrameTable(label);
        });
        $(document).on("mouseup", ".msgEle", function() {
            if (event.which == 3) {
                clicked_id = this.id;
                rightClick(clicked_id);
            }
        });

        /*cmd, rsp 클릭하면 frame 보여줌*/
        $('#tabCmd').on('click', '.cmdBtn', function() {
            $(".msgEle").remove();
            delMsgFrameTable();
            delMsgFrameCS();
            $("#commandChk").prop("checked", true).change();
            $("#msgName").val(this.id);
            var frameRequest = clickedMessageFrame(this.id, "Cmd");
            msgElement = frameRequest.msgElement;
            csDrop = frameRequest.csDrop;
        });
        $('#tabRsp').on('click', '.rspBtn', function() {
            $(".msgEle").remove();
            delMsgFrameTable();
            delMsgFrameCS();
            $("#responseChk").prop("checked", true).change();
            $("#msgName").val(this.id);
            var frameRequest = clickedMessageFrame(this.id, "Rsp");
            msgElement = frameRequest.msgElement;
            csDrop = frameRequest.csDrop;
        });
        $(document).on("mouseup", ".cmdBtn", function() {
            if (event.which == 3) {
                parentId = $(this).parent().attr('id');
                clicked_id = this.id;
                rightClick(clicked_id);
            }
        });
        $(document).on("mouseup", ".rspBtn", function() {
            if (event.which == 3) {
                parentId = $(this).parent().attr('id');
                clicked_id = this.id;
                rightClick(clicked_id);
            }
        });

        /* frame 조합할 때 cmp 정보 save 버튼 눌렀을 때*/
        $(document).on("click", "#mtUpdate", function() {
            var name = $(".mtName").val();
            var type = $(".mtType").val();
            var value = $(".mtValue").val();
            var length = $(".mtLength").val();
            var description = $(".mtDescription").val();
            var svid = $(".mtSvid").val();
            var multiValue = $(".mtMulti").val();

            if (msgCmpCkNull()) {
                var component = {
                "name" : name,
                "type" : type,
                "value" : value,
                "length" : length,
                "description" : description,
                "svid" : svid,
                "multiValue" : multiValue
                };

                var result = madeCmpJson(component);
                if (result.check == true) {
                    setGlobalValue("MsgCompo : " + name, JSON.stringify(result.component), 1);
                    //delMsgFrameTable();
                }
            }
        });
        var fromS = document.getElementsByClassName("fromS");
        var fromSNo;
        var toS = document.getElementsByClassName("toS");
        var toSNo;
        var methodS = document.getElementsByClassName("method");
        var methodSNo;
        // checksum : from to 범위 예외처리, method 선택하면 값 출력
        $(document).on("change", ".fromS, .toS, .method", function() {
            $("#result").val("");
            var valLen = new Array();
            var isNull = false;
            var maxValLen = 0;
            var checkLen = true;	// value의 length가 1 or max에 일정한지 판별
            fromSNo = fromS[0].selectedIndex;
            toSNo = toS[0].selectedIndex;
            methodSNo = methodS[0].selectedIndex;
            if (fromSNo - toSNo > 0) {
                alert("from to를 다시 선택하세요.");
                fromS[0].selectedIndex = 0;
                toS[0].selectedIndex = 0;
            } else {
				var i = 0;
				$('.msgEle').each(function () {
					if (i >= fromSNo && i <= toSNo) {
						var ckData = JSON.parse(getGlobalValue("MsgCompo : " + $(this).text()));
						if (maxValLen < ckData.value.length) {		// value length max 구하기
						    maxValLen = ckData.value.length;
						}
						valLen.push(ckData.value.length);	// value의 length 측정

						if (ckData.value[0] == "") { // value가 null 이면 계산 안함
							isNull = true;
							return false; // return false: break
						}
					}
					i++;
				});
				console.log(maxValLen);
				if (maxValLen != 1) {		// from ~ to 까지 value len 사이즈 통일한지 검사
				    for (i = 0; i < valLen.length; i++) {
				        if (valLen[i] != 1 && valLen[i] != maxValLen) {		// value 가 1 and maxLen이 아니면 체크썸 검사 못하게
				            checkLen = false;		// value의 len이 일정하지 않다
				        }
				    }
				} 
				if (checkLen == false) {
				    alert("value 들의 갯수가 일정하지 않아 checksum 계산을 할 수 없습니다.");
				} else if (isNull == true) {		
					alert("value 중에 null 값이 있어 checksum 계산을 할 수 없습니다.");
				} else {	// checksum 계산
					frame = madeFrameJson("", "");
					frame.checksum.from = fromSNo;
					frame.checksum.to = toSNo;
					
					for (i = 0; i < maxValLen; i++) {
					    var valString = "";
			            var valArray = new Array();
					    response = ajaxConvert(JSON.stringify(frame), i);
						if (response.code == 200) {
							console.log(response.message);
							response.data.forEach(function (value) {
							    valString = valString + value + " ";
							    valArray.push(value);
							});
						} else {
							console.log(response.message);
						}
						
						if ($(".method option:checked").text().indexOf("CRC") != -1) {	// crc 이면
						    calcButton_clicked(valString);
						} else {	
						    var sum = 0;
						    for (var j = 0; j < valArray.length; j++) {
						        sum += parseInt(roughScale(valArray[j], 16));
						    }
						    $("#result").val($("#result").val() + "0x" + sum.toString(16) + " / ");
						}
					}
				}
			}
            //checksum 결과 result 만들기          
            /*  var ctx = new Checksum("crc32"); // fnv32-0
             ctx.updateStringly("Hello World!!");
             console.log(ctx.result.toString(16)); */
        });

        /* from to 쪽 save 버튼 누르면 쿠키 저장*/
        $(document).on("click", "#csUpdate", function() {
            if (fromSNo - toSNo > 0) {
                alert("from to를 다시 선택하세요.");
            } else {
                /* from to 쿠키 저장  */
                var fromto = {
                "from" : fromSNo,
                "to" : toSNo,
                "method" : methodSNo,
                "result" : $("#result").val()
                };
                setCookie("FromTo : fromto", JSON.stringify(fromto), 1);
            }
        });

        //Hide contextmenu:
        $(document).contextmenu(function() {
            $(".contextmenu").hide();
        });

        $(document).click(function() {
            $(".contextmenu").hide();
        });

        $("#btnDelete").off().click(function() {
            if ($(document).find('div#' + clicked_id).attr('class').indexOf("msgEle") != -1) {
                delMsgFrameTable();
                delMsgFrameCS();
                deleteGlobalValue("MsgCompo : " + $("#" + clicked_id).text());
                if ($("#" + clicked_id).text() == "Checksum") {
                    csDrop = false;
                }
                $(document).find('div#' + clicked_id).remove();
                $(".contextmenu").hide();
            } else if (parentId == "tabCmd") {
                console.log("cmdBtn");
                $("#tabCmd").find("#" + clicked_id).remove();
                frame = {
	                "name" : clicked_id,
	                "type" : "command"
                };
                csDrop = resetFrame(frame, eqName);          
            } else if (parentId == "tabRsp") {
                console.log("rspBtn");
                $("#tabRsp").find("#" + clicked_id).remove();
                frame = {
                "name" : clicked_id,
                "type" : "response"
                };
                csDrop = resetFrame(frame, eqName); /* 초기화 */         
            } else {
                response = ajaxComponent("delete", eqName, clicked_id);
                if (response.code == 200) {
                    console.log(response.message);                
                    deleteGlobalValue("Compo : " + clicked_id);
                    cmpList.splice(cmpList.indexOf(clicked_id), 1);
                    $(document).find('div#' + clicked_id).remove();
                    $(".contextmenu").hide();
                    delCmpTable();
                    alert("Component가 삭제되었습니다.");
                } else {
                    console.log(response.message);
                }
            }           
        });

        $(".cmp").draggable({ /* 끌어올떄 */
	        appendTo : 'body',
	        containment : 'window',
	        scroll : false,
	        helper : 'clone',
	        opacity : "0.3"
        });

        var csDrop = false;
        var cnt = 0;
        //cmp는 끌어다놓으면 list의 새로운 json형식으로 추가, list끼리의 sort
        $("#msgFrame").droppable({
            drop : function(event, ui) {
                if (ui.draggable.attr('class').split(' ')[0] == "cmp") {
                    msgEleClicked();
                    var label = ui.draggable.attr('id');
                    cnt++;
                    if (label == "Checksum" && csDrop == false) { /* checksum이 없는 상태에서 checksum drop */
                        csDrop = true;
                        $(".msgEle").each(function() { /* from to 만들기 위한 리스트업 */
                            msgElement.push($(this).text());
                        });
                        deleteCookie("FromTo : fromto");
                        madeMsgFrameCS(msgElement);
                        $(this).append("<div class = 'msgEle btn btn-outline-primary active' id='msgEle-" + cnt + "'>" + label + "</div>");
                    } else if (label == "Checksum" && csDrop == true) {/* checksum이 있는 상태에서 checksum drop */
                        alert("Checksum은 1번만 사용할 수 있습니다.");
                    } else {
                        delMsgFrameCS();
                        $(this).append("<div class = 'msgEle btn btn-outline-primary active' id='msgEle-" + cnt + "'>" + label + "</div>");
                    }
                    var ckData = JSON.parse(getGlobalValue("Compo : " + label));
                    setGlobalValue("MsgCompo : " + label, JSON.stringify(ckData), 1);

                    madeMsgFrameTable(label);
                }
            }
        });

        $("#msgFrame").sortable({
        start : function(event, ui) {
            msgEleClicked();
        },
        update : function(event, ui) {
            $(document).on("mouseup", ".msgEle", function() {
                $(this).addClass("active");
            });

            msgElement = new Array;
            $(".msgEle").each(function() {
                if ("Checksum" == $(this).text()) { // checksum 앞까지의 항목만 출력되게
                    return false; // return false: break  / return true: continue  
                }
                msgElement.push($(this).text());
            });

            $(".fromS option, .toS option").remove();
            for (var i = 0; i < msgElement.length; i++) {
                $("<option value='" + msgElement[i] + "'>" + msgElement[i] + "</option>").appendTo(".fromS");
                $("<option value='" + msgElement[i] + "'>" + msgElement[i] + "</option>").appendTo(".toS");
            }
            /* var ckData = JSON.parse(getCookie("FromTo : fromto"));
            
            if (ckData) {
                $(".fromS").find("option:eq(" + ckData.from + ")").prop("selected", true);
                $(".toS").find("option:eq(" + ckData.to + ")").prop("selected", true);
                
                //$(".fromS").val(ckData.from).prop("selected", true);
                //$(".toS").val(ckData.to).prop("selected", true);
                $(".method").val(ckData.method).prop("selected", true);
                $(".result").val(ckData.result);
            } */
        }
        });

        $("#msgFrame").disableSelection();

        /* frameSave */
        $("#frameSave").click(function() {
            var msgName = $("#msgName").val();
            var frame = new Object();

            if (msgName == "") {
                alert("Message Frame 이름을 입력하세요.");
            } else {             
                var maxValLen = 0;
                var isNull = false;
                var checkLen = true;	// value의 length가 1 or max에 일정한지 판별
                var valLen = new Array();
                
				$('.msgEle').each(function () {
					var ckData = JSON.parse(getGlobalValue("MsgCompo : " + $(this).text()));
					if (maxValLen < ckData.value.length) {		// value length max 구하기
					    maxValLen = ckData.value.length;
					}
					valLen.push(ckData.value.length);	// value의 length 측정
					if (ckData.value[0] == "") { // value가 null 이면 계산 안함
						isNull = true;
						return false; // return false: break
					}					
				});
				
				if (maxValLen != 1) {		// 전체 value len 사이즈 통일한지 검사
				    for (var i = 0; i < valLen.length; i++) {
				        if (valLen[i] != 0 && valLen[i] != 1 && valLen[i] != maxValLen) {		// value가 0 && 1 && maxLen이 아니면 저장 불가
				            checkLen = false;		// value의 len이 일정하지 않다
				        }
				    }
				} 
				
				if (checkLen == false) {
				    alert("value 들의 갯수가 일정하지 않아 frame을 저장할 수 없습니다.");
				} else {
	                if ($("input:radio[id='commandChk']").is(":checked")) {
	                    if (isNull == true) {		
							alert("value 중에 null 값이 있어 frame을 저장할 수 없습니다.");
		                } else {
		                    var msgFrameType = "command";
		                    if ($("#tabCmd").find("#" + msgName).length) { /* 같은 이름 있으면 수정 */
		                        frame = madeFrameJson(msgName, msgFrameType);
		                        response = ajaxMessageFrame("put", eqName, JSON.stringify(frame));
		                        if (response.code == 200) {
		                            console.log(response.message);
		                            alert("Message Frame이 수정되었습니다.");
		                            setGlobalValue("CmdFrame : " + frame.name, JSON.stringify(frame), 1);
		                        } else {
		                            console.log(response.message);
		                        }
		                    } else {
		                        /* 같은 이름 없으면 신규 저장 */
		                        frame = madeFrameJson(msgName, msgFrameType);
		                        response = ajaxMessageFrame("post", eqName, JSON.stringify(frame));
		                        if (response.code == 200) {
		                            console.log(response.message);
		                            setGlobalValue("CmdFrame : " + frame.name, JSON.stringify(frame), 1);
		                            $("#tabCmd").append("<div class = 'cmdBtn btn btn-block btn-outline-primary' id = '" + msgName + "'>" + msgName + "</div>");
		                            alert("Message Frame이 저장되었습니다.");
		                        } else {
		                            console.log(response.message);
		                        }
		                    }
		                }
	                }
	                if ($("input:radio[id='responseChk']").is(":checked")) { /* 같은 이름 있으면 수정 */
	                    var msgFrameType = "response";
	                    if ($("#tabRsp").find("#" + msgName).length) {
	                        frame = madeFrameJson(msgName, msgFrameType);
	                        response = ajaxMessageFrame("put", eqName, JSON.stringify(frame));
	                        if (response.code == 200) {
	                            console.log(response.message);
	                            setGlobalValue("RspFrame : " + frame.name, JSON.stringify(frame), 1);
	                            alert("Message Frame이 수정되었습니다.");
	                        } else {
	                            console.log(response.message);
	                        }
	                    } else { /* 같은 이름 없으면 신규 저장 */
	                        frame = madeFrameJson(msgName, msgFrameType);
	                        response = ajaxMessageFrame("post", eqName, JSON.stringify(frame));
	                        if (response.code == 200) {
	                            console.log(response.message);
	                            setGlobalValue("RspFrame : " + frame.name, JSON.stringify(frame), 1);
	                            $("#tabRsp").append("<div class = 'rspBtn btn btn-block btn-outline-primary' id = '" + msgName + "'>" + msgName + "</div>");
	                            alert("Message Frame이 저장되었습니다.");
	                        } else {
	                            console.log(response.message);
	                        }
	                    }	                
	                }
				}
            }
        });

        /* frameCancel */
        $("#frameCancel").click(function() {
            $(".msgEle").remove();
            $("#msgName").val("");
            delMsgFrameTable();
            delMsgFrameCS();
            deleteCookie("FromTo : fromto");
            msgElement = new Array;
            csDrop = false;
        });

        /* frameDelete */
        $("#frameDelete").click(function() {
            var msgName = $("#msgName").val();
            if (msgName == "") {
                alert("삭제할 Message Frame 이름을 입력하시오.");
            } else {
                if ($("input:radio[id='commandChk']").is(":checked")) {
                    if ($("#tabCmd").find("#" + msgName).length) {
                        $("#tabCmd").find("#" + msgName).remove();
                        frame = {
                        "name" : msgName,
                        "type" : "command"
                        };

                        csDrop = resetFrame(frame, eqName); /* 초기화 */
                        msgElement = new Array;

                    } else {
                        alert("삭제할 Message Frame이 없습니다.");
                    }
                }
                if ($("input:radio[id='responseChk']").is(":checked")) {
                    if ($("#tabRsp").find("#" + msgName).length) {
                        $("#tabRsp").find("#" + msgName).remove();
                        frame = {
                        "name" : msgName,
                        "type" : "response"
                        };

                        csDrop = resetFrame(frame, eqName); /* 초기화 */
                        msgElement = new Array;
                    } else {
                        alert("삭제할 Message Frame이 없습니다.");
                    }
                }
            }
        });
    });

    function cardHeight() { /* card height 화면 꽉 차게  + frame tab 동작하는거*/
        var h = $(".content-wrapper").outerHeight(true);
        $(".left-div, .center-div").height(h * 0.99);
        h = $("#component").outerHeight(true);
        $("#cmpList").css("max-height", h * 0.8);

        //When page loads...
        $(".tab_content").hide(); //Hide all content
        $("ul.tabs li:first").addClass("active").show(); //Activate first tab
        $(".tab_content:first").show(); //Show first tab content

        //On Click Event
        $("ul.tabs li").click(function() {
            $("ul.tabs a").removeClass("active"); //Remove any "active" class
            $(this).find('a').addClass("active"); //Add "active" class to selected tab
            $(".tab_content").hide(); //Hide all tab content

            var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
            $(activeTab).fadeIn(); //Fade in the active ID content
            return false;
        });
    }

    function msgEleClicked() {
        $(".msgEle").each(function() {
            $(this).removeClass("active");
        });
    }

    function resetFrame(frame, eqName) {
        console.log(frame);
        response = ajaxMessageFrame("delete", eqName, JSON.stringify(frame));
        if (response.code == 200) {
            console.log(response.message);
           	if (frame.type == "command") {
				deleteGlobalValue("CmdFrame : " + frame.name);
           	} else if (frame.type == "response"){
				deleteGlobalValue("RspFrame : " + frame.name);
           	}
            deleteCookie("FromTo : fromto");
            $('#commandChk').prop('checked', true);
            $("#msgName").val("");
            $(".msgEle").remove();
            delMsgFrameTable();
            delMsgFrameCS();         
            //$(document).find('div#' + frame.name).remove();
            $(".contextmenu").hide();
            alert("Message Frame이 삭제되었습니다.");
            return false;
        } else {
            console.log(response.message);
            return true;
        }
    }

    function madeCmpTable() { /* cmp table 생성 */
        var table = "<div class='post' id='cmpTable-div'>" + "<div id='tableinfo'>" + "<table border='1' id='cmpTable'>" + "<tr><td>Name</td><td><input id='name'></td></tr>" + "<tr><td>Type</td><td><select id='type'><option value='text'>Text</option><option value='hex'>Hex</option></select></td></tr>" + "<tr><td>Value</td><td><input id = 'value'></td></tr>" + "<tr><td>Length</td><td><input type='number' id = 'length' onkeydown='return showKeyCode(event)'></td></tr>" + "<tr><td>Description</td><td><input id = 'description'></td></tr>" + "<tr><td>SVID</td><td><input id = 'svid'></td></tr>" + "<tr><td>Multi-Value</td><td><select class='MultiValueTF' id='multiValue'><option value='true'>True</option><option value='false'>False</option></select></td></tr>" + "</table>" + "<div style='float:right;'>" + "<p> (,)는 아스키값으로 입력하시오. <p>" + "<button id='addCmp'>Save</button>" + "<button id='cancelCmp'>Cancel</button>" + "</div>" + "</div>";
        delCmpTable();
        $("#component").append(table);
        $("#multiValue option:eq(1)").prop("selected", true);
        $("#cmpTable-div").css("height", "40%");
        var h = $("#component").outerHeight(true);
        $("#cmpList").css("max-height", h * 0.3);
    }

    function delCmpTable() { /* cmp table 삭제 */
        $("#cmpTable-div").remove();
        var h = $("#component").outerHeight(true);
        $("#cmpList").css("max-height", h * 0.8);
        return false;
    }

    function madeMsgFrameTable(label) { /* msgFrame-div 쪽에 table 생성 */
        var table = "<div id='msgTable-div' style='margin: 15% 15%;'>" + "<table border='1' id='msgTable' style='width: 100%;'>" + "<tr><td>Name</td><td><input class ='mtName'></td></tr>" + "<tr><td>Type</td><td><select class ='mtType'><option value='text'>Text</option><option value='hex'>Hex</option></select></td></tr>" + "<tr><td>Value</td><td><input class = 'mtValue'></td></tr>" + "<tr><td>Length</td><td><input type='number' class = 'mtLength' onkeydown='return showKeyCode(event)'></td></tr>" + "<tr><td>Description</td><td><input class = 'mtDescription'></td></tr>" + "<tr><td>SVID</td><td><input class = 'mtSvid'></td></tr>" + "<tr><td>Multi-Value</td><td><select class='mtMulti'><option value='true'>True</option><option value='false'>False</option></select></td></tr>" + "</table>" + "<button id='mtUpdate' style='float:right;'>Save</button>" + "</div>";
        delMsgFrameTable();
        $("#msgFrameTable-div").append(table);

        var ckData = JSON.parse(getGlobalValue("MsgCompo : " + label));

        $(".mtName").val(ckData.name);
        $(".mtType").val(ckData.type.toLowerCase()).prop("selected", true);
        var replaceVal = new Array;
        for (var i = 0; i < ckData.value.length; i++) {
            replaceVal.push(ckData.value[i].replace('%E2%96%B3', '△'));
        }
        $(".mtValue").val(replaceVal);
        $(".mtLength").val(ckData.length);
        $(".mtDescription").val(ckData.description);
        $(".mtSvid").val(ckData.svid);
        if (ckData.multiValue == true) {
            $(".mtMulti").val("true").prop("selected", true);
        } else if (ckData.multiValue == false) {
            $(".mtMulti").val("false").prop("selected", true);
        }
    }

    function delMsgFrameTable() { /* msgFrame-div 쪽에 table 삭제 */
        $("#msgTable-div").remove();
    }

    function madeMsgFrameCS(msgElement) { /* msgFrameCS-div 쪽에 from to 생성 */
        var fromToHtml = "<div class = 'fromTo' id='fromTo' style='margin: 20% 15%;'> " + "<div><label class='col-sm-4 col-form-label'>From</label><select class='fromS'></select></div>" + "<div><label class='col-sm-4 col-form-label'>To</label><select class='toS'></select></div>" + "<div><label class='col-sm-4 col-form-label'>Method</label><select id ='method' class='method'></select></div>" + "<div><label class='col-sm-4 col-form-label'>Result</label><input type='text' id = 'result' class='result' disabled/></div>" + "<button id='csUpdate' style='float:right;'>Save</button>" + "</div>";
        delMsgFrameCS();
        $("#msgFrameCS-div").append(fromToHtml);
        for (var i = 0; i < msgElement.length; i++) { // from to 만들기
            $("<option value='" + msgElement[i] + "'>" + msgElement[i] + "</option>").appendTo(".fromS");
            $("<option value='" + msgElement[i] + "'>" + msgElement[i] + "</option>").appendTo(".toS");
        }
        $(".toS").find("option:eq(" + (msgElement.length - 1) + ")").prop("selected", true);
        /*  var methods = [ "CRC32", "Adler32", "FNV32-0", "NV32-1", "Fletcher-16", "Fletcher-32", "BSD16" ];
         for (var i = 0; i < methods.length; i++) { // method 만들기
             $("<option value='" + methods[i] + "'>" + methods[i] + "</option>").appendTo(".method");
         } */
		$("<option value='SUM'>SUM</option>").appendTo(".method"); // sum 넣기
		fillCombobox(); // method opthion 채우기

        if (document.cookie.indexOf("FromTo : fromto") > 0) {
            var ckData = JSON.parse(getCookie("FromTo : fromto"));

            if (ckData) {
                $(".fromS").find("option:eq(" + ckData.from + ")").prop("selected", true);
                $(".toS").find("option:eq(" + ckData.to + ")").prop("selected", true);
                $(".method").find("option:eq(" + ckData.method + ")").prop("selected", true);
                $(".result").val(ckData.result);
            }
        }
    }

    function delMsgFrameCS() { /* msgFrameCS-div 쪽에 from to 삭제 */
        $("#fromTo").remove();
    }

    function madeCmpJson(cmp) {
        var checkmultivalue = true;
        var valueArray = cmp.value.split(',');
        var typeCk = true;
        var lenCk = true;

        for (var i = 0; i < valueArray.length; i++) {
            valueArray[i] = valueArray[i].replace(/ /g, ""); // 공백 제거
        }

        switch (cmp.type) {
        case 'text':
            for (var i = 0; i < valueArray.length; i++) { // len 값에 맞는 value 인지 판별
                if (cmp.length < valueArray[i].length) { // len < value.len 이면 error
					lenCk = false;
        	    } else if (cmp.length > valueArray[i].length) {	// len > value.len 이면 비트 채우기
                    if (valueArray != "") { // value 가 null이 아니면
                        var bitStuffing = cmp.length - valueArray[i].length;

                        for (var j = 0; j < bitStuffing; j++) {
                            valueArray[i] = "△" + valueArray[i];
                        }
                    }
                }
            }
            break;
        case 'hex':
            for (var i = 0; i < valueArray.length; i++) { // 0x 붙으면 값 파싱
                valueArray[i] = valueArray[i].replace("0x", "");
                valueArray[i] = valueArray[i].replace("0X", "");
            }

            for (var i = 0; i < valueArray.length; i++) { // 16 진수 값인지 판별
                for (var j = 0; j < valueArray[i].length; j++) {
                    if (!(valueArray[i].charAt(j) == '0' || valueArray[i].charAt(j) == '1' || valueArray[i].charAt(j) == '2' || valueArray[i].charAt(j) == '3' || valueArray[i].charAt(j) == '4' || valueArray[i].charAt(j) == '5' || valueArray[i].charAt(j) == '6' || valueArray[i].charAt(j) == '7' || valueArray[i].charAt(j) == '8' || valueArray[i].charAt(j) == '9' || valueArray[i].charAt(j) == 'A' || valueArray[i].charAt(j) == 'B' || valueArray[i].charAt(j) == 'C' || valueArray[i].charAt(j) == 'D' || valueArray[i].charAt(j) == 'E' || valueArray[i].charAt(j) == 'F' || valueArray[i].charAt(j) == 'a' || valueArray[i].charAt(j) == 'b' || valueArray[i].charAt(j) == 'c' || valueArray[i].charAt(j) == 'd' || valueArray[i].charAt(j) == 'e' || valueArray[i].charAt(j) == 'f')) {
                        typeCk = false;
                    }
                }
            }

            for (var i = 0; i < valueArray.length; i++) { // len 값에 맞는 value 인지 판별
                if ((cmp.length * 8) < (valueArray[i].length * 4)) { // len < value.len 이면 error
                    lenCk = false;
                } else if ((cmp.length * 8) > (valueArray[i].length * 4)) { // len > value.len 이면 비트 채우기
                    if (valueArray != "") { // value 가 null이 아니면
                        var bitStuffing = ((cmp.length * 8) - (valueArray[i].length * 4)) / 4;

                        for (var j = 0; j < bitStuffing; j++) {
                            valueArray[i] = "0" + valueArray[i];
                        }
                    }
                }
            }
            break;
        }

        if (typeCk == false) {
            alert("Type에 맞는 Value를 입력해주세요.");
            return {
                "check" : false
            };
        } else if (lenCk == false) {
            alert("Length에 맞는 Value를 입력해주세요.");
            return {
                "check" : false
            };
        } else {
            if (cmp.multiValue == 'true') {
                if (valueArray.length < 2) {
                    alert("멀티 밸류엔 2개이상의 속성값이 필요합니다.");
                    checkmultivalue = false;
                } else {
                    component = {
                    "name" : cmp.name,
                    "type" : cmp.type,
                    "value" : valueArray,
                    "length" : cmp.length,
                    "description" : cmp.description,
                    "svid" : cmp.svid,
                    "multiValue" : true
                    };
                }
            } else {
                if (valueArray.length > 1) {
                    alert("입력값을 하나만 입력하세요.");
                    checkmultivalue = false;
                } else {
                    component = {
                    "name" : cmp.name,
                    "type" : cmp.type,
                    "value" : valueArray,
                    "length" : cmp.length,
                    "description" : cmp.description,
                    "svid" : cmp.svid,
                    "multiValue" : false
                    };
                }
            }

            return {
            "check" : true,
            "component" : component,
            "checkmultivalue" : checkmultivalue
            };
        }

    }

    function madeFrameJson(msgName, msgFrameType) {
        var frame = new Object();
        var components = new Array();
        var fromto = new Object();

        $(".msgEle").each(function() {
            var ckData = JSON.parse(getGlobalValue("MsgCompo : " + $(this).text()));
            var data = new Object();
            data.name = ckData.name;
            data.type = ckData.type;
            data.value = ckData.value;
            data.length = ckData.length;
            data.description = ckData.description;
            data.svid = ckData.svid;
            data.multiValue = ckData.multiValue;
            // 리스트에 생성된 객체 삽입
            components.push(data);

            if ($(this).text() == "Checksum") {
                var ckData2 = JSON.parse(getCookie("FromTo : fromto"));
                
                if (ckData2) {
                    fromto = {
                    "from" : ckData2.from,
                    "to" : ckData2.to,
                    "method" : ckData2.method,
                    "result" : ckData2.result
                    };
                }
            }

        });
        frame.name = msgName;
        frame.type = msgFrameType;
        frame.components = components;
        frame.checksum = fromto;

        return frame;
    }

    function clickedMessageFrame(frameName, frameType) {
        var ckData = JSON.parse(getGlobalValue(frameType + "Frame : " + frameName));
        var components = ckData.components;
        var cnt = 0;
        var msgElement = new Array();
        var csDrop = false;
        components.forEach(function(component) {
            cnt++;
            msgElement.push(component.name);
            if (component.name == "Checksum") {
               	csDrop = true;
            }
            $("#msgFrame").append("<div class = 'msgEle btn btn-outline-primary' id='msgEle-" + cnt + "'>" + component.name + "</div>");
            setGlobalValue("MsgCompo : " + component.name, JSON.stringify(component), 1);
        });
        setCookie("FromTo : fromto", JSON.stringify(ckData.checksum), 1);
        return {"msgElement" : msgElement, "csDrop" : csDrop};
    }

    function leftClick(clicked_id) {
        madeCmpTable();
        $('input#name').attr('disabled', true);
        var ckData = JSON.parse(getGlobalValue("Compo : " + clicked_id));

        $('#tableinfo').find('#name').val(ckData.name);
        $('#tableinfo').find('#type').val(ckData.type.toLowerCase()).prop("selected", true);
        var replaceVal = new Array;
        for (var i = 0; i < ckData.value.length; i++) {
            replaceVal.push(ckData.value[i].replace('%E2%96%B3', '△'));
        }
        $('#tableinfo').find('#value').val(replaceVal);
        $('#tableinfo').find('#length').val(ckData.length);
        $('#tableinfo').find('#description').val(ckData.description);
        $('#tableinfo').find('#svid').val(ckData.svid);
        if (ckData.multiValue == true) {
            $('#tableinfo').find('#multiValue').val("true").prop("selected", true);
        } else if (ckData.multiValue == false) {
            $('#tableinfo').find('#multiValue').val("false").prop("selected", true);
        }
    }

    function rightClick(clicked_id) {
        $("div#" + clicked_id).contextmenu(function(e) {
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
    }

    function cmpCheckNull() {
        var name = $('#tableinfo').find("input#name").val();
        var type = $('#tableinfo').find("input#type").val();
        var value = $('#tableinfo').find("input#value").val();
        var length = $('#tableinfo').find("input#length").val();
        var description = $('#tableinfo').find("input#description").val();
        var svid = $('#tableinfo').find("input#svid").val();
        var multiValue = $('#tableinfo').find("#multiValue").val();

        if (name == "") {
            alert("name을 입력해주세요.");
            return false;
        }
        if (name.indexOf(".") != -1) {
            alert(". 를 포함하는 이름은 생성 할 수 없습니다.")
            return false;
        }
        return true;
    }

    function msgCmpCkNull() {
        var name = $(".mtName").val();
        var type = $(".mtType").val();
        var value = $(".mtValue").val();
        var length = $(".mtLength").val();
        var description = $(".mtDescription").val();
        var svid = $(".mtSvid").val();
        var multiValue = $(".mtMulti").val();

        if (name == "" || type == "" || length == "") {
            alert("공백이 있습니다. Value, Description, SVID를 제외한 모든 값을 입력해주세요.");
            return false;
        }
        if (name.indexOf(".") != -1) {
            alert(". 를 포함하는 이름은 생성 할 수 없습니다.")
            return false;
        }
        return true;
    }

    function ascii_to_hexa(str) { // 문자 -> hex 로 변환
        var arr1 = [];
        for (var n = 0, l = str.length; n < l; n++) {
            var hex = Number(str.charCodeAt(n)).toString(16);
            arr1.push(hex);
        }
        return arr1.join('');
    }
    
    function showKeyCode(event) {		// length 백스페이스 + 숫자만 입력가능하게
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if( keyID == 8 || ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) ) {
			return;
		} else {
			return false;
		}
	}   

    function roughScale(x, base) {		// 16진수 문자열 -> 16진수 숫자로
        const parsed = parseInt(x, base);
        if (isNaN(parsed)) {
            return 0
        }
        return parsed;
    }
    
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
    

    function sortUnorderedList(ul, sortDescending) {	// sort 함수
        if (typeof ul == "string")
            ul = document.getElementById(ul);

        var lis = ul.getElementsByTagName("DIV");
        var vals = [];

        for (var i = 0, l = lis.length; i < l; i++)
            vals.push(lis[i].outerHTML);

        vals.sort();

        if (sortDescending)
            vals.reverse();
        
        for (var i = 0, l = lis.length; i < l; i++){
            lis[i].outerHTML = vals[i];
            if (vals[i].indexOf("cmp") != -1) {	// cmp 이면
                $(".cmp").draggable({
                    appendTo : 'body',
                    containment : 'window',
                    scroll : false,
                    helper : 'clone',
                    opacity : "0.3"
                });
            }       
        }
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
				<div class="row drag_wrap">
					<!--    컴포넌트 -->
					<div class="left-div col-md-3">
						<div class="card component-div">
							<div class="card-header">
								<div class="left card-title">Component</div>							
								<button id="plusBtn" class="btn btn-secondary btn-sm">&nbsp+&nbsp</button>
								<button id="cmpSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="component">
								<div class="post" id="searchCmp-div">
									<div class="input-group input-group-sm">
										<input id = "searchCmp" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="cmpList">
								</div>
							</div>
						</div>
					</div>
						<!-- <div class="card msgList-div">
							<div class="card-header">
								<ul class="tabs nav nav-pills">
									<li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#tabCmd">Command</a></li>
									<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tabRsp">Response</a></li>
								</ul>
							</div>
							<div class="card-body">
								탭 콘텐츠 영역
								<div class="tab_container">
									<div id="tabCmd" class="tab_content">
										<div class="row" style="overflow: auto; padding: 10px"></div>
									</div>

									<div id="tabRsp" class="tab_content">
										<div class="row" style="overflow: auto; padding: 10px"></div>
									</div>

								</div>
							</div>
						</div> -->
					

					<!-- 메세지 프레임 만들기 -->
					<div class="center-div col-md-7">
						<div class="card">
							<div class="msgTitle card-header">
								<div class="left card-title" id="msgh3">Message Frame</div>
								<button type="button" id="ascii" class="btn btn-primary btn-sm float-right">ASCII</button>
							</div>
							<div class="card-body">
								<div class="msgR">
									<div class="btn-group" data-toggle="buttons">
									<!-- <div class="btn-group btn-group-toggle" data-toggle="buttons"> -->
										<label class="btn btn-secondary active"> <input type="radio" name="msgChkB" id="commandChk" checked="checked" />Command
										</label> <label class="btn btn-secondary"> <input type="radio" name="msgChkB" id="responseChk" />Response
										</label>
									</div>

									<div class="row" style="float: right">
										<label class="col-sm-2 col-form-label">Name</label>
										<div class="col-4">
											<input type="text" id="msgName" class="form-control">
										</div>
										<button type="button" id="frameSave" class="btn btn-success">Save</button>
										<button type="button" id="frameCancel" class="btn btn-secondary">Cancel</button>
										<button type="button" id="frameDelete" class="btn btn-danger">Delete</button>
									</div>

								</div>

								<div id="madeMsg">
									<div id="msgFrame"></div>
									<div id="msgFrame-div">
										<div id="msgFrameTable-div"></div>
										<div id="msgFrameCS-div"></div>
									</div>
								</div>

							</div>
						</div>

					</div>
				
					<!-- 메세지 프레임 -->
					<div class="right-div col-md-2">
						<div class="card command-div">
							<div class="card-header">
								<div class="left card-title">Command</div>
								<button id="cmdSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="tabCmdCard">
								<div class="post" id="searchCmd-div">
									<div class="input-group input-group-sm">
										<input id = "searchCmd" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="tabCmd">
								</div>
							</div>
						</div>
					
						<div class="card response-div">
							<div class="card-header">
								<div class="left card-title">Response</div>
								<button id="rspSortBtn" class="btn btn-secondary btn-sm">&nbsp↓↑&nbsp</button>
							</div>
							<div class="card-body" id="tabRspCard">
								<div class="post" id="searchRsp-div">
									<div class="input-group input-group-sm">
										<input id = "searchRsp" class="form-control form-control-navbar" type="search" placeholder="Search">
										<div class="input-group-append">
											<button class="btn btn-navbar" type="submit">
												<i class="fas fa-search"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="post" id="tabRsp">
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
			<!-- /.container-fluid --> </section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->

		<!-- common footer -->
		<%@include file="include/common_footer.jsp"%>
		<!-- ./common footer -->

	</div>
	<ul class="contextmenu">
		<li><a id="btnDelete">Delete</a></li>
	</ul>
</body>
</html>