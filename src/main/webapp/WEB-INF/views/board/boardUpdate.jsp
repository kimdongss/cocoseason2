<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 수정</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .btn-save {
            background-color: #007bff;
            color: white;
        }

        .btn-save:hover {
            background-color: #0056b3;
        }

        .btn-cancel {
            background-color: #e74c3c;
            color: white;
        }

        .btn-cancel:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>게시물 수정</h3>
                    </div>
                    <div class="card-body">
                        <form id="updateForm" action="<c:url value='/board/update' />" method="post">
                            <input id="boardNoInput" type="hidden" name="boardNo" value="${board.boardNo}">
                            <!-- 제목 -->
                            <div class="mb-3">
                                <label for="titleInput" class="form-label"><strong>제목</strong></label>
                                <input id="titleInput" type="text" class="form-control" name="title" 
                                       value="${board.title}" required>
                            </div>
                            <!-- 내용 -->
                            <div class="mb-3">
                                <label for="contentInput" class="form-label"><strong>내용</strong></label>
                                <textarea id="contentInput" class="form-control" name="content" rows="5" required>${board.content}</textarea>
                            </div>
                            <!-- 작성자 ID -->
                            <div class="mb-3">
                                <label class="form-label"><strong>작성자 ID</strong></label>
                                <input type="text" class="form-control" value="${board.memberId}" readonly>
                            </div>
                            <!-- 버튼 섹션 -->
                            <div class="d-flex justify-content-end gap-2">
                                <button id="submitButton" type="submit" class="btn btn-save">저장</button>
                                <button id="cancelButton" type="button" class="btn btn-cancel">취소</button>
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
            const title = document.getElementById("titleInput").value.trim();
            const content = document.getElementById("contentInput").value.trim();

            // 유효성 검사
            if (title === "") {
                alert("제목을 입력하세요.");
                event.preventDefault();
                return;
            }

            if (content === "") {
                alert("내용을 입력하세요.");
                event.preventDefault();
                return;
            }

            if (title.length > 100) {
                alert("제목은 100자를 초과할 수 없습니다.");
                event.preventDefault();
                return;
            }

            if (content.length > 500) {
                alert("내용은 500자를 초과할 수 없습니다.");
                event.preventDefault();
                return;
            }
        });

        // 취소 버튼 클릭 시 이벤트 처리
        document.getElementById("cancelButton").addEventListener("click", function() {
            if (confirm("수정을 취소하시겠습니까?")) {
                location.href = "<c:url value='/board/view' />?boardNo=${board.boardNo}";
            }
        });
    </script>
</body>
</html>
