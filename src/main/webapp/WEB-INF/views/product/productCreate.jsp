<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- CKEditor 5 CDN -->
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.2/classic/ckeditor.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        let editorInstance;

        $(document).ready(function () {
        	// CKEditor 초기화
            ClassicEditor
                .create(document.querySelector('#descriptionInput'))
                .then(editor => {
                    editorInstance = editor;

                    // 에디터 컨테이너의 스타일 변경 (높이 900px)
                    const editorContainer = editor.ui.view.editable.element;
                    editorContainer.style.height = "200px"; // 현재 높이의 3배로 설정
                })
                .catch(error => {
                    console.error(error);
                });
            // 동적 파일 추가
            $('#addFileButton').on('click', function () {
                const fileCount = $('.file-input').length;
                if (fileCount < 5) {
                    $('#fileInputs').append(`
                        <div class="mb-3">
                            <input type="file" class="form-control file-input" name="files" />
                        </div>
                    `);
                } else {
                    alert("파일은 최대 5개까지 업로드할 수 있습니다.");
                }
            });

            // 유효성 검사 및 CKEditor 데이터 동기화
            $('#productForm').on('submit', function (event) {
                const name = $('#nameInput').val().trim();
                const unitPrice = $('#unitPriceInput').val().trim();

                // CKEditor 데이터 가져오기 및 태그 제거
                const editorData = editorInstance.getData();
                const plainText = editorData.replace(/<[^>]*>?/gm, ''); // HTML 태그 제거
                $('#descriptionInput').val(plainText);

                if (name === "") {
                    alert("상품명을 입력하세요.");
                    $('#nameInput').focus();
                    event.preventDefault();
                    return;
                }

                if (plainText === "") {
                    alert("상품 설명을 입력하세요.");
                    $('#descriptionInput').focus();
                    event.preventDefault();
                    return;
                }

                if (!unitPrice || isNaN(unitPrice) || parseFloat(unitPrice) <= 0) {
                    alert("올바른 가격을 입력하세요.");
                    $('#unitPriceInput').focus();
                    event.preventDefault();
                    return;
                }
            });

            // 취소 버튼 클릭 시 확인
            $('#cancelButton').on('click', function () {
                if (confirm("작성 중인 내용을 취소하시겠습니까?")) {
                    location.href = "<c:url value='/product/list' />";
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
                        <h3>상품 등록</h3>
                    </div>
                    <div class="card-body">
                        <form id="productForm" action="<c:url value='/product/create'/>" method="post" enctype="multipart/form-data">
                            <!-- 상품명 -->
                            <div class="mb-3">
                                <label for="nameInput" class="form-label">상품명</label>
                                <input type="text" class="form-control" id="nameInput" name="name" maxlength="100" />
                                <div class="form-text">상품명은 필수 입력 항목입니다.</div>
                            </div>
                            <!-- 설명 -->
                            <div class="mb-3">
                                <label for="descriptionInput" class="form-label">설명</label>
                                <textarea id="descriptionInput" name="description" style="height: 300px;"></textarea>

                                <div class="form-text">상품 설명을 작성하세요.</div>
                            </div>
                            <!-- 가격 -->
                            <div class="mb-3">
                                <label for="unitPriceInput" class="form-label">가격</label>
                                <input type="text" class="form-control" id="unitPriceInput" name="unitPrice" />
                                <div class="form-text">가격은 숫자로만 입력하세요.</div>
                            </div>
                            <!-- 파일 업로드 -->
                            <div class="mb-3">
                                <label class="form-label">파일 업로드</label>
                                <div id="fileInputs">
                                    <div class="mb-3">
                                        <input type="file" class="form-control file-input" name="files" />
                                    </div>
                                </div>
                                <button type="button" id="addFileButton" class="btn btn-outline-secondary">파일 추가</button>
                                <div class="form-text">최대 5개의 파일을 업로드할 수 있습니다.</div>
                            </div>
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
