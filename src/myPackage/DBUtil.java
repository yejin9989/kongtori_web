package myPackage;
import java.sql.*;

public class DBUtil {

    public static Connection getMySQLConnection() {

        Connection conn = null;

        try {
            String serverIP = "localhost";
            String dbname = "somunhouse";
            String portNum = "3306";
            String url = "jdbc:mysql://"+serverIP+":"+portNum+"/"+dbname+"?serverTimezone=Asia/Seoul";
            String user = "somunhouse";
            String pass = "somun500^^";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL connecting error!<br/>");
        } catch(SQLException e) {
            e.printStackTrace();
        }

        return conn;
    }
    public static void close(Connection conn) {
        try {if(conn != null) {conn.close();}}catch(Exception e) {e.printStackTrace();}
    }
    public static void close(Statement stmt) {
        try {if(stmt != null) {stmt.close();}}catch(Exception e) {e.printStackTrace();}
    }
    public static void close(PreparedStatement pstmt) {
        try {if(pstmt != null) {pstmt.close();}}catch(Exception e) {e.printStackTrace();}
    }
    public static void close(ResultSet rs) {
        try {if(rs != null) {rs.close();}}catch(Exception e) {e.printStackTrace();}
    }
}