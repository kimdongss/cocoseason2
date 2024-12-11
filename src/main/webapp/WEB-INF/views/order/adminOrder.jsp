<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전체 주문 목록</title>
    <!-- Bootstrap CSS 불러오기: UI를 깔끔하고 반응형으로 만들어줍니다. -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 메인 컨테이너 시작 (부트스트랩의 컨테이너 클래스 적용) -->
    <div class="container mt-5">
        <h1>전체 주문 목록</h1>

        <!-- 주문 리스트가 있을 경우 테이블을 표시 -->
        <c:if test="${not empty orderList}">
            <!-- 주문 항목을 표시할 테이블 -->
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
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 각 주문 항목을 반복하여 표시 -->
                    <c:forEach var="order" items="${orderList}">
                        <tr>
                            <!-- 주문 ID 표시 -->
                            <td>${order.orderId}</td>
                            <!-- 상품 ID 표시 -->
                            <td>${order.productId}</td>
                            <!-- 회원 ID 표시 -->
                            <td>${order.memberId}</td>
                            <!-- 상품명 표시 -->
                            <td>${order.productName}</td>
                            <!-- 단가 표시 (통화 형식으로 포맷팅) -->
                            <td><fmt:formatNumber value="${order.unitPrice}" type="currency" currencySymbol="₩" /></td>
                            <td>
                                <!-- 수량 조정 버튼 추가 -->
                                <button class="btn btn-sm btn-secondary decrease-quantity" data-orderid="${order.orderId}" data-unitprice="${order.unitPrice}">-</button>
                                <span class="quantity">${order.quantity}</span>
                                <button class="btn btn-sm btn-secondary increase-quantity" data-orderid="${order.orderId}" data-unitprice="${order.unitPrice}">+</button>
                            </td>
                            <!-- 총 가격 (단가 * 수량) 표시 (통화 형식으로 포맷팅) -->
                            <td class="subtotal"><fmt:formatNumber value="${order.unitPrice * order.quantity}" type="currency" currencySymbol="₩" /></td>
                            <!-- 배송 주소 표시 -->
                            <td>${order.address}</td>
                            <!-- 전화번호 표시 -->
                            <td>${order.phone}</td>
                            <!-- 삭제 버튼 (이 버튼을 누르면 해당 주문 삭제) -->
                            <td>
                                <button class="btn btn-danger delete-btn" data-orderid="${order.orderId}">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- 삭제 확인 메시지와 함께 AJAX 요청 처리 -->
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                $(document).ready(function() {
                    // 삭제 버튼 클릭 시 이벤트 처리
                    $('.delete-btn').click(function() {
                        const orderId = $(this).data('orderid'); // 클릭한 버튼의 주문 ID 가져오기
                        if (confirm('정말 삭제하시겠습니까?')) { // 삭제 확인 메시지
                            $.ajax({
                                url: '<c:url value="/order/delete"/>', // 서버의 삭제 요청 URL
                                type: 'POST',
                                data: { orderId: orderId }, // 요청 데이터 (주문 ID)
                                success: function(response) {
                                    if (response.status === 'success') {
                                        alert('주문이 삭제되었습니다.'); // 성공 메시지
                                        location.reload(); // 페이지 새로고침하여 업데이트된 목록 표시
                                    } else {
                                        alert('주문 삭제에 실패했습니다.'); // 실패 메시지
                                    }
                                },
                                error: function() {
                                    alert('서버 오류 발생'); // 오류 발생 시 메시지
                                }
                            });
                        }
                    });

                    // 수량 증가 버튼 클릭 시 이벤트 처리
                    $('.increase-quantity').click(function() {
                        const orderId = $(this).data('orderid');
                        const quantitySpan = $(this).siblings('.quantity');
                        let quantity = parseInt(quantitySpan.text()) + 1; // 수량 증가

                        $.ajax({
                            url: '<c:url value="/order/updateQuantity"/>', // 서버의 수량 업데이트 요청 URL
                            type: 'POST',
                            data: { orderId: orderId, quantity: quantity }, // 요청 데이터 (주문 ID 및 새로운 수량)
                            success: function(response) {
                                if (response.status === 'success') {
                                    quantitySpan.text(quantity); // 웹에서 수량 업데이트
                                    updateTotal(orderId, quantity); // 총 가격 업데이트
                                } else {
                                    alert('수량 변경에 실패했습니다.');
                                }
                            },
                            error: function() {
                                alert('서버 오류 발생');
                            }
                        });
                    });

                    // 수량 감소 버튼 클릭 시 이벤트 처리
                    $('.decrease-quantity').click(function() {
                        const orderId = $(this).data('orderid');
                        const quantitySpan = $(this).siblings('.quantity');
                        let quantity = Math.max(1, parseInt(quantitySpan.text()) - 1); // 최소 수량 1로 설정

                        $.ajax({
                            url: '<c:url value="/order/updateQuantity"/>', // 서버의 수량 업데이트 요청 URL
                            type: 'POST',
                            data: { orderId: orderId, quantity: quantity }, // 요청 데이터 (주문 ID 및 새로운 수량)
                            success: function(response) {
                                if (response.status === 'success') {
                                    quantitySpan.text(quantity); // 웹에서 수량 업데이트
                                    updateTotal(orderId, quantity); // 총 가격 업데이트
                                } else {
                                    alert('수량 변경에 실패했습니다.');
                                }
                            },
                            error: function() {
                                alert('서버 오류 발생');
                            }
                        });
                    });

                    function updateTotal(orderId, quantity) {
                        const row = $(`button[data-orderid="${orderId}"]`).closest('tr');
                        const unitPrice = parseFloat(row.find('.increase-quantity').data('unitprice'));
                        const subtotal = unitPrice * quantity;
                        row.find('.subtotal').text('₩' + subtotal.toLocaleString()); // 소계 업데이트
                    }
                });
            </script>

        </c:if>

        <!-- 주문 리스트가 비어있을 경우 안내 문구 표시 -->
        <c:if test="${empty orderList}">
            <p>주문이 없습니다.</p>
        </c:if>

        <!-- 장바구니 페이지로 돌아가는 버튼 (다른 페이지로 이동할 수 있게 함) -->
        <a href="<c:url value='/cart/view'/>" class="btn btn-primary mt-3">장바구니로 돌아가기</a>
    </div>

</body>
</html>

