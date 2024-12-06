<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>답글 작성</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function () {
            // 폼 제출 시 유효성 검사
            $('#replyForm').on('submit', function (event) {
                const title = $('#titleInput').val().trim();
                const content = $('#contentInput').val().trim();

                if (title === "") {
                    alert("제목을 입력하세요.");
                    $('#titleInput').focus();
                    event.preventDefault();
                    return;
                }

                if (content === "") {
                    alert("내용을 입력하세요.");
                    $('#contentInput').focus();
                    event.preventDefault();
                    return;
                }

                if (title.length > 100) {
                    alert("제목은 100자를 초과할 수 없습니다.");
                    $('#titleInput').focus();
                    event.preventDefault();
                    return;
                }

                if (content.length > 500) {
                    alert("내용은 500자를 초과할 수 없습니다.");
                    $('#contentInput').focus();
                    event.preventDefault();
                    return;
                }
            });

            // 취소 버튼 클릭 시 페이지 이동
            $('#cancelButton').on('click', function () {
                if (confirm("작성 중인 내용을 취소하시겠습니까?")) {
                    location.href = "<c:url value='/board/list' />";
                }
            });
        });
    </script>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>답글 작성</h3>
                    </div>
                    <div class="card-body">
                        <form id="replyForm" action="<c:url value='/board/reply' />" method="post">
                            <!-- 부모 게시물 정보 -->
                            <div class="mb-3">
                                <label for="parentInfo" class="form-label">부모 게시물</label>
                                <textarea class="form-control" id="parentInfo" rows="3" readonly>
                                    제목: ${parentBoard.title}
                                    작성자: ${parentBoard.memberId}
                                    내용: ${parentBoard.content}
                                </textarea>
                            </div>

                            <!-- 제목 -->
                            <div class="mb-3">
                                <label for="titleInput" class="form-label">제목</label>
                                <input type="text" class="form-control" id="titleInput" name="title" maxlength="100" required>
                                <div class="form-text">제목은 100자 이내로 작성해주세요.</div>
                            </div>

                            <!-- 내용 -->
                            <div class="mb-3">
                                <label for="contentInput" class="form-label">내용</label>
                                <textarea class="form-control" id="contentInput" name="content" rows="5" maxlength="500" required></textarea>
                                <div class="form-text">내용은 500자 이내로 작성해주세요.</div>
                            </div>

                            <!-- 작성자 ID -->
                            <div class="mb-3">
                                <label for="memberIdInput" class="form-label">작성자 ID</label>
                                <input type="text" class="form-control" id="memberIdInput" name="memberId" 
                                       value="${sessionScope.loginUser.memberId}" readonly required>
                            </div>

                            <!-- 숨겨진 필드 (계층 구조 정보) -->
                            <input type="hidden" name="replyGroup" value="${replyBoard.replyGroup}">
                            <input type="hidden" name="replyOrder" value="${replyBoard.replyOrder}">
                            <input type="hidden" name="replyIndent" value="${replyBoard.replyIndent}">

                            <!-- 버튼 -->
                            <div class="d-flex justify-content-between">
                                <button type="submit" id="submitButton" class="btn btn-primary">등록</button>
                                <button type="button" id="cancelButton" class="btn btn-secondary">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
