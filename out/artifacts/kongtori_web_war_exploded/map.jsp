<%--
  Created by IntelliJ IDEA.
  User: yejinlee
  Date: 2021/07/21
  Time: 2:46 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/map.css"/>
</head>

<body>
  <div id="map"></div>
  <div id="float-frame">
    <div id="search-area">
      <input type="text" id="search-text">
      <div id="search-btn"></div>
    </div>
    <div id="cal">
      <img src="https://somoonhouse.com/kongtori/img/icon/cal.png">
    </div>
    <div id="slider-bar">

    </div>
  </div>
</body>
<script>
  /*
  var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
  var options = { //지도를 생성할 때 필요한 기본 옵션
    center: new kakao.maps.LatLng(35.8868829, 128.6063104), //지도의 중심좌표.
    level: 3 //지도의 레벨(확대, 축소 정도)
  };

  var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
   */
</script>
</html>
