<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 로그인 여부 체크 --%>
<% if (session.getAttribute("loginUser") != null) { %>
    <script>
        alert('로그아웃 후 회원가입 가능합니다.');
        location.href = '<c:url value="/home/main" />';
    </script>
<% return; } %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원 가입</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
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

	<!-- jQuery 라이브러리 import -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
	<script>
	
	
	    $(document).ready(function () {
	    	
	    	let isIdChecked = false; // 아이디 중복 확인 여부를 추적
	    	
	    	// 아이디 중복 체크
	        $("#btnCheckIdDup").on("click", function () {
	            const memberId = $("#memberIdInput").val().trim();
	            if (!memberId) {
	                $("#idCheckMessage").text("아이디를 입력하세요.").css("color", "red").show();
	                $("#memberIdInput").focus();
	                return;
	            }
				// ajax 비동기 통신의 아이디 중복 체크
	            $.ajax({
	                url: '<c:url value="/member/checkId" />', // 서버 엔드포인트(컨트롤러의 메소드 메소드를 직접 호출하나? no @RequestMapp- @get)
	                type: "GET", // get 요청
	                data: { memberId: memberId }, // 서버로 전송할 데이터( 저 주소뒤에 쿼리문으로 붙어서 전송됨)
	                dataType: "json",	// 서버로 부터 받을 데이터의 타입
	                success: function (response) { // response에는 서버에서 body에 담아 보낸 데이터가 들어있음 즉, responseVo(responseVo- 바디에 들어가있는) 객체가 여기로 들어옴 
	                    // 서버로부터 응답 받은 success 값 확인
	                    console.log(response.success);	// true or false (response.성공값과 메세지 둘 다 꺼낼 수 있음.)
	                    if (response.success) {	// 아이디 중복 true 주석 틀린걱 같음
	                    	alert('이미 사용중인 아이디입니다.')
	                        // success가 true인 경우: 사용 가능한 아이디?? 주석 틀린거 같음
	                        $("#idCheckMessage").text(response.message).css("color", "red").show(); // 여기서 show()는 display: none;으로 설정되어 있던 요소를 보이게 하기 위함
	                        isIdChecked = false; // 아이디가 중복이므로 아이디 체크 안한 것과 같음
	                        console.log('isIdCheckded : ', isIdChecked)
	                    } else {	// 아이디 중복 아님
	                    	alert('사용 가능한 아이디입니다.')
	                        // success가 false인 경우: 이미 사용 중인 아이디
	                        $("#idCheckMessage").text(response.message).css("color", "green").show();
	                        isIdChecked = true; // 중복 확인 성공로 간주
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
	        }); // end btnCheckIdDup onclick

	     // 유효성 검사 함수
	        function validateFormInputs(event) {
	            const memberId = $("#memberIdInput").val().trim();
	            const password = $("#passwordInput").val().trim();
	            const passwordConfirm = $("#passwordConfirmInput").val().trim();
	            const name = $("#nameInput").val().trim();
	            const email = $("#emailInput").val().trim();
	            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	            const address = $("#addressInput").val().trim();
	            const phone = $("#phoneInput").val().trim();
	            const phoneRegex = /^010-\d{4}-\d{4}$/; // 010으로 시작하고 하이픈이 정확한 위치에 있는지 검사

	            

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
	            
	            if (address === "") {
	                alert("주소를 입력하세요.");
	                $("#addressInput").focus();
	                event.preventDefault();
	                return false;
	            }
	            
	            if (phone === "") {
	                alert("전화번호를 입력하세요.");
	                $("#phoneInput").focus();
	                event.preventDefault();
	                return false;
	            }
	            
	            if (!phoneRegex.test(phone)) {
	                alert("올바른 전화번호 형식을 입력하세요. (예: 010-1234-5678)");
	                $("#phoneInput").focus();
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
	        
	    
		 	// 폼 제출 시 이벤트 처리
			$('#insertForm').on('submit', function(event) {
				
				// 1. 아이디 중복 확인 여부 체크 유효성검사에서 검사이미 하고 있어서 중복되어 뺌
/* 	            if (!isIdChecked) {
	                alert("아이디 중복 확인을 진행해주세요.");
	                $("#memberIdInput").focus();
	                event.preventDefault();
	                return;
	            }
		           */
		           
				// 2. 폼 검증
	            if (!validateFormInputs(event)) {
	                return;
	            }
				
				alert('준회원으로 회원가입이 완료되었습니다. 유료회원 가입문의는 DM주세요🙏.');
	
			});
	
			// 취소 버튼 클릭 시 이벤트 처리
			$('#cancelButton').on("click",	function() {
						location.href = '<c:url value="/board/list" /> '; // 회원 목록 페이지로 이동
			});
			
	    });	// end ready()
	    
	</script>

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
	          <form id="searchForm" action="<c:url value='/product/list' />" method="get" class="d-flex">
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
		<div class="row justify-content-center">
			<div class="col-md-8">
				<div class="card">
					<div class="card-header text-center ">
						<h3>회원 가입</h3>
					</div>
					<div class="card-body">
						<form id="insertForm" action="<c:url value='/member/insert' />"
							method="post">
							<!-- 아이디 -->
							<div class="mb-3">
								<label for="memberIdInput" class="form-label">아이디</label>
								<div class="input-group">
									<input type="text" class="form-control" id="memberIdInput"
										name="memberId" value="${member.memberId}" required>
									<button type="button" id="btnCheckIdDup"
										class="btn btn-outline-primary">중복확인</button>
								</div>
								<span id="idCheckMessage" style="display: none;"></span>
							</div>

							<!-- 비밀번호 -->
							<div class="mb-3">
								<label for="passwordInput" class="form-label">비밀번호</label> <input
									type="password" class="form-control" id="passwordInput"
									name="password" value="${member.password}" required>
							</div>
							<!-- 비밀번호 확인 -->
							<div class="mb-3">
								<label for="passwordConfirmInput" class="form-label">비밀번호
									확인</label> <input type="password" class="form-control"
									id="passwordConfirmInput" name="passwordConfirm" required>
								<span id="passwordError" class="text-danger"
									style="display: none;">비밀번호가 일치하지 않습니다.</span>
							</div>

							<!-- 이름 -->
							<div class="mb-3">
								<label for="nameInput" class="form-label">이름</label> <input
									type="text" class="form-control" id="nameInput" name="name"
									value="${member.name}" required>
							</div>
							
							<!-- 이메일 -->
							<div class="mb-3">
								<label for="emailInput" class="form-label">이메일</label> <input
									type="email" class="form-control" id="emailInput" name="email"
									value="${member.email}" required>
							</div>
							<!-- 전화번호 -->
							<div class="mb-3">
							    <label for="phoneInput" class="form-label">전화번호</label>
							    <input type="tel" class="form-control" id="phoneInput" name="phone" value="${member.phone}" required>
							</div>
							
							<!-- 주소 -->
							<div class="mb-3">
							    <label for="addressInput" class="form-label">주소</label>
							    <input type="text" class="form-control" id="addressInput" name="address" value="${member.address}" required>
							</div>
							<!-- 오류 메시지 -->
							<c:if test="${not empty errorMessage}">
								<div class="alert alert-danger" role="alert">
									${errorMessage}</div>
							</c:if>
							<!-- 버튼 -->
							<div class="d-flex justify-content-between">
								<button id="submitButton" type="submit" class="btn btn-primary">등록</button>
								<button id="cancelButton" type="button"
									class="btn btn-secondary">목록으로</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
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
	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		
	</script>
</body>
</html>
