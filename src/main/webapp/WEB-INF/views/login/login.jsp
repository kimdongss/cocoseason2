<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>로그인</h3>
                    </div>
                    <div class="card-body">
                        <!-- 로그인 폼 -->
                        <form id="loginForm" action="<c:url value='/login' />" method="post">
                            <!-- 아이디 -->
                            <div class="mb-3">
                                <label for="memberIdInput" class="form-label">아이디</label>
                                <input type="text" class="form-control" id="memberIdInput" name="memberId" required>
                            </div>
                            <!-- 비밀번호 -->
                            <div class="mb-3">
                                <label for="passwordInput" class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="passwordInput" name="password" required>
                            </div>
                            <!-- 에러 메시지 -->
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                                </div>
                            </c:if>
                            <!-- 버튼 -->
                            <div class="d-flex justify-content-between">
                                <button id="loginButton" type="submit" class="btn btn-primary">로그인</button>
                                <button id="cancelButton" type="button" class="btn btn-secondary">취소</button>
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
        // 로그인 폼 제출 시 유효성 검사
        document.getElementById("loginForm").addEventListener("submit", function (event) {
            const memberId = document.getElementById("memberIdInput").value.trim();
            const password = document.getElementById("passwordInput").value.trim();

            if (memberId === "") {
                alert("아이디를 입력하세요.");
                event.preventDefault();
                return;
            }

            if (password === "") {
                alert("비밀번호를 입력하세요.");
                event.preventDefault();
                return;
            }
        });

        // 취소 버튼 클릭 시 이벤트 처리
        document.getElementById("cancelButton").addEventListener("click", function () {
            location.href = '<c:url value="/" />'; // 메인 페이지로 이동
        });
    </script>
</body>
</html>
