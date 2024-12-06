<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원 목록</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* 테이블의 모든 컬럼 중앙 정렬 */
    table tbody td, table thead th {
        text-align: center;
        vertical-align: middle; /* 수직 정렬 */
    }
    /* 각 컬럼 너비를 비슷하게 조정 */
    table th, table td {
        width: 25%; /* 각 컬럼이 동일한 비율로 차지 */
    }    
	/* 제목을 중앙 정렬 */
       h1 {
        text-align: center; /* 수평 중앙 정렬 */
        margin-bottom: 20px;
        flex: 1; /* Flexbox 자식 요소로 확장 */
    }
</style>

</head>
<body>
    <div class="container mt-5">
        <!-- 페이지 헤더 -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>회원 목록</h1>
            <!-- 로그인/로그아웃 버튼 -->
            <div>
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <!-- 로그인 상태 -->
                        <span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
                        <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
                    </c:when>
                    <c:otherwise>
                        <!-- 로그아웃 상태 -->
                        <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 회원 목록 테이블 -->
        <table class="table table-bordered table-striped table-hover">
            <thead class="table-light">
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>가입일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="member" items="${memberList}">
                    <tr>
                        <td>${member.memberId}</td>
						<td>
						    <a href="<c:url value='/member/view?memberId=${member.memberId}' />" class="text-decoration-none text-primary">
						        ${member.name}
						    </a>
						</td>

                        <td>${member.email}</td>
                        <td><fmt:formatDate value="${member.regDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 회원가입 버튼 -->
        <div class="text-end">
            <c:if test="${empty loginUser}">
                <button id="addMemberButton" class="btn btn-success">회원가입</button>
            </c:if>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 로그인 버튼 이벤트
        const loginButton = document.getElementById('loginButton');
        if (loginButton) {
            loginButton.addEventListener('click', function() {
                window.location.href = '<c:url value="/login" />';
            });
        }

        // 로그아웃 버튼 이벤트
        const logoutButton = document.getElementById('logoutButton');
        if (logoutButton) {
            logoutButton.addEventListener('click', function() {
                window.location.href = '<c:url value="/logout" />';
            });
        }

        // 회원가입 버튼 이벤트
        const addMemberButton = document.getElementById('addMemberButton');
        if (addMemberButton) {
            addMemberButton.addEventListener('click', function() {
                window.location.href = '<c:url value="/member/insert" />';
            });
        }
    </script>
</body>
</html>
