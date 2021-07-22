<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
    function rand(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    window.onload = function () {
        const buildings = [100, 111, 211, 214, 305, 406, 408, 414, 415];
        let randomIndex = rand(0, 9);
        let randomTime = rand(1000, 10000);
        setTimeout(function () {
            window.location = "https://www.somoonhouse.com/kongtori/_qr_access.jsp?BuildingId="+buildings[randomIndex];
        }, randomTime);
        console.log(buildings[randomIndex], randomTime);
    }
</script>