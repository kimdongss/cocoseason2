<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
				
				alert('모든 데이터의 검증이 완료되어 서버를 호출합니다.');
	
			});
	
			// 취소 버튼 클릭 시 이벤트 처리
			$('#cancelButton').on("click",	function() {
						location.href = '<c:url value="/member/list" /> '; // 회원 목록 페이지로 이동
			});
			
	    });	// end ready()
	</script>

</head>
<body>
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

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		
	</script>
</body>
</html>
