<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

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
                        <!-- 로그인 체크: 로그인된 사용자가 아니면 로그인 페이지로 리다이렉트 -->
                        <c:if test="${sessionScope.loginUser == null}">
                            <script>
                                alert("로그인 후에 접근할 수 있습니다.");
                                location.href = "<c:url value='/login' />";
                            </script>
                        </c:if>

                        <!-- 권한 체크: admin인 경우, 'member/list'로 리다이렉트 -->
                        <c:if test="${sessionScope.loginUser != null and sessionScope.loginUser.roleId == 'admin'}">
                            <script>
                                alert("관리자는 마이페이지에 접근할 수 없습니다.");
                                location.href = "<c:url value='/member/list' />"; // admin일 경우 'member/list'로 리다이렉트
                            </script>
                        </c:if>

                        <!-- 회원 정보 표시 -->
                        <div class="mb-3">
                            <label for="memberIdInput" class="form-label">아이디</label>
                            <input type="text" class="form-control" id="memberIdInput" name="memberId" 
                                   value="${member.memberId}" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">비밀번호</label>
                            <input type="password" class="form-control" id="passwordInput" name="password" 
                                   value="${member.password}" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="nameInput" class="form-label">이름</label>
                            <input type="text" class="form-control" id="nameInput" name="name" 
                                   value="${member.name}" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="emailInput" class="form-label">이메일</label>
                            <input type="email" class="form-control" id="emailInput" name="email" 
                                   value="${member.email}" readonly>
                        </div>

                        <!-- 회원등급 -->
                        <div class="mb-3">
                            <label for="roleIdInput" class="form-label">회원등급 : 정회원(member), 준회원(guest)</label>
                            <input type="text" class="form-control" id="roleIdInput" name="roleId" size="1" value="${member.roleId}" readonly>
                        </div>

                        <!-- 전화번호 -->
                        <div class="mb-3">
                            <label for="phoneInput" class="form-label">전화번호</label>
                            <input type="tel" class="form-control" id="phoneInput" name="phone" value="${member.phone}" readonly>
                        </div>

                        <!-- 주소 -->
                        <div class="mb-3">
                            <label for="addressInput" class="form-label">주소</label>
                            <input type="text" class="form-control" id="addressInput" name="address" value="${member.address}" readonly>
                        </div>

                        <!-- 가입일자 -->
                        <div class="mb-3">
                            <label for="regDateInput" class="form-label">가입일자</label>
                            <input type="text" class="form-control" id="regDateInput" name="regDate" value="${member.regDate}" readonly>
                        </div>

                        <!-- 버튼 섹션 -->
                        <div class="button-container">
                            <button id="updateButton" type="button" class="btn btn-update">수정</button>
                            <form id="deleteForm" action="<c:url value='/member/delete' />" method="post">
                                <input type="hidden" name="memberId" value="${member.memberId}">
                                <button id="deleteButton" type="submit" class="btn btn-delete">삭제</button>
                            </form>
                            <button id="listButton" type="button" class="btn btn-list">홈으로</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 수정 버튼 클릭 시, 수정 페이지로 이동
        document.getElementById("updateButton").addEventListener("click", function() {
            location.href = "<c:url value='/member/myInfoUpdate?memberId=${member.memberId}' />";
        });

        // 삭제 버튼 클릭 시, 삭제 확인 팝업
        document.getElementById("deleteButton").addEventListener("click", function(event) {
            if (!confirm("정말 삭제하시겠습니까?")) {
                event.preventDefault();
            }
        });

        // 목록 버튼 클릭 시, 회원 목록 페이지로 이동
        document.getElementById("listButton").addEventListener("click", function() {
            location.href = "<c:url value='/home/main' />";
        });
    </script>
</body>
</html>
