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
<script>
    // 마커를 표시할 위치와 title 객체 배열입니다
    var positions = [
        {
            title: '청룡관',
            latlng: new kakao.maps.LatLng(35.888036, 128.6049341),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/매우위험.png'
        },
        {
            title: '공대9호관',
            latlng: new kakao.maps.LatLng(35.8868806, 128.607485),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/위험.png'
        },
        {
            title: '공대12호관',
            latlng: new kakao.maps.LatLng(35.8882208, 128.6095869),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/매우위험.png'
        },
        {
            title: 'IT융복합공학관',
            latlng: new kakao.maps.LatLng(35.8879478, 128.610912),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/보통핀.png'
        },
        {
            title: '도서관',
            latlng: new kakao.maps.LatLng(35.89179314720078, 128.612073437168),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/위험.png'
        },
        {
            title: '본관',
            latlng: new kakao.maps.LatLng(35.890438622838005, 128.61200986383307),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/보통핀.png'
        },
        {
            title: 'IT4호관',
            latlng: new kakao.maps.LatLng(35.887679751076476, 128.6106083410824),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/보통핀.png'
        },
        {
            title: '복지관',
            latlng: new kakao.maps.LatLng(35.888995202490804, 128.61448454782513),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/위험.png'
        },
        {
            title: '수영장',
            latlng: new kakao.maps.LatLng(35.89021659135035, 128.60583974362083),
            imageSrc: 'https://www.somoonhouse.com/kongtori/img/icon/매우위험.png'
        }
    ];

    // 마커 이미지의 이미지 주소입니다
    // var imageSrc = 'https://www.somoonhouse.com/kongtori/img/icon/매우위험.png';

    for (var i = 0; i < positions.length; i ++) {

        // 마커 이미지의 이미지 크기 입니다
        var imageSize = new kakao.maps.Size(59, 69);
        imageOption = {offset: new kakao.maps.Point(29, 69)};

        // 마커 이미지를 생성합니다
        var markerImage = new kakao.maps.MarkerImage(positions[i].imageSrc, imageSize, imageOption);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            map: map, // 마커를 표시할 지도
            position: positions[i].latlng, // 마커를 표시할 위치
            title : positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
            image : markerImage // 마커 이미지
        });
    }
</script>
<script>
    // var imageSrc = 'https://www.somoonhouse.com/kongtori/img/icon/매우위험.png', // 마커이미지의 주소입니다
    //     imageSize = new kakao.maps.Size(59, 69), // 마커이미지의 크기입니다
    //     imageOption = {offset: new kakao.maps.Point(29, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
    //
    // // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
    // var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
    //     markerPosition = new kakao.maps.LatLng(35.8868829, 128.6063104); // 마커가 표시될 위치입니다
    //
    // // 마커를 생성합니다
    // var marker = new kakao.maps.Marker({
    //     position: markerPosition,
    //     image: markerImage // 마커이미지 설정
    // });

    // // 마커가 지도 위에 표시되도록 설정합니다
    // marker.setMap(map);
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
