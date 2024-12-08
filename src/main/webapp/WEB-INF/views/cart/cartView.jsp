<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
</head>
<body>
    <h1>장바구니</h1>
    <c:if test="${not empty cartItems}">
        <table border="1">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>가격</th>
                    <th>수량</th>
                    <th>총액</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.unitPrice}</td>
                        <td>${item.quantity}</td>
                        <td>${item.unitPrice * item.quantity}</td>
                        <td><a href="/cart/remove?spCartId=${item.spCartId}">삭제</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="/order/place">주문하기</a> <!-- 주문하기 버튼 추가 -->
    </c:if>
    <c:if test="${empty cartItems}">
        <p>장바구니에 상품이 없습니다.</p>
    </c:if>
    <a href="/product/list">상품 목록으로 돌아가기</a>
</body>
</html>