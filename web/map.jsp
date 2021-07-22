<%--
  Created by IntelliJ IDEA.
  User: yejinlee
  Date: 2021/07/21
  Time: 2:46 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page language="java" import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
  <title>거긴위허맵! - 경북대학교 건물 별 코로나 확산 위험도 측정 지도</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1867e573d7e35c6feb65089266c27b35"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
  <!-- 합쳐지고 최소화된 최신 CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
  <!-- 부가적인 테마 -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
  <!-- 합쳐지고 최소화된 최신 자바스크립트 -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/kongtori/css/map.css"/>
  <!-- 서버에 올릴땐 css경로 아래처럼 바꾸어주어야함-->
  <!--link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/kongtori/css/map.css"/-->
</head>

<body>
<div id="map"></div>
<div id="float-frame">
  <div id="search-area">
    <form id="search-building" name="search-building" method="POST" action="map.jsp">
      <input type="text" id="search-text" name="search-text" placeholder="건물명을 입력해주세요." />
      <input id="search-btn" type="submit" value="" style="border:none;"/>
    </form>
  </div>
  <%
    // 변수 선언
    int cnt = 0;
    String Xpos = "35.8868829";
    String Ypos = "128.6063104";

    // 검색 단어 받아오기
    String search = request.getParameter("search-text");

    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    Statement stmt = null;
    String sql = "";
    ResultSet rs = null;

    if(search==null || search.equals("")) {
      Xpos = "35.8868829";
      Ypos = "128.6063104";
    } else {
      sql = "SELECT Xaxis, Yaxis FROM BUILDING WHERE Name like \"%" + search + "%\"";
      pstmt = conn.prepareStatement(sql);
      rs = pstmt.executeQuery();
      while (rs.next()) {
        cnt++;
        Xpos = rs.getString("Xaxis");
        Ypos = rs.getString("Yaxis");
      }
      if(cnt == 0) {
//                검색 결과가 없습니다 alert
        Xpos = "35.8868829";
        Ypos = "128.6063104";
      } else if(cnt > 1) {
//                다시 검색해주세요 모달창
      } else {
//                디비에서 가져온 좌표로 이동
      }
    }
  %>
  <%--  <div id="cal">--%>
  <%--    <img src="https://somoonhouse.com/kongtori/img/icon/cal.png">--%>
  <%--  </div>--%>
  <%--  <div id="slider-bar">--%>
  <%--    <%=Xpos%><%=Ypos%><%=search%>--%>
  <%--  </div>--%>
</div>
<div id="black">
</div>
<div id="modal">
  <div id="modal-head">
    <div id="knu-logo">
      <div id="knu-logo-img"></div>
    </div>
    <h3 id="building-name">공대 9호관</h3>
    <div id="modal-subhead">
      <div id="face-icon"></div>
      <span id="state">위험</span>
      <span id="percent">(52%)</span>
      <div id="info">i</div>
      <div id="info-desc">
        이 수치는 참고용 입니다. 위험도 계산식은 다음과 같습니다.<br>
        65 * (기준시간 이내 출입한 사람 수 / (수용인원)) + <br>
        20 * (취식여부 * 가중치 * 식사시간가중치) + <br>
        15 * (운동여부*가중치) + <br>
        5 * (계절가중치)
      </div>
    </div>
  </div>
  <div id="modal-body">
    <div class="modal-item">
      <div class="modal-item-img">
        <div class="modal-item-icon">
          <div class="modal-item-icon-img" id="doorgray">
            <div id="door-red">
              <img src="https://somoonhouse.com/kongtori/img/icon/door_colored.png">
            </div>
          </div>
          <div class="modal-item-icon-img" id="doorcolored">
            <div id="door-gray">
              <img src="https://somoonhouse.com/kongtori/img/icon/door.png">
            </div>
          </div>
          <!--
          <img src="https://somoonhouse.com/kongtori/img/icon/door.png">
          <img src="https://somoonhouse.com/kongtori/img/icon/door_colored.png">
          -->
        </div>
      </div>
      <h3 class="modal-item-title">1시간 이내 출입 인원</h3>
      <h3 class="modal-item-subtitle" id="access-num">45명</h3>
    </div>
    <div class="modal-item">
      <div class="modal-item-img">
        <div class="modal-item-icon">
          <img src="https://somoonhouse.com/kongtori/img/icon/people.png">
        </div>
      </div>
      <h3 class="modal-item-title">현재 예상 인원</h3>
      <h3 class="modal-item-subtitle" id="people-num">약 73명</h3>
    </div>
    <div class="modal-item">
      <div class="modal-item-img">
        <div class="modal-item-icon">
          <div class="pie-chart"><span class="center">80%</span></div>
        </div>
      </div>
      <h3 class="modal-item-title">공간 밀집도</h3>
      <h3 class="modal-item-subtitle" id="density-state">혼잡</h3>
    </div>
    <div class="modal-item">
      <div class="modal-item-img">
        <div class="modal-item-icon">
          <img id="eatable-gray" src="https://somoonhouse.com/kongtori/img/icon/eatable.png">
          <img id="eatable-red" src="https://somoonhouse.com/kongtori/img/icon/eatablecolored.png">
        </div>
      </div>
      <h3 class="modal-item-title">취식 가능 여부</h3>
      <h3 class="modal-item-subtitle" id="eatable-state">불가능</h3>
    </div>
    <div class="modal-item-wide">
      <img id="graph" src="https://somoonhouse.com/kongtori/img/graph.png">
      <h3 class="modal-item-subtitle">현재 시간 기준 평균적으로 위험도가 높은 시간입니다.</h3>
    </div>
  </div>
</div>
</body>
<script>
  /*****UI 관련 스크립트*****/

  //모달창 띄우기
  function modalPopUp(pos){
    // console.log(pos);
    //값 가져오기
    var dangerous_percent_str = pos["Dangerous"]; //위험도
    var access_num_str = pos["anHourCnt"]; //1시간 이내 출입인원
    var people_num = pos["Cnt"]; //예상인원
    var density_percent_str = pos["Density"]; //밀집도
    var eatable_str = pos["Eatable"]; //취식여부
    var building_name = pos["Name"]; //건물이름

    //처리 할 자료형으로 변경 (숫자, bool값, 문자열 등)
    var dangerous_percent = parseInt(dangerous_percent_str) + '';
    var density_percent = parseInt(Number(density_percent_str)*100+'');
    var access_num = (100 - Number(density_percent)) + '%';
    var eatable;
    var eatable_kor;
    if(eatable_str == '1'){eatable = true; eatable_kor="가능"}
    else {eatable = false; eatable_kor="불가능"}
    var dangerous_color;
    var dangerous_str;
    var dangerous_url = "https://somoonhouse.com/kongtori/img/icon/";
    if(parseInt(dangerous_percent)>80){
      dangerous_str = "매우위험";
      dangerous_url += "verydangerous_colored.png";
      dangerous_color = "#282828";
    }
    else if(parseInt(dangerous_percent)>50){
      dangerous_str = "위험";
      dangerous_url += "dangerous_colored.png";
      dangerous_color = "#ea483e";
    }
    else{
      dangerous_str = "보통";
      dangerous_url += "normal_colored.png";
      dangerous_color = "#57a6df";
    }
    var density_kor;
    if(parseInt(density_percent+'') > 80){
      density_kor = '매우 혼잡';
    }
    else if(parseInt(density_percent+'') > 50){
      density_kor = '혼잡';
    }
    else{
      density_kor = '보통';
    }

    //ui 조절
    //반투명 검은 배경 덮고 모달창 띄우기
    $('div#black').css('display', 'block');
    $('div#modal').css('display', 'block');
    //인포그래픽 그래프, 수치 조정
    //건물이름 바꾸기
    $('#building-name').text(building_name);
    //얼굴아이콘 바꾸기
    $('#face-icon').css('background', "url("+dangerous_url+")");
    $('#face-icon').css('background-size', "15px 15px");
    //위험도 상태 바꾸기
    $('#state').text(dangerous_str);
    $('#state').css('color', dangerous_color);
    //위험도 바꾸기
    $('#percent').text("("+dangerous_percent+"%)");
    //1시간이내 출입인원 인포그래픽(밀집도사용)
    $('div#door-gray').css('height', '100%');
    setTimeout(function (){$('div#door-gray').css('height', access_num);}, 10);
    //1시간이내 출입인원 수 변경
    $('#access-num').text("약 " + access_num_str + "명");
    //예상인원 수 변경
    $('#people-num').text(people_num + "명");
    //밀집도 인포그래피랑 밀집도 퍼센트 변경
    setTimeout(function (){draw(density_percent);}, 10);
    //밀집도 글자 변경
    $('#density-state').text(density_kor);
    //취식여부 인포그래피 변경
    if(eatable){$('#eatable-red').css('display', 'inline-block'); $('#eatable-gray').css('display', 'none'); }
    else {$('#eatable-red').css('display', 'none'); $('#eatable-gray').css('display', 'inline-block'); }
    //취식여부 글자부분 변경
    $('#eatable-state').text(eatable_kor);
  }

  //모달창 닫기
  //반투명 검은 배경 누르면 모달창, 검은배경 다 닫기
  $('div#black').click(function (){
    $('div#black').css('display', 'none');
    $('div#modal').css('display', 'none');
  })


  //원 그래프 그리는 거
  function draw(percent){
    var i = 0;
    var func1 = setInterval(function(){
      if(i<=percent){
        color(i);
        i++
      } else{
        clearInterval(func1);
      }
    },10);
  }
  function color(i){
    $('.pie-chart').css(
            "background", "conic-gradient(#e15f5a 0%,#e15f5a " + i + "%, #c4c4c4 " + i + "%, #c4c4c4 100%)"
    );
    $('.center').text(i+'%');
  }

  //info 창 띄우기
  $('#info').mouseover(function (){
    $('#info-desc').css('display', 'block');
  })
  $('#info').mouseout(function (){
    $('#info-desc').css('display', 'none');
  })
</script>
<script>
  var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
  var options = { //지도를 생성할 때 필요한 기본 옵션
    // center: new kakao.maps.LatLng(35.8868829, 128.6063104), //지도의 중심좌표.
    center: new kakao.maps.LatLng("<%=Xpos%>", "<%=Ypos%>"), //지도의 중심좌표.
    level: 3 //지도의 레벨(확대, 축소 정도)
  };

  var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
  // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
  if (navigator.geolocation) {
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude, // 위도
              lon = position.coords.longitude; // 경도
      var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
              message = '<div style="padding:5px;">여기에 계신가요?!</div>'; // 인포윈도우에 표시될 내용입니다
      // 마커와 인포윈도우를 표시합니다
      displayMarker(locPosition, message);
    });
  } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667);
    displayMarker(locPosition);
  }

  // 지도에 마커와 인포윈도우를 표시하는 함수입니다
  function displayMarker(locPosition) {
    // 마커를 생성합니다
    // 마커 이미지의 이미지 크기 입니다
    var imageSize = new kakao.maps.Size(30, 30);
    imageOption = {offset: new kakao.maps.Point(15, 15)};
    // 마커 이미지를 생성합니다
    var markerImage = new kakao.maps.MarkerImage("https://www.somoonhouse.com/kongtori/img/icon/myLocation.png", imageSize, imageOption);
    var marker = new kakao.maps.Marker({
      map: map,
      position: locPosition,
      image : markerImage // 마커 이미지
    });
    // 지도 중심좌표를 접속위치로 변경합니다
    map.setCenter(locPosition);
  }

  // 지정 좌표로 부드럽게 이동시키기
  function panTo(Xpos, Ypos) {
    // 이동할 위도 경도 위치를 생성합니다
    var moveLatLon = new kakao.maps.LatLng(Xpos, Ypos);

    // 지도 중심을 부드럽게 이동시킵니다
    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
    map.panTo(moveLatLon);
  }
</script>
<script>
  let arr = null;
  let arrOrigin = null;
  let markers = [];
  $('document').ready(function(){
    setInterval(function(){
      loadMap();
    }, 500);
  })
  function loadMap() {
    // 마커를 표시할 위치와 title 객체 배열입니다
    var positions = $.get("https://www.somoonhouse.com/kongtori/_calculate_dangerous.jsp", function (data) {
      return $(data.positions);
    }).then((positions) => { // 마커 생성 코드
      let position = positions.positions;
      if(arr != null && arr == position){
        return;
      }
      arr = JSON.parse(JSON.stringify(position));
      if(markers.length != 0){
        clearMarker();
      }
      for (var i = 0; i < position.length; i++) {
        // 마커 이미지의 이미지 크기 입니다
        var imageSize = new kakao.maps.Size(59, 69);
        imageOption = {offset: new kakao.maps.Point(29, 69)};

        // 마커 이미지를 생성합니다
        var markerImage = new kakao.maps.MarkerImage(position[i]["imageSrc"], imageSize, imageOption);

        var latlng = new kakao.maps.LatLng(position[i]["Xaxis"], position[i]["Yaxis"]);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
          position: latlng, // 마커를 표시할 위치
          title: position[i]["Name"], // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
          image: markerImage // 마커 이미지
        });
        marker.setMap(map);
        kakao.maps.event.addListener(marker, 'click', makeClickListener(map, marker, position[i]));
        markers.push(marker);
      }
      return markers;
    }).then((markers) => {
      for (var i = 0; i < markers.length; i ++) {
        let X = markers[i].getPosition().Ma;
        let Y = markers[i].getPosition().La;

        // 마커 클릭 event
        kakao.maps.event.addListener(markers[i], 'click', function () {
          panTo(X, Y);
          setTimeout("modalPopUp()", 400);
        });
      }
    });

  }
  //클로저 함수
  function makeClickListener(map, marker, pos) {
    return function () {
      modalPopUp(pos);
    }
  }
  function clearMarker(){
    for (let i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }
    markers = [];
  }
</script>
</html>
