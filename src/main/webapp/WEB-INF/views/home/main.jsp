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
         #img_set{
         	width : 100%;
         	height : 30%;
         	padding-left : 11.8%;
         	padding-top : 2%;
         }
         #img_1{
         	border-radius: 15px;
         }
         #img_2{
         	border-radius: 15px;
         }
         #img_long{
         	padding-top : 0.5%;
         	padding-left : 12%;
         }
         #set_long{
         	border-radius: 15px;
         }
         #clickimg{
            margin-top : 2%;
            margin-left : 12%;
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
          padding-left : 100px;
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
         <form id="serch-txt" action="<c:url value='/board/product/list' />" method="get">
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
               <c:if test="${sessionScope.loginUser.roleId != 'admin'}">
                  <button id="memberButton" class="btn btn-warning btn-sm">마이페이지</button>
               </c:if>
               <button id="logoutButton" class="btn btn-danger btn-sm">로그아웃</button>
               <button id="cartButton" class="btn btn-info btn-sm">장바구니</button>
            </c:when>
            <c:otherwise>
                    <button id="loginButton" class="btn btn-primary btn-sm">로그인</button>
                    <button id="insertMemberButton" class="btn btn-primary btn-sm">회원가입</button>
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
            <a href="/product/list">상품 보러가기</a>
            <a href="/board/list">Q &amp; A</a>
        </div>
    </div>
   
   <div id="scrinImg">
      <img id="clickimg" src="https://www.costco.co.kr/medias/sys_master/banners/h4f/h99/297975754653726.webp"
       onclick="costco();">   
   </div>
   
   <div id="img_set">
   	  <img id="img_1" src="https://www.costco.co.kr/mediapermalink/FY25_P4_Sameday_service_ver2" onclick="Product();">
      <img id="img_2" src="https://www.costco.co.kr/mediapermalink/FY25_P4W3_2Bigbanner_BBLAP" onclick="ProductInsert();">
   </div>
   
   <div id="img_long">
      <img id="set_long" src="https://www.costco.co.kr/mediapermalink/FY25_P4W3_ThemeCarousel_Bar_desktop">
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
// 로그인/로그아웃 버튼 이벤트 처리
   const loginButton = document.getElementById('loginButton');
   const logoutButton = document.getElementById('logoutButton');
   const adminButton = document.getElementById('adminButton'); // 관리자
   const insertMemberButton = document.getElementById('insertMemberButton'); // 회원가입
   const cartButton = document.getElementById('cartButton');
   const memberButton = document.getElementById('memberButton');
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
	// 관리자 버튼 이벤트 핸들러
   if (adminButton) {
   	adminButton.addEventListener('click', function() {
           window.location.href = "<c:url value='/admin' />";
       });
   }

   if (logoutButton) {
       logoutButton.addEventListener('click', function() {
           window.location.href = "<c:url value='/logout' />";
       });
   }
   if (cartButton) {
	   cartButton.addEventListener('click', function() {
           window.location.href = "<c:url value='/cart/view' />";
       });
   }
   if (memberButton) {
	   memberButton.addEventListener('click', function() {
           window.location.href = "<c:url value='/member/mypage' />";
       });
   }
         function main(){
            window.location.href = "/board/home/main";
         }
         function costco(){
            window.location.href = "https://www.costco.co.kr/ExecutiveMembership";
         }
         function Product(){
        	 window.location.href = "/product/list";
         }
         function ProductInsert(){
        	 window.location.href = "/product/create";
         }
   </script>
</body>
</html>