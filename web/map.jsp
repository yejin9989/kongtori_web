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

    if(search.equals("")) {
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
      if(cnt == 1) {
//                디비에서 가져온 좌표로 이동
      } else if(cnt > 1) {
//                다시 검색해주세요 모달창
      } else {
//                검색 결과가 없습니다 모달창
      }
    }
  %>
  <div id="cal">
    <img src="https://somoonhouse.com/kongtori/img/icon/cal.png">
  </div>
  <div id="slider-bar">
    <%=Xpos%><%=Ypos%><%=search%>
  </div>
</div>
</body>
<script>

  var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
  var options = { //지도를 생성할 때 필요한 기본 옵션
    // center: new kakao.maps.LatLng(35.8868829, 128.6063104), //지도의 중심좌표.
    center: new kakao.maps.LatLng("<%=Xpos%>", "<%=Ypos%>"), //지도의 중심좌표.
    level: 3 //지도의 레벨(확대, 축소 정도)
  };

  var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

  // 이게 내가 말했던 panTo 지정 좌표로 부드럽게 이동시키는 함수!

  // function panTo(Xpos, Ypos) {
  //     // 이동할 위도 경도 위치를 생성합니다
  //     var moveLatLon = new kakao.maps.LatLng(Xpos, Ypos);
  //
  //     // 지도 중심을 부드럽게 이동시킵니다
  //     // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
  //     map.panTo(moveLatLon);
  // }
</script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
  // 어떤 이벤트를 기준으로 해야할지 모르겠어서 일단 검색 버튼 누르는거 기준으로 삼았구
  // 밑에처럼 해보고 setTimeout() 써서도 해봤는데 panTo 부르기도 전에 리로드하더라 ㅠㅠ

  <%--$('#search-btn').click(function(){--%>
  <%--    panTo("<%=Xpos%>" , "<%=Ypos%>");--%>
  <%--})--%>
</script>
</html>
