<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 수정</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>회원 수정</h3>
                    </div>
                    <div class="card-body">
                     <!-- 로그인 체크: 로그인된 사용자가 아니면 로그인 페이지로 리다이렉트 -->
                        <c:if test="${sessionScope.loginUser == null}">
                            <script>
                                alert("로그인 후에 접근할 수 있습니다.");
                                location.href = "<c:url value='/login' />";
                            </script>
                        </c:if>

                        <!-- 권한 체크: admin인 경우, 'member/list'로 리다이렉트 -->
                        <c:if test="${sessionScope.loginUser != null and sessionScope.loginUser.roleId == 'admin'}">
                            <script>
                                alert("관리자는 마이페이지에 접근할 수 없습니다.");
                                location.href = "<c:url value='/member/list' />"; // admin일 경우 'member/list'로 리다이렉트
                            </script>
                        </c:if>
                        <form id="updateForm" action="<c:url value='/member/myInfoUpdate' />" method="post">
                            <!-- 아이디 -->
                            <input type="hidden" name="memberId" value="${member.memberId}">
                            <div class="mb-3">
                                <label class="form-label">아이디</label>
                                <p class="form-control-plaintext"><strong>${member.memberId}</strong></p>
                            </div>
                            <!-- 비밀번호 -->
                            <div class="mb-3">
                                <label for="passwordInput" class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="passwordInput" name="password" 
                                       value="${member.password}" required>
                            </div>
                            <!-- 이름 -->
                            <div class="mb-3">
                                <label for="nameInput" class="form-label">이름</label>
                                <input type="text" class="form-control" id="nameInput" name="name" 
                                       value="${member.name}" required>
                            </div>
                            <!-- 이메일 -->
                            <div class="mb-3">
                                <label for="emailInput" class="form-label">이메일</label>
                                <input type="email" class="form-control" id="emailInput" name="email" 
                                       value="${member.email}" required>
                            </div>
							<!-- 등급 -->
                            <!-- 회원등급 -->
                        <div class="mb-3">
                            <label for="roleIdInput" class="form-label">회원등급 : 정회원(member), 준회원(guest)</label>
                            <input type="text" class="form-control" id="roleIdInput" name="roleId" size="1" value="${member.roleId}" readonly>
                        </div>
                            <!-- 전화번호 -->
							<div class="mb-3">
							    <label for="phoneInput" class="form-label">전화번호</label>
							    <input type="tel" class="form-control" id="phoneInput" name="phone" 
							    	   value="${member.phone}" required>
							</div>
							<!-- 주소 -->
							<div class="mb-3">
							    <label for="addressInput" class="form-label">주소</label>
							    <input type="text" class="form-control" id="addressInput" name="address" 
							    	   value="${member.address}" required>
							</div>
                            
                           	<!-- 오류 메시지 -->
							<c:if test="${not empty errorMessage}">
								<div class="alert alert-danger" role="alert">
									${errorMessage}</div>
							</c:if>

                            <!-- 버튼 -->
                            <div class="d-flex justify-content-between">
                                <button id="submitButton" type="submit" class="btn btn-primary">수정</button>
                                <button id="cancelButton" type="button" class="btn btn-secondary">뒤로가기</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 폼 제출 시 이벤트 처리
        document.getElementById("updateForm").addEventListener("submit", function(event) {
            // 입력 값 가져오기
            const password = document.getElementById("passwordInput").value.trim();
            const name = document.getElementById("nameInput").value.trim();
            const email = document.getElementById("emailInput").value.trim();

            // 유효성 검사
            if (password === "") {
                alert("비밀번호를 입력하세요.");
                event.preventDefault();
                return;
            }

            if (name === "") {
                alert("이름을 입력하세요.");
                event.preventDefault();
                return;
            }

            if (email === "") {
                alert("이메일을 입력하세요.");
                event.preventDefault();
                return;
            }

            // 이메일 형식 검사
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert("올바른 이메일 형식을 입력하세요.");
                event.preventDefault();
                return;
            }
        });

        // 취소 버튼 클릭 시 이벤트 처리
        document.getElementById("cancelButton").addEventListener("click", function() {
            location.href = '<c:url value="/member/mypage" />'; // 마이페이지 페이지로 이동
        });
    </script>
</body>
</html>
