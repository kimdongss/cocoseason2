<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
   <title>Home</title>
</head>
<body>
   <h2>메인페이지</h2>
   <a href="<c:url value='/board/list' /> ">게시글 목록 페이징</a>
   <br>
   <a href="<c:url value='/product/list' /> ">상품목록</a>
   <br>
   <a href="<c:url value='/member/list' /> ">회원 목록</a>
   
</body>
</html>
