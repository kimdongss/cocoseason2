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
        width: 20%; /* 각 컬럼이 동일한 비율로 차지 */
    }    
	/* 제목을 중앙 정렬 */
       h1 {
        text-align: center; /* 수평 중앙 정렬 */
        margin-bottom: 20px;
        flex: 1; /* Flexbox 자식 요소로 확장 */
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
        <!-- 메인 컨테이너 시작 (부트스트랩의 컨테이너 클래스 적용) -->
        <h1>[관리자]전체 회원 목록</h1>
        <!-- 페이지 헤더 -->
        <div class="top-section">
        	<!-- 로고 -->
	        <a href="<c:url value='/home/main' />">
			    <img src="<c:url value='/resources/image/costcologo.png' />" alt="Logo" class="logo">
			</a>
			
			<!-- 검색창 -->
	        <div class="search-container">
	            <form id="searchForm" action="<c:url value='/product/list' />" method="get" class="d-flex">
	                <input type="text" class="form-control me-2" name="searchText" id="searchText" value="${pageMaker.cri.searchText}">
	                <button type="submit" class="btn btn-primary">검색</button>
	            </form>
	        </div>
        
            <!-- 로그인/로그아웃 버튼 -->
            <div class="btn-container">
	        <!-- 로그인 여부에 따라 다른 버튼을 표시 -->
	            <c:choose>
	                <c:when test="${not empty loginUser}">
	
	                    <span class="me-2">${sessionScope.loginUser.memberId}님</span>
	
	                    <c:if test="${sessionScope.loginUser.roleId == 'admin'}">
	                        <button id="adminButton" class="btn btn-warning btn-sm">관리자</button>
	                    </c:if>
	                    <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
	                    <a href="<c:url value='/cart/view' />" class="btn btn-primary btn-sm">장바구니</a>
	                </c:when>
	                       
	                <c:otherwise>
	                    <button id="loginButton" class="btn btn-light btn-sm">로그인</button>
	                    <button id="insertMemberButton" class="btn btn-light btn-sm">회원가입</button>
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

        <!-- 회원 목록 테이블 -->
        <table class="table table-bordered table-striped table-hover">
            <thead class="table-light">
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>회원등급</th>
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
						<td>${member.roleId}</td>
                        <td>${member.email}</td>
                        <td><fmt:formatDate value="${member.regDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- 푸터 -->
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
        const adminButton = document.getElementById('adminButton'); // 관리자
        if (adminButton) {
        	adminButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/admin' />";
            });
        }
    </script>
</body>
</html>
