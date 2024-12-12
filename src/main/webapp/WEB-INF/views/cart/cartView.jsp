<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <!-- 부트스트랩 5 CSS 불러오기: UI를 깔끔하고 반응형으로 만들어줍니다. -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 메인 컨테이너 시작 (부트스트랩의 컨테이너 클래스 적용) -->
    <div class="container mt-5">
        <h1>장바구니</h1>

        <!-- 장바구니 항목이 있을 때 테이블을 표시 -->
        <c:if test="${not empty cartItems}">
            <!-- 장바구니 항목이 있을 때 표시할 테이블 -->
            <table class="table table-bordered">
                <!-- 테이블 헤더 (상품ID, 상품명, 가격, 수량, 소계, 삭제 항목) -->
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
                    <!-- 총합을 계산하기 위한 변수 설정 -->
                    <c:set var="totalPrice" value="0" />
                    
                    <!-- 장바구니 항목을 하나씩 반복하여 표시 -->
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <!-- 상품ID 표시 -->
                            <td>${item.productId}</td>
                            <!-- 상품명 표시 -->
                            <td>${item.productName}</td>
                            <!-- 가격을 통화 형식으로 표시 (₩ 표시) -->
                            <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₩" /></td>
                            <td>
                                <!-- 수량을 변경할 수 있는 버튼들 (감소, 증가) -->
                                <button class="btn btn-sm btn-secondary decrease-quantity" data-spcartid="${item.spCartId}" data-unitprice="${item.unitPrice}">-</button>
                                <!-- 현재 수량 표시 -->
                                <span class="quantity">${item.quantity}</span>
                                <button class="btn btn-sm btn-secondary increase-quantity" data-spcartid="${item.spCartId}" data-unitprice="${item.unitPrice}">+</button>
                            </td>
                            <!-- 소계 계산 후 통화 형식으로 표시 (단가 * 수량) -->
                            <td class="subtotal"><fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="₩" /></td>
                            <!-- 삭제 버튼 (이 버튼을 누르면 해당 항목 삭제) -->
                            <td>
                                <button class="btn btn-danger delete-btn" data-spcartid="${item.spCartId}">삭제</button>
                            </td>
                        </tr>
                        <!-- 총 합계를 계산하여 계속 더해 나감 -->
                        <c:set var="totalPrice" value="${totalPrice + (item.unitPrice * item.quantity)}" />
                    </c:forEach>
                </tbody>
                <!-- 테이블 푸터 (총 합계 표시) -->
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-end"><strong>총 합계:</strong></td>
                        <td colspan="2" class="total">
                            <!-- 총합을 통화 형식으로 표시 -->
                            <strong><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₩" /></strong>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </c:if>
        
        <!-- 장바구니 항목이 없을 경우 안내 문구 표시 -->
        <c:if test="${empty cartItems}">
            <p>장바구니에 상품이 없습니다.</p>
        </c:if>
        
        <!-- 주문하기 버튼 추가 -->
		<c:if test="${not empty cartItems}">
		    <form action="<c:url value='/order/place'/>" method="post">
		        <button type="submit" class="btn btn-success mt-3">주문하기</button>
		    </form>
		</c:if>
        <!-- 상품 목록으로 돌아가기 버튼 (다른 페이지로 이동할 수 있게 함) -->
        <a href="<c:url value='/product/list'/>" class="btn btn-primary mt-3">상품 목록으로 돌아가기</a>
    </div>

    <!-- jQuery 라이브러리 불러오기 (AJAX 요청을 보낼 때 사용) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 부트스트랩의 JavaScript 파일 불러오기 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // 수량을 변경하는 AJAX 함수
        	function updateQuantity(spCartId, quantity, button) {
        	    $.ajax({
        	        url: '<c:url value="/cart/updateQuantity"/>',  <!-- 서버에서 수량 업데이트를 처리할 URL -->
        	        type: 'POST',  <!-- POST 요청 -->
        	        data: { spCartId: spCartId, quantity: quantity },  <!-- 요청 데이터 (spCartId와 새로운 수량) -->
        	        success: function(response) {  <!-- 서버로부터 응답이 성공적으로 오면 -->
        	            if (response.status === 'success') {  <!-- 서버 응답이 성공적이면 -->
        	                const row = button.closest('tr');  <!-- 버튼이 위치한 행을 찾음 -->
        	                row.find('.quantity').text(quantity);  <!-- 해당 행에서 수량을 업데이트 -->
        	                const unitPrice = parseFloat(button.data('unitprice'));  <!-- 단가 가져오기 -->
        	                const subtotal = unitPrice * quantity;  <!-- 소계 계산 (단가 * 수량) -->
        	                row.find('.subtotal').text('₩' + subtotal.toLocaleString());  <!-- 소계를 통화 형식으로 표시 -->
        	                updateTotal();  <!-- 총합을 다시 계산하여 업데이트 -->
        	            } else {
        	                alert('수량 변경에 실패했습니다.');  <!-- 실패한 경우 사용자에게 알림 -->
        	            }
        	        },
        	        error: function() {  <!-- AJAX 요청에서 오류가 발생한 경우 -->
        	            alert('서버 오류 발생');  <!-- 오류 발생 시 사용자에게 알림 -->
        	        }
        	    });
        	}

            // 전체 총합을 계산하는 함수
        	function updateTotal() {
        	    let total = 0;  <!-- 총합을 저장할 변수 -->
        	    $('.subtotal').each(function() {  <!-- 모든 소계 항목을 순회하면서 -->
        	        total += parseFloat($(this).text().replace('₩', '').replace(',', ''));  <!-- 소계를 추출하여 총합에 더함 -->
        	    });
        	    $('.total').text('₩' + total.toLocaleString());  <!-- 총합을 통화 형식으로 표시 -->
        	}

            // 수량 증가, 감소 버튼 클릭 시 이벤트 처리
            $('.increase-quantity, .decrease-quantity').click(function() {
                const spCartId = $(this).data('spcartid');  <!-- 클릭한 버튼에 해당하는 spCartId 가져오기 -->
                let quantity = parseInt($(this).siblings('.quantity').text());  <!-- 현재 수량 가져오기 -->
                if ($(this).hasClass('increase-quantity')) {  <!-- 증가 버튼인 경우 -->
                    quantity++;  <!-- 수량 증가 -->
                } else {  <!-- 감소 버튼인 경우 -->
                    quantity = Math.max(1, quantity - 1);  <!-- 수량을 1 이상으로 제한하여 감소 -->
                }
                updateQuantity(spCartId, quantity, $(this));  <!-- 수량을 서버에 업데이트 요청 -->
            });

            // 삭제 버튼 클릭 시 해당 항목 삭제
            $('.delete-btn').click(function() {
                const spCartId = $(this).data('spcartid');  <!-- 클릭한 버튼에 해당하는 spCartId 가져오기 -->
                if (confirm('정말 삭제하시겠습니까?')) {  <!-- 삭제 확인 메시지 표시 -->
                    location.href = "<c:url value='/cart/remove?spCartId='/>" + spCartId;  <!-- 해당 항목 삭제를 위한 URL로 리다이렉트 -->
                }
            });
        });
    </script>
</body>
</html>
