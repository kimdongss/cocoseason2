<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        table tbody td, table thead th {
            text-align: center;
            vertical-align: middle;
        }
        /* 제목을 중앙 정렬 */
        h1 {
            text-align: center; /* 수평 중앙 정렬 */
            margin-bottom: 20px;
            flex: 1; /* Flexbox 자식 요소로 확장 */
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .search-container {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .search-container .form-control {
            width: 300px;
            margin-right: 10px;
        }
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
		.btn-botcontainer {
			text-align: right; 
			margin-top: 20px;
		}
        
    </style>
</head>
<body>
    <div class="container mt-5">

        <!-- 상단 섹션 -->
    <div class="top-section">
        <!-- 로고 -->
        <a href="<c:url value='/product/list' />">
		    <img src="<c:url value='/resources/image/costcologo.png' />" alt="Logo" class="logo">
		</a>

        <!-- 페이지 헤더 -->
        <header class="d-flex justify-content-between align-items-center mb-3">
            <!-- <h1>상품 목록</h1> -->
            <!-- 로그인/로그아웃 버튼 -->
            <div>
<%--                 <c:choose>
                    <c:when test="${not empty loginUser}">
                        <span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
                        <!-- 관리자 권한이 있는 경우 "관리자" 버튼 추가 -->
	                     <c:if test="${sessionScope.loginUser.roleId == 'admin'}">
	                         <button id="adminButton" class="btn btn-warning btn-sm">관리자</button>
	                     </c:if>
                        <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
						<!-- 장바구니로 가는 버튼 -->
						<c:choose>
						    <c:when test="${sessionScope.loginUser.roleId == 'admin' || sessionScope.loginUser.roleId == 'member'}">
						        <a href="<c:url value='/cart/view' />" class="btn btn-primary btn-sm">장바구니</a>
						    </c:when>
						    <c:otherwise>
						        <!-- 비회원 또는 권한 없는 사용자에 대한 메시지 -->
						        <button type='button' class='btn btn-primary btn-sm'
						                onclick='alert("정회원만 장바구니에 담을 수 있습니다. 유료회원 가입문의 DM주세요🙏");'>장바구니</button>
						    </c:otherwise>
						</c:choose>

                        
                    </c:when>
                    <c:otherwise>
                        <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                        <button id="insertMemberButton" class="btn btn-primary btn-sm">회원가입</button>
                    </c:otherwise>
                </c:choose> --%>
            </div>
        </header>


        <!-- 검색창 -->
        <div class="search-container">
            <form id="searchForm" action="<c:url value='/product/list' />" method="get" class="d-flex">
                <input type="text" class="form-control me-2" name="searchText" id="searchText" placeholder="상품 검색" value="${pageMaker.cri.searchText}">
                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>

        <!-- 버튼 -->
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
            <a href="/product/list">상품보러가기</a>
            <a href="/board/list">Q &amp; A</a>
        </div>
    </div>

    <!-- 상품 테이블 -->
    <div class="container mt-4">
        <table class="table table-bordered table-striped table-hover">
            <thead class="table-light">
                <tr>
                    <th>순번</th>
                    <th>상품명</th>
                    <th>단가</th>
                    <th>입고일</th>
                </tr>
            </thead>
            <tbody>
             	<!-- productList 변수에 저장된 상품 목록을 반복하여 출력 -->
                <c:forEach var="product" items="${productList}" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <!-- 상품명 (클릭하면 상세 페이지로 이동) -->
                        <td><a href="<c:url value='/product/detail/${product.productId}'/>">${product.name}</a></td>
                        <td>${product.unitPrice}</td>
                        <td>
                            <fmt:formatDate value="${product.regDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- 하단 버튼들 (전체보기, 상품등록) -->
	    <div class="btn-botcontainer">
	        <!-- 전체보기 버튼 -->
	        <button class="btn btn-primary btn-sm" onclick="location.href='/product/list'">전체보기</button>
	        
	        <!-- 상품 등록 버튼 -->
	        <button class="btn btn-success btn-sm" onclick="location.href='/product/create'">상품 등록</button>
	    </div>
        
        <!-- 페이징 -->
        <div class="pagination-container">
            <ul class="pagination">
                <!-- 이전 페이지 버튼 -->
                <c:if test="${pageMaker.prev}">
                    <li class="page-item">
                        <a class="page-link" href="?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&searchText=${pageMaker.cri.searchText}">
                            Previous
                        </a>
                    </li>
                </c:if>

                <!-- 페이지 번호 -->
                <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="pageNum">
                    <li class="page-item ${pageMaker.cri.pageNum == pageNum ? 'active' : ''}">
                        <a class="page-link" href="?pageNum=${pageNum}&amount=${pageMaker.cri.amount}&searchText=${pageMaker.cri.searchText}">
                            ${pageNum}
                        </a>
                    </li>
                </c:forEach>

                <!-- 다음 페이지 버튼 -->
                <c:if test="${pageMaker.next}">
                    <li class="page-item">
                        <a class="page-link" href="?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&searchText=${pageMaker.cri.searchText}">
                            Next
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
        
    </div>
    
    
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
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 로그인/로그아웃 버튼 이벤트 처리
        const loginButton = document.getElementById('loginButton');
        const logoutButton = document.getElementById('logoutButton');
        const adminButton = document.getElementById('adminButton'); // 관리자
        const insertMemberButton = document.getElementById('insertMemberButton'); // 회원가입

        if (insertMemberButton) {
        	insertMemberButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/member/insert' />";
            });
        }

        if (loginButton) {
            loginButton.addEventListener('click', function () {
                window.location.href = "<c:url value='/login' />";
            });
        }
        
     	// 관리자 버튼 이벤트 핸들러
        if (adminButton) {
        	adminButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/admin' />";
            });
        }

        if (logoutButton) {
            logoutButton.addEventListener('click', function () {
                window.location.href = "<c:url value='/logout' />";
            });
        }
    </script>
</body>
</html>