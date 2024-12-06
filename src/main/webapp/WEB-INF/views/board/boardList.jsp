<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* 테이블의 모든 컬럼 중앙 정렬 */
        table tbody td, table thead th {
            text-align: center;
            vertical-align: middle; /* 수직 정렬 */
        }
        /* 제목을 중앙 정렬 */
        h1 {
            text-align: center; /* 수평 중앙 정렬 */
            margin-bottom: 20px;
            flex: 1; /* Flexbox 자식 요소로 확장 */
        }
        /* 페이징 중앙 정렬 */
        .pagination-container {
            display: flex;
            justify-content: center; /* 중앙 정렬 */
            margin-top: 20px;
        }
        /* 검색 입력란과 버튼 정렬 */
        .search-container {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .search-container .form-control {
            width: 300px;
            margin-right: 10px;
        }
        .search-container .btn {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <!-- 페이지 헤더 -->
        <header class="d-flex justify-content-between align-items-center mb-3">
            <h1>게시물 목록</h1>
            <!-- 로그인/로그아웃 버튼 -->
            <div>
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
                        <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
                    </c:when>
                    <c:otherwise>
                        <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <!-- 검색 입력란 및 버튼 -->
        <div class="search-container">
          <form id="searchForm" action="<c:url value='/board/list' />" method="get" class="d-flex">
              <input type="text" class="form-control me-2" name="searchText" id="searchText" placeholder="검색어를 입력하세요" value="${pageMaker.cri.searchText}">
              <button type="submit" class="btn btn-info me-2">검색</button>
              <button type="button" class="btn btn-warning me-2" onclick="location.href='<c:url value='/board/list' />'">전체보기</button>
              <button type="button" class="btn btn-success" onclick="location.href='<c:url value='/board/insert' />'">게시물 등록</button>
          </form>
      </div>


        <!-- 게시물 테이블 -->
        <div>
            <table class="table table-bordered table-striped table-hover">
                <thead class="table-light">
                    <tr>
                        <th>게시글 번호</th>
                        <th>제목</th>
                        <th>작성자 ID</th>
                        <th>조회수</th>
                        <th>작성일</th>
                        <th>replyGroup</th>
                        <th>replyOrder</th>
                        <th>replyIndent</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="board" items="${boardList}">
                        <tr>
                            <td>${board.boardNo}</td>
                            <td style="text-align: left;">
                            	<div style="margin-left: ${board.replyIndent * 20}px;">
                                	<a href="<c:url value='/board/view?boardNo=${board.boardNo }' />">${board.title}</a>
                                </div>
                            </td>
                            <td>${board.memberId}</td>
                            <td>${board.hitNo}</td>
                            <td>
                                <fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </td>
                            <td>${board.replyGroup }</td>
                            <td>${board.replyOrder }</td>
                            <td>${board.replyIndent }</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 로그인/로그아웃 버튼 이벤트 처리
        const loginButton = document.getElementById('loginButton');
        const logoutButton = document.getElementById('logoutButton');

        if (loginButton) {
            loginButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/login' />";
            });
        }

        if (logoutButton) {
            logoutButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/logout' />";
            });
        }
    </script>
</body>
</html>

