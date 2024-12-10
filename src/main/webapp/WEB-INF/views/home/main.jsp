<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<html>
<head>
   <title>Costco Home</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
   <style>
   		
   </style>
</head>
<body>
   <h2>코스트코 메인페이지</h2>
   <div>
   		<c:choose>
			<c:when test="${not empty loginUser.memberId}">
				<span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
				<!-- 관리자 권한이 있는 경우 "관리자" 버튼 추가 -->
				<c:if test="${sessionScope.loginUser.roleId == 'admin'}">
					<button id="adminButton" class="btn btn-warning btn-sm">관리자</button>
				</c:if>
				<button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
			</c:when>
			<c:otherwise>
                 <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                 <button id="insertMemberButton" class="btn btn-primary btn-sm">회원가입</button>
             </c:otherwise>
         </c:choose>
   </div>
   <c:choose>
   		<c:when test="${not empty loginUser.memberId } }">
   			
   		</c:when>
   </c:choose>
   <a href="<c:url value='/board/list' /> ">게시글 목록 페이징</a>
   
   <a href="<c:url value='/product/list' /> ">상품목록</a>
   
   <a href="<c:url value='/member/list' /> ">회원 목록</a>
   
   <script>
       const loginButton = document.getElementById('loginButton');
  	   const logoutButton = document.getElementById('logoutButton');
  	   
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
   
   
   </script>
</body>
</html>