<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Detail</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .image-container img {
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
            border: 2px solid #007bff;
            border-radius: 8px;
        }

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
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header text-center">
                        <h3>상품 상세 정보</h3>
                    </div>
                    <div class="card-body">
                        <!-- 상품명 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>상품명</strong></label>
                            <input type="text" class="form-control" value="${product.name}" readonly>
                        </div>
                        <!-- 상품 ID -->
                        <div class="mb-3">
                            <label class="form-label"><strong>상품 ID</strong></label>
                            <input type="text" class="form-control" value="${product.productId}" readonly>
                        </div>
                        <!-- 설명 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>설명</strong></label>
                            <textarea class="form-control" rows="3" readonly>${product.description}</textarea>
                        </div>
                        <!-- 단가 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>단가</strong></label>
                            <input type="text" class="form-control" value="${product.unitPrice}" readonly>
                        </div>
                        <!-- 입고일 -->
                        <div class="mb-3">
                            <label class="form-label"><strong>입고일</strong></label>
                            <input type="text" class="form-control"
                                value="<fmt:formatDate value='${product.regDate}' pattern='yyyy-MM-dd HH:mm:ss' />" readonly>
                        </div>

                        <!-- 이미지 목록 -->
                        <c:if test="${not empty product.imgList}">
                            <h5 class="mt-4">이미지 목록</h5>
                            <div class="image-container">
                                <c:forEach var="image" items="${product.imgList}">
                                    <img src="${pageContext.request.contextPath}/product/upload/${image.imgPath.replace('\\', '/')}/${image.fileName}" 
                                         alt="Product Image">
                                </c:forEach>
                            </div>
                        </c:if>
						
						 <!-- 주문하기 버튼 추가 -->
                        <%-- <c:if test="${sessionScope.loginUser != null}"> <!-- 로그인 상태 확인 -->
                            <c:if test="${sessionScope.loginUser.roleId == 'member' || sessionScope.loginUser.roleId == 'admin'}"> <!-- 역할 확인 -->
                                <form action="<c:url value='/order/place' />" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}"/>
                                    <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"/> <!-- 로그인한 회원 ID -->
                                    <input type="hidden" name="productName" value="${product.name}"/>
                                    <input type="hidden" name="unitPrice" value="${product.unitPrice}"/>
                                    <input type="hidden" name="quantity" value="1"/> <!-- 기본 수량 1로 설정 -->

                                    <!-- 주문하기 버튼 -->
                                    <button type="submit" class="btn btn-primary mt-4">주문하기</button> 
                                </form>
                            </c:if> --%>

                            <!-- 비회원 또는 권한 없는 사용자에 대한 메시지 -->
                            <%-- <c:if test="${sessionScope.loginUser.roleId == 'guest'}">
                                <button type="button" class="btn btn-danger mt-4"
                                        onclick='alert("정회원만 주문할 수 있습니다.");'>주문하기</button>
                            </c:if>

                        </c:if> --%>

                        <!-- 비로그인 상태일 때 로그인 페이지로 이동 -->
                        <%-- <c:if test="${sessionScope.loginUser == null}">
                            <button type='button' class='btn btn-warning mt-4'
                                    onclick='location.href="<c:url value='/login' />";'>로그인 후 주문하기</button>
                        </c:if> --%>
                        
                        <!-- 장바구니 담기 버튼 추가 -->
                        <c:if test="${sessionScope.loginUser != null}"> <!-- 로그인 상태 확인 -->
                            <c:if test="${sessionScope.loginUser.roleId == 'member' || sessionScope.loginUser.roleId == 'admin'}"> <!-- 역할 확인 -->
                                <form action="<c:url value='/cart/add' />" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}"/>
                                    <input type="hidden" name="memberId" value="${sessionScope.loginUser.memberId}"/> <!-- 로그인한 회원 ID -->
                                    <input type="hidden" name="productName" value="${product.name}"/>
                                    <input type="hidden" name="unitPrice" value="${product.unitPrice}"/>
                                    <input type="hidden" name="quantity" value="1"/> <!-- 기본 수량 1로 설정 -->

                                    <!-- 장바구니 담기 버튼 -->
                                    <button type='submit' class='btn btn-success mt-2'>장바구니 담기</button> 
                                </form>
                            </c:if>

                            <!-- 비회원 또는 권한 없는 사용자에 대한 메시지 -->
                            <c:if test="${sessionScope.loginUser.roleId == 'guest'}">
                                <button type='button' class='btn btn-danger mt-2'
                                        onclick='alert("정회원만 장바구니에 담을 수 있습니다.");'>장바구니 담기</button>
                            </c:if>

                        </c:if>

                        <!-- 비로그인 상태일 때 로그인 페이지로 이동 -->
                        <c:if test="${sessionScope.loginUser == null}">
                            <button type='button' class='btn btn-warning mt-2'
                                    onclick='location.href="<c:url value='/login' />";'>로그인 후 장바구니 담기</button>
                        </c:if>

                        <!-- 버튼 -->
                        <div class="d-flex justify-content-end gap-2 mt-4">
                        	<!-- 수정 버튼 (roleId가 admin인 경우에만 표시) -->
						    <c:if test="${sessionScope.loginUser != null and sessionScope.loginUser.roleId == 'admin'}">
						        <button id="updateButton" type="button" class="btn btn-update">수정</button>
						    </c:if>
							<!-- 삭제 버튼 (roleId가 admin인 경우에만 표시) -->
						    <c:if test="${sessionScope.loginUser != null and sessionScope.loginUser.roleId == 'admin'}">
						        <form id="deleteForm" action="<c:url value='/product/delete' />" method="post" class="d-inline">
						            <input type="hidden" name="productId" value="${product.productId}">
						            <button id="deleteButton" type="submit" class="btn btn-delete">삭제</button>
						        </form>
						    </c:if>                            
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
        document.getElementById("updateButton").addEventListener("click", function () {
            location.href = "<c:url value='/product/update?productId=${product.productId}' />";
        });

        // 삭제 버튼 클릭 이벤트
        document.getElementById("deleteButton").addEventListener("click", function (event) {
            if (!confirm("정말 삭제하시겠습니까?")) {
                event.preventDefault(); // 삭제 취소
            }
        });

        // 목록 버튼 클릭 이벤트
        document.getElementById("listButton").addEventListener("click", function () {
            location.href = "<c:url value='/product/list' />";
        });
    </script>
</body>
</html>
