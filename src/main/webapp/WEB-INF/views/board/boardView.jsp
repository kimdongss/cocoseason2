<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 상세 보기</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .button-container button {
            color: white;
        }

        .btn-update {
            background-color: #007bff;
        }

        .btn-update:hover {
            background-color: #0056b3;
        }

        .btn-delete {
            background-color: #e74c3c;
        }

        .btn-delete:hover {
            background-color: #c0392b;
        }

        .btn-list {
            background-color: #4CAF50;
        }

        .btn-list:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                <!-- 오류 메시지 표시 -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            ${errorMessage}
                        </div>
                    </c:if>
                    <div class="card-header text-center">
                        <h3>게시물 상세 보기</h3>
                    </div>
                    <div class="card-body">
                        <!-- 제목 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>제목</strong></label>
                            <input type="text" class="form-control" value="${board.title}" readonly>
                        </div>
                        <!-- 내용 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>내용</strong></label>
                            <textarea class="form-control" rows="5" readonly>${board.content}</textarea>
                        </div>
                        <!-- 작성자 ID -->
                        <div class="mb-3">
                            <label class="form-label"><strong>작성자 ID</strong></label>
                            <input type="text" class="form-control" value="${board.memberId}" readonly>
                        </div>
                        <!-- 조회수 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>조회수</strong></label>
                            <input type="text" class="form-control" value="${board.hitNo}" readonly>
                        </div>
                        <!-- 작성일 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>작성일</strong></label>
                            <input type="text" class="form-control" 
                                   value="<fmt:formatDate value='${board.regDate}' pattern='yyyy-MM-dd HH:mm:ss' />" readonly>
                        </div>
                        <div class="d-flex justify-content-end gap-2">
                            <button id="updateButton" type="button" class="btn btn-update">수정</button>
                            <form id="deleteForm" action="<c:url value='/board/delete' />" method="post" class="d-inline">
                                <input type="hidden" name="boardNo" value="${board.boardNo}">
                                <button id="deleteButton" type="submit" class="btn btn-delete">삭제</button>
                            </form>
                            <!-- 답글쓰기 버튼 -->
    						<button id="replyButton" type="button" class="btn btn-warning">답글쓰기</button>
                            <button id="listButton" type="button" class="btn btn-list">목록으로</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 수정 버튼 클릭 이벤트
        document.getElementById("updateButton").addEventListener("click", function() {
            location.href = "<c:url value='/board/update?boardNo=${board.boardNo}' />";
        });

        // 삭제 버튼 클릭 이벤트
        document.getElementById("deleteButton").addEventListener("click", function(event) {
            if (!confirm("정말 삭제하시겠습니까?")) {
                event.preventDefault(); // 삭제 취소
            }
        });
        
        // 답글쓰기 버튼 클릭 이벤트
        document.getElementById("replyButton").addEventListener("click", function() {
            location.href = "<c:url value='/board/reply?parentBoardNo=${board.boardNo}' />";
        });
        
        // 목록 버튼 클릭 이벤트
        document.getElementById("listButton").addEventListener("click", function() {
            location.href = "<c:url value='/board/list' />";
        });
    </script>
</body>
</html>
