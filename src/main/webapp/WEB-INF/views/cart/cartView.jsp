<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>장바구니</h1>

        <!-- 장바구니 아이템이 있을 때 -->
        <c:if test="${not empty cartItems}">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>상품ID</th>
                        <th>상품명</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>소계</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 총 가격 초기화 -->
                    <c:set var="totalPrice" value="0" />
                    <!-- 장바구니 아이템 리스트 반복 -->
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <!-- 상품ID, 상품명, 가격 출력 -->
                            <td>${item.productId}</td>
                            <td>${item.productName}</td>
                            <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₩" /></td>
                            <td>
                                <!-- 수량 증가 버튼 -->
                                <button class="btn btn-sm btn-secondary decrease-quantity" data-spcartid="${item.spCartId}">-</button>
                                <span class="quantity">${item.quantity}</span>
                                <!-- 수량 감소 버튼 -->
                                <button class="btn btn-sm btn-secondary increase-quantity" data-spcartid="${item.spCartId}">+</button>
                            </td>
                            <!-- 소계 출력 -->
                            <td><fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="₩" /></td>
                            <!-- 삭제 버튼 -->
                            <td>
                                <button class="btn btn-danger delete-btn" data-spCartId="${item.spCartId}">삭제</button>
                            </td>
                        </tr>
                        <!-- 총 가격 계산 -->
                        <c:set var="totalPrice" value="${totalPrice + (item.unitPrice * item.quantity)}" />
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-end"><strong>총 합계:</strong></td>
                        <td colspan="2"><strong><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₩" /></strong></td>
                    </tr>
                </tfoot>
            </table>
        </c:if>

        <!-- 장바구니 아이템이 없을 때 -->
        <c:if test="${empty cartItems}">
            <p>장바구니에 상품이 없습니다.</p>
        </c:if>

        <!-- 상품 목록으로 돌아가기 버튼 -->
        <a href="<c:url value='/product/list'/>" class="btn btn-primary mt-3">상품 목록으로 돌아가기</a>
    </div>

    <!-- Bootstrap JS and jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function() {
            // 수량 증가 버튼 클릭 시
            $('.increase-quantity').click(function() {
                const spCartId = $(this).data('spcartid');
                const quantitySpan = $(this).siblings('.quantity');
                let quantity = parseInt(quantitySpan.text()) + 1; // 수량 증가

                $.ajax({
                    url: '<c:url value="/cart/updateQuantity"/>',  // 수량 업데이트를 위한 URL
                    type: 'POST',
                    data: {
                        spCartId: spCartId,  // 장바구니 아이템 ID
                        quantity: quantity   // 변경된 수량
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            quantitySpan.text(quantity); // 화면에 수량 업데이트
                        } else {
                            alert('수량 변경에 실패했습니다.');
                        }
                    },
                    error: function() {
                        alert('서버 오류 발생');
                    }
                });
            });

            // 수량 감소 버튼 클릭 시
            $('.decrease-quantity').click(function() {
                const spCartId = $(this).data('spcartid');
                const quantitySpan = $(this).siblings('.quantity');
                let quantity = parseInt(quantitySpan.text()) - 1; // 수량 감소
                if (quantity < 1) quantity = 1; // 최소 수량 1로 설정

                $.ajax({
                    url: '<c:url value="/cart/updateQuantity"/>',  // 수량 업데이트를 위한 URL
                    type: 'POST',
                    data: {
                        spCartId: spCartId,  // 장바구니 아이템 ID
                        quantity: quantity   // 변경된 수량
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            quantitySpan.text(quantity); // 화면에 수량 업데이트
                        } else {
                            alert('수량 변경에 실패했습니다.');
                        }
                    },
                    error: function() {
                        alert('서버 오류 발생');
                    }
                });
            });

            // 삭제 버튼 클릭 시
            $('.delete-btn').click(function() {
                const spCartId = $(this).data('spcartid');
                if (confirm('정말 삭제하시겠습니까?')) {
                    // 삭제 URL로 이동하여 해당 아이템을 삭제
                    location.href = "<c:url value='/cart/remove?spCartId='/>" + spCartId;
                }
            });
        });
    </script>
</body>
</html>
