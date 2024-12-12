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
	<style>
	 	body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
		/* 상단 섹션 (로고, 검색창, 버튼들) */
        .top-section {
            padding: 10px 20px;
            background-color: #f0f8ff;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .top-section .logo {
            width: 230px;
        }

        .top-section .search-container input {
            width: 400px;
        }

        .top-section .btn-container button {
            margin-left: 10px;
        }

        /* 파란색 네비게이션 바 */
        .navbar-custom {
            background-color: #0078b5;
            color: white;
            padding: 10px 0;
        }

        .navbar-custom a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
        }

        .navbar-custom a:hover {
            text-decoration: underline;
        }
        /* 푸터 스타일 */
		.footer {
		    background-color: #f8f9fa;
		    padding: 20px;
		    border-top: 2px solid #0078b5;
		    margin-top: 20px;
		}
		
		.footer h6 {
		    font-weight: bold;
		}
		
		.footer ul {
		    padding: 0;
		    list-style: none;
		}
		
		.footer ul li a {
		    text-decoration: none;
		    color: #000;
		}
		
		.footer ul li a:hover {
		    text-decoration: underline;
		}
		
		.footer small {
		    color: #6c757d;
		}
	</style>
</head>
<body>
<div class="container mt-5">
<!-- 상단 섹션 -->
    	<div class="top-section">
	        <!-- 로고 -->
	        <a href="<c:url value='/home/main' />">
			    <img src="<c:url value='/resources/image/costcologo.png' />" alt="Logo" class="logo">
			</a>

	        <!-- 검색창 -->
	        <div class="search-container">
	          <form id="searchForm" action="<c:url value='/board/list' />" method="get" class="d-flex">
	              <input type="text" class="form-control me-2" name="searchText" id="searchText" placeholder="검색어를 입력하세요" value="${pageMaker.cri.searchText}">
	              <button type="submit" class="btn btn-info me-2">검색</button>
	          </form>
	        </div>

	        <!-- 버튼 -->
	        <div class="btn-container">
	        <!-- 로그인 여부에 따라 다른 버튼을 표시 -->
	            <c:choose>
		            <c:when test="${not empty loginUser.memberId}">
		               <span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
		               <!-- 관리자 권한이 있는 경우 "관리자" 버튼 추가 -->
		               <c:if test="${sessionScope.loginUser.roleId == 'admin'}">
		                  <button id="adminButton" class="btn btn-warning btn-sm">관리자</button>
		               </c:if>
		               <c:if test="${sessionScope.loginUser.roleId != 'admin'}">
		                  <button id="memberButton" class="btn btn-warning btn-sm">마이페이지</button>
		               </c:if>
		               <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
		               <button id="cartButton" class="btn btn-info btn-sm">장바구니</button>
		            </c:when>
		            <c:otherwise>
		               <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
		               <button id="insertMemberButton" class="btn btn-primary btn-sm">회원가입</button>
		            </c:otherwise>
	            </c:choose>
	        </div>
	    </div>
	    <!-- 파란색 네비게이션 바 -->
    <div class="navbar-custom">
        <div class="container d-flex justify-content-center">
            <a href="#">그로서리</a>
            <a href="#">스페셜 할인</a>
            <a href="#">신상품</a>
            <a href="http://kimdongss.dothome.co.kr/project.tire_shop.html">타이어</a>
            <a href="#">Same-Day(당일배송)</a>
            <a href="/product/list">상품 보러가기</a>
            <a href="/board/list">Q &amp; A</a>
        </div>
    </div>
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
<footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <h6>코스트코 소개</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-dark">코스트코란?</a></li>
                        <li><a href="#" class="text-dark">커클랜드 시그니처</a></li>
                        <li><a href="#" class="text-dark">채용</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h6>코스트코 멤버십</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-dark">회원가입</a></li>
                        <li><a href="#" class="text-dark">회원권 갱신</a></li>
                        <li><a href="#" class="text-dark">제휴 신용카드</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h6>고객센터</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-dark">FAQ</a></li>
                        <li><a href="#" class="text-dark">문의</a></li>
                        <li><a href="#" class="text-dark">리콜</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
					<h6>매장 &amp; 서비스</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-dark">매장 안내</a></li>
                        <li><a href="#" class="text-dark">로드쇼 행사</a></li>
                        <li><a href="#" class="text-dark">타이어 서비스</a></li>
                    </ul>
                </div>
            </div>
            <div class="text-center mt-3">
                <small class="text-secondary">© 2024 Costco Wholesale Corporation. All rights reserved.</small>
            </div>
        </div>
    </footer>
</div>

    <!-- jQuery 라이브러리 불러오기 (AJAX 요청을 보낼 때 사용) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 부트스트랩의 JavaScript 파일 불러오기 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    
    const loginButton = document.getElementById('loginButton');
    const logoutButton = document.getElementById('logoutButton');
    const adminButton = document.getElementById('adminButton'); // 관리자
    const insertMemberButton = document.getElementById('insertMemberButton'); // 회원가입
    const cartButton = document.getElementById('cartButton');
    const memberButton = document.getElementById('memberButton');
    
    if (memberButton) {
        memberButton.addEventListener('click', function() {
             window.location.href = "<c:url value='/member/mypage' />";
         });
     }
    
    if (loginButton) {
        loginButton.addEventListener('click', function() {
            window.location.href = "<c:url value='/login' />";
        });
    }
    if (insertMemberButton) {
    	insertMemberButton.addEventListener('click', function() {
            window.location.href = "<c:url value='/member/insert' />";
        });
    }
 	// 관리자 버튼 이벤트 핸들러
    if (adminButton) {
    	adminButton.addEventListener('click', function() {
            window.location.href = "<c:url value='/admin' />";
        });
    }

    if (logoutButton) {
        logoutButton.addEventListener('click', function() {
            window.location.href = "<c:url value='/logout' />";
        });
    }
    
    function main(){
        window.location.href = "/home/main";
     }
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
