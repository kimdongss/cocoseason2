<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>내 주문 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>내 주문 목록</h2>

        <!-- 주문 목록 테이블 -->
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>주문 ID</th>
                    <th>상품 ID</th>
                    <th>회원 ID</th>
                    <th>상품명</th>
                    <th>단가</th>
                    <th>수량</th>
                    <th>총 가격</th>
                    <th>배송 주소</th>
                    <th>전화번호</th>
                </tr>
            </thead>
            <tbody>
                <!-- 주문 목록 반복 출력 -->
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.productId}</td>
                        <td>${order.memberId}</td>
                        <td>${order.productName}</td>
                        <td><fmt:formatNumber value="${order.unitPrice}" type="currency" currencySymbol="₩" /></td>
                        <td>${order.quantity}</td>
                        <td><fmt:formatNumber value="${order.unitPrice * order.quantity}" type="currency" currencySymbol="₩" /></td>
                        <td>${order.address}</td>
                        <td>${order.phone}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 장바구니 페이지로 돌아가는 버튼 -->
        <a href="<c:url value='/cart/view'/>" class="btn btn-primary">장바구니로 돌아가기</a>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
