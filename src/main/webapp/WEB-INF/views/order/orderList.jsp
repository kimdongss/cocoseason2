<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>주문 목록</title>
</head>
<body>

<h2>주문 목록</h2>

<table border="1">
<tr><th>주문 ID</th><th>회원 ID</th><th>주문 날짜</th><th>상세 보기</th></tr>

<c:forEach var="order" items="${orderList}">
<tr>
<td>${order.orderId}</td>
<td>${order.memberId}</td>
<td>${order.orderDate}</td>
<td><a href="<c:url value='/order/detail?orderId=${order.orderId}' />">상세 보기</a></td></tr>

</c:forEach>

</table>

</body></html>
