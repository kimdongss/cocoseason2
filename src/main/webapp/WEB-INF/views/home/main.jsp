<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<html>
<head>
   <title>Costco Home</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://kit.fontawesome.com/b68dd2b146.js" crossorigin="anonymous"></script>
   <style>
      @font-face {
        font-family: 'Nanum Gothic';
        font-style: normal;
        font-weight: 400;
        src: url('fonts/NanumGothic-Regular.ttf') format('truetype');
      }
         body{
            width : 100%;
            height : 100%;
            background-color:#f0f8ff;
         }
         #heder{
            width : 80%;
            height : 15%;
            margin-top : 50px;
            margin-left : 200px;
            margin-right : 200px;
         }
         #mainPage{
            float:left;
         }
         
         #loginform{
            display: block;
            float:right;
            margin: 20px;
            margin-top: 60px;
            
         }
         #serch{
            display:block;
            float:left;
            margin: 50px;
            margin-left: 50px;
            width: 45%;
            height : 15%;
         }
         #serch-txt{
            width : 100%;
            height : 50px;
            background-color : #ffffff;
         }
         #settxt{
            width : 90%;
            height : 50px;
            outline : none;
            border-right:0px;
         }
         #serch-go{
            float : right;
            display : flex;
            height : 50px;
            width : 10%;
            background-color : #ffffff;
            border-left:0px;
            justify-content : center;
            align-items : center;
         }
         #menu{
            clear:both;
            width : 100%;
            display: block;
            background-color : #0073a6;
         }
         
         #menu-info{
            width : 50%;
           left: 15%;
         }
         table{
            margin-left   : 25%;
         }
         td{
            font-size : 46px;
            text-align: center;
            text-decoration-line: none;
            font-family: 'Nanum Gothic', sans-serif;
         }
         
         #scrinImg{
            clear:both;
            width : 100%;
            display: block;
            margin: 0 auto;
         }
         #clickimg{
            margin-top : 2%;
            margin-left : 15%;
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
   <div id="heder">
      <div id="mainPage">
         <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtLJK5IIsDCA02NsQ1lfaqedrii0ghoyCmNQ&s" onclick="main();">
      </div>
      <div id="serch">
         <form id="serch-txt" action="" method="get">
            <input id="settxt" type="text" placeholder="찾으시는 상품을 입력해 보세요">
            <button id="serch-go">
               <i id="serch-img" class="fa-solid fa-magnifying-glass"></i>
            </button>
         </form>
      </div>
      <div id="loginform">
            <c:choose>
            <c:when test="${not empty loginUser.memberId}">
               <span class="me-2 text-secondary">${sessionScope.loginUser.memberId}님</span>
               <!-- 관리자 권한이 있는 경우 "관리자" 버튼 추가 -->
               <c:if test="${sessionScope.loginUser.roleId == 'admin'}">
                  <button id="adminButton" class="btn btn-warning btn-sm">관리자</button>
               </c:if>
               <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
               <button id="testbutton">장바구니</button>
            </c:when>
            <c:otherwise>
                    <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                    <button id="insertMemberButton" class="btn btn-primary btn-sm">회원가입</button>
                </c:otherwise>
            </c:choose>
         </div>
   </div>
   <div id="menu">
      <table id="menu-info">
         <tr>
            <td>
               <a style="color:#ffffff;text-decoration-line: none;" href="<c:url value='/board/list' />">게시글 목록 페이징</a>
            </td>
            <td>
               <a style="color:#ffffff;text-decoration-line: none;" href="<c:url value='/product/list' /> ">상품목록</a>
            </td>
            <td>
            <c:choose>
            <c:when test="${sessionScope.loginUser.roleId == 'admin'}">
               <a style="color:#ffffff;text-decoration-line: none;" href="<c:url value='/member/list' /> ">회원 목록</a>
               </c:when>
               </c:choose>
            </td>
         </tr>
      </table>
   </div>
   
   <div id="scrinImg">
      <img id="clickimg" src="https://www.costco.co.kr/medias/sys_master/banners/h4f/h99/297975754653726.webp"
       onclick="costco();">   
   </div>
   
   <div id="">
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
                    <h6>매장 & 서비스</h6>
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
   <script>
         function main(){
            window.location.href = "/view/main";
         }
         function costco(){
            window.location.href = "https://www.costco.co.kr/ExecutiveMembership";
         }
       const loginButton = document.getElementById('loginButton');
        const logoutButton = document.getElementById('logoutButton');
        
        if (loginButton) {
            loginButton.addEventListener('click', function() {
            window.location.href = "<c:url value='/login' />";
       });
      }
        if (insertMemberButton) {
           insertMemberButton.addEventListener('click', function() {
                window.location.href = "<c:url value='/member/insert' />";
            });
        }
   
   </script>
</body>
</html>