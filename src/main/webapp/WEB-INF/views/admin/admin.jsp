<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title> 
    <!-- Bootstrap CSS -->
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
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>관리자 페이지</h3>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-center flex-column">
                            <a href="<c:url value='member/list' />" class="btn btn-primary mb-3">회원목록</a>
                            <a href="<c:url value='/order/admin' />" class="btn btn-primary">주문목록</a>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>