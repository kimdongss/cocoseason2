<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 보기</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 버튼 컨테이너 */
        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        /* 버튼 스타일 */
        button {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
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

        /* 오류 메시지 스타일 */
        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>회원 정보 보기</h3>
                    </div>
                    <div class="card-body">
                        <!-- 아이디 -->
                        <div class="mb-3">
                            <label for="memberIdInput" class="form-label">아이디</label>
                            <input type="text" class="form-control" id="memberIdInput" name="memberId" 
                                   value="${member.memberId}" readonly>
                        </div>
                        <!-- 비밀번호 -->
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">비밀번호</label>
                            <input type="password" class="form-control" id="passwordInput" name="password" 
                                   value="${member.password}" readonly>
                        </div>
                        <!-- 이름 -->
                        <div class="mb-3">
                            <label for="nameInput" class="form-label">이름</label>
                            <input type="text" class="form-control" id="nameInput" name="name" 
                                   value="${member.name}" readonly>
                        </div>
                        <!-- 이메일 -->
                        <div class="mb-3">
                            <label for="emailInput" class="form-label">이메일</label>
                            <input type="email" class="form-control" id="emailInput" name="email" 
                                   value="${member.email}" readonly>
                        </div>
                        <!-- 버튼 섹션 -->
                        <div class="button-container">
                            <button id="updateButton" type="button" class="btn btn-update">수정</button>
                            <form id="deleteForm" action="<c:url value='/member/delete' />" method="post" >
                                <input type="hidden" name="memberId" value="${member.memberId}">
                                <button id="deleteButton" type="submit" class="btn btn-delete">삭제</button>
                            </form>
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
            location.href = "<c:url value='/member/update?memberId=${member.memberId}' />";
        });

        // 삭제 버튼 클릭 이벤트
        document.getElementById("deleteButton").addEventListener("click", function(event) {
            if (!confirm("정말 삭제하시겠습니까?")) {
                event.preventDefault(); // 삭제 취소
            }
        });

        // 목록 버튼 클릭 이벤트
        document.getElementById("listButton").addEventListener("click", function() {
            location.href = "<c:url value='/member/list' />";
        });
        
        // URL에서 errorMessage 파라미터 추출
        // new URLSearchParams(window.location.search)는 브라우저 환경에서 URL의 
        // 쿼리 문자열(Query String)을 다루기 위해 사용되는 URLSearchParams 객체를 생성하는 구문입니다. 
        // 이를 통해 URL의 파라미터를 손쉽게 추출하거나 조작할 수 있습니다.
        // window.location.search : 현재 페이지 URL의 쿼리 문자열(질의 문자열)을 반환합니다.
        // RLSearchParams는 JavaScript에서 제공하는 내장 객체로,쿼리 문자열을 쉽게 파싱하고 조작하는 기능 제공 
        const urlParams = new URLSearchParams(window.location.search);
        
        const errorMessage = urlParams.get('errorMessage');

        // 오류 메시지가 존재하면 alert로 표시
        if (errorMessage) {
            alert(decodeURIComponent(errorMessage));
        }        
    </script>
</body>
</html>
