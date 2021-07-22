<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="org.json.simple.JSONObject,org.json.simple.JSONArray,org.apache.jasper.JasperException" %>

<%
    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = "";

    //필요한 변수 선언
    String Id = "";
    String Name = "";
    String Eatable = "";
    String Exercise = "";
    String Xaxis = "";
    String Yaxis = "";
    String StayTime = "";
    String TotalArea = "";
    String Cnt = "";
    double Dangerous = 0;
    double season = 0.5;
    double mealTime = 0.5;
    String standardTime = "";

    // building 정보 불러오기
    sql = "select * from BUILDING order by Id";
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();
    LinkedList<LinkedHashMap<String, String>> buildingInfoList = new LinkedList<LinkedHashMap<String, String>>();
    while(rs.next()) {
        // arraylist 에 저장
        LinkedHashMap building = new LinkedHashMap<String, String>();

        Id = rs.getString("Id");
        Name = rs.getString("Name");
        Eatable = rs.getString("Eatable");
        Exercise = rs.getString("Exercise");
        Xaxis = rs.getString("Xaxis");
        Yaxis = rs.getString("Yaxis");
        StayTime = rs.getString("StayTime");
        TotalArea = rs.getString("TotalArea");

        building.put("Id", Id);
        building.put("Name", Name);
        building.put("Eatable", Eatable);
        building.put("Exercise", Exercise);
        building.put("Xaxis", Xaxis);
        building.put("Yaxis", Yaxis);
        building.put("StayTime", StayTime);
        building.put("TotalArea", TotalArea);

        buildingInfoList.add(building);
    }

    // 최종 리턴해줄 json
    JSONArray buildingInfoList2 = new JSONArray();
    JSONObject buildingInfo = new JSONObject();

    for(LinkedHashMap<String, String> b : buildingInfoList) {
        // 포맷변경 ( 년월일 시분초)
        SimpleDateFormat sdformat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        // 현재시간
        Date date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        //계절가중치 계산
        if((5<cal.MONTH && cal.MONTH<9) || (cal.MONTH == 12 || cal.MONTH < 2)) {
            season = 1;
        }
        //식사시간 가중치 계산
        if(cal.HOUR == 9 || cal.HOUR == 12 || cal.HOUR == 18) {
            mealTime = 1;
        }
        // 기준시간 계산
        cal.add(Calendar.MINUTE, Integer.parseInt(b.get("StayTime")));
        standardTime = sdformat.format(cal.getTime());

        // 기준 시간 동안 해당 건물에 있었던 인원수 받아오기
        sql = "select IFNULL((select count(*) cnt from ACCESS where AccessAt > '" + standardTime + "' and BuildingId = " + b.get("Id") +"), 0) Cnt";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        while(rs.next()) {
            Cnt = rs.getString("Cnt");
        }

        // 위험도 계산: 65 * (기준시간 이내 출입한 사람 수 / (수용인원)) + 20 * (취식여부 * 식사시간가중치) + 15 * (운동여부) + 5 * (계절가중치)
        Dangerous = 65 * (Integer.parseInt(Cnt)/Integer.parseInt(b.get("TotalArea"))) + 20 * (Integer.parseInt(b.get("Eatable")) * mealTime) + 15 * Integer.parseInt(b.get("Exercise")) + 5 * season;

        // json에 담아서 리턴 이름, 아이디, 이미지, x, y
        JSONObject building = new JSONObject();
        building.put("Id", b.get("Id"));
        building.put("Name", b.get("Name"));
        building.put("Xaxis", b.get("Xaxis"));
        building.put("Yaxis", b.get("Yaxis"));
        building.put("Dangerous", Dangerous);
        if(Dangerous > 80) {
            building.put("imageSrcc", "https://www.somoonhouse.com/kongtori/img/icon/매우위험.png");
        } else if(Dangerous > 50) {
            building.put("imageSrc", "https://www.somoonhouse.com/kongtori/img/icon/위험.png");
        } else {
            building.put("imageSrc", "https://www.somoonhouse.com/kongtori/img/icon/보통핀.png");
        }

        buildingInfoList2.add(building);
    }
    buildingInfo.put("positions", buildingInfoList2);

    // 응답시 json 타입이라는 걸 명시 ( 안해주면 json 타입으로 인식하지 못함 )
    response.setContentType("application/json");
    response.setHeader("Access-Control-Allow-Origin", "*");
    out.print(buildingInfo); // json 형식으로 출력

    //DB객체 종료
    pstmt.close();
    conn.close();
%>


