<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page language="java" import="myPackage.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
</head>
<body>
<%
    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    String sql = "";

    //건물 Id
    String Building_id = "415"; // 임시로 융복합관

    sql = "insert into ACCESS (Id, BuildingId, AccessAt) values(default, ?, default)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, Building_id);
    pstmt.executeUpdate();

    //DB객체 종료
    pstmt.close();
    conn.close();
%>
<script>
    history.back(-1);
</script>
</body>
</html>


