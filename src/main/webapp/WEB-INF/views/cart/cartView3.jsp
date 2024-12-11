<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>장바구니</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

	<!-- jQuery 라이브러리 import -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
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
	                error: function (xhr, textStatus, errorThrown) {
	                    // HTTP 상태 코드
	                    const statusCode = xhr.status; // xht.status는 HTTP 상태 코드를 반환함

	                    // 서버에서 반환된 응답 메시지 있을 경우 그 메시지를 취하고 없을 경우 || 뒤의 메시지를 취함
	                    const responseMessage = xhr.responseText || "서버에서 반환된 메시지가 없습니다.";

	                    // 에러 메시지 기본값 설정
	                    let errorMessage = "알 수 없는 오류가 발생했습니다.";

	                    // 상태 코드에 따른 메시지 처리
	                    if (statusCode === 403) {
	                        errorMessage = "권한이 없습니다.";
	                    } else if (statusCode === 404) {
	                        errorMessage = "요청한 리소스를 찾을 수 없습니다.";
	                    } else if (statusCode === 500) {
	                        errorMessage = "서버 내부 오류가 발생했습니다. 잠시 후 다시 시도하세요.";
	                    }

	                    // 에러 메시지 화면에 출력
	                    $("#idCheckMessage")
	                        .text(errorMessage)
	                        .css("color", "red")
	                        .show();

	                    // 콘솔에 디버깅 정보 출력
	                    console.error("Error Status:", statusCode);
	                    console.error("Error Text:", textStatus);
	                    console.error("Error Thrown:", errorThrown);
	                    console.error("Response Message:", responseMessage);
	                } // end error 콜백
	            }); // end ajax
	        }); // end  onclick

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
	        
	     	// 유효성 검사 함수 분리
	        function validateFormInputs(event) {
	            const memberId = $("#memberIdInput").val().trim();
	            const password = $("#passwordInput").val().trim();
	            const passwordConfirm = $("#passwordConfirmInput").val().trim();
	            const name = $("#nameInput").val().trim();
	            const email = $("#emailInput").val().trim();
	            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

	            if (!isIdChecked) {
	                alert("아이디 중복 확인을 진행해주세요.");
	                $("#memberIdInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            if (memberId === "") {
	                alert("아이디를 입력하세요.");
	                $("#memberIdInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            if (password === "") {
	                alert("비밀번호를 입력하세요.");
	                $("#passwordInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            if (password !== passwordConfirm) {
	                $("#passwordError").text("비밀번호가 일치하지 않습니다.").css("color", "red").show();
	                $("#passwordConfirmInput").focus();
	                event.preventDefault();
	                return false;
	            } else {
	                $("#passwordError").hide();
	            }

	            if (name === "") {
	                alert("이름을 입력하세요.");
	                $("#nameInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            if (email === "") {
	                alert("이메일을 입력하세요.");
	                $("#emailInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            if (!emailRegex.test(email)) {
	                alert("올바른 이메일 형식을 입력하세요.");
	                $("#emailInput").focus();
	                event.preventDefault();
	                return false;
	            }

	            return true;
	        }	        
	        
	    
		 	/* // 폼 제출 시 이벤트 처리 (주문처리)
			$('#insertForm').on('submit', function(event) {
		          
				// 폼 검증
	            if (!validateFormInputs(event)) {
	                return;
	            }
				
				alert('모든 데이터의 검증이 완료되어 서버를 호출합니다.');
	
			});
	
			// 취소 버튼 클릭 시 이벤트 처리
			$('#cancelButton').on("click",	function() {
						location.href = '<c:url value="/member/list" /> '; // 회원 목록 페이지로 이동
			});
			
	    });	// end ready() */
	</script>

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
        <!-- 주문하기 버튼 추가 -->
        <%-- <c:if test="${loginUser != null}"> <!-- 로그인 상태 확인 -->
            <c:if test="${sessionScope.loginUser.roleId == 'member' || sessionScope.loginUser.roleId == 'admin'}"> <!-- 역할 확인 -->
                <form action="<c:url value='/order/place' />" method="post">
                    <input type="hidden" name="orderId" value="${order_info.orderId}"/>
                    <input type="hidden" name="productId" value="${product.productId}"/>
                    <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"/> <!-- 로그인한 회원 ID -->
                    <input type="hidden" name="productName" value="${product.name}"/>
                    <input type="hidden" name="unitPrice" value="${product.unitPrice}"/>
                    <input type="hidden" name="quantity" value="${shopping_cart.quantity}"/> <!-- 장바구니에 담겨있는 수량 -->
                    <input type="hidden" name="address" value="${sessionScope.loginUser.address}"/>
                    <input type="hidden" name="phone" value="${sessionScope.loginUser.phone}"/>
                    
                    <!-- 왜 안돠?? 
                    1. 일단sessionScope.loginUser.address 이 방법이 틀린것 같다 로그인 유저의아이디를 가지고 멤버테이블에서 비교해와서
                    넣어주는 방법을 생각해 봐야할 듯  
                    2. 또 카트 에서 소계와 합계를 jsp 에서 계산하지말고 컨트롤러에 ajax로 수량 보낼때 같이 보내서 거기서 계산해와서 수량 받을때 받아와서 표시하는방법으로 구현
                    -->
                    <!-- 주문하기 버튼 -->
                    <button type="submit" class="btn btn-primary mt-4">주문하기</button> 
                </form>
            </c:if>
        </c:if> --%>
        <!-- 로그인 상태 및 역할 확인 -->
		<c:if test="${loginUser != null}">
		    <c:if test="${sessionScope.loginUser.roleId == 'member' || sessionScope.loginUser.roleId == 'admin'}">
		        <!-- 주문 폼 시작 -->
		        <form action="<c:url value='/order/place' />" method="post">
		            
		            <!-- 장바구니 아이템 정보 전달 -->
		            <c:forEach var="item" items="${cartItems}">
		                <input type="hidden" name="productId" value="${item.productId}" />
		                <input type="hidden" name="quantity" value="${item.quantity}" />
		                <input type="hidden" name="unitPrice" value="${item.unitPrice}" />
		                <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}" />
		                <input type="hidden" name="productName" value="${item.productName}" />
		                <input type="hidden" name="address" value="${sessionScope.loginUser.address}" />
		                <input type="hidden" name="phone" value="${sessionScope.loginUser.phone}" />
		            </c:forEach>
		
		            <!-- 주문하기 버튼 -->
		            <button type="submit" class="btn btn-primary mt-4">주문하기</button> 
		        </form>
		    </c:if>
		</c:if>
        

        <!-- 상품 목록으로 돌아가기 버튼 -->
        <a href="<c:url value='/product/list'/>" class="btn btn-primary mt-3">상품 목록으로 돌아가기</a>
        
    </div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		
	</script>
</body>
</html>
