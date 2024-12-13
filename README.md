요청 흐름:
사용자 요청 → 컨트롤러 → 서비스 → 레포지토리 → 매퍼 XML (MyBatis) → 데이터베이스 → VO → 서비스 → 컨트롤러 → JSP

사용자 요청이 Spring MVC 컨트롤러로 들어오면, 컨트롤러는 서비스 계층을 호출합니다. 서비스 계층은 비즈니스 로직을 처리하고 MyBatis를 통해 데이터베이스와 상호작용합니다. 처리된 결과는 다시 컨트롤러를 거쳐 JSP 뷰로 전달되어 사용자에게 보여집니다. 전체 과정에서 로그인 인터셉터, 트랜잭션 관리, 커넥션 풀링 등의 기능들이 보조적으로 작동합니다.
이 구조에서 각 계층은 명확히 분리되어 있으며, Spring Framework와 MyBatis를 통해 효율적으로 연결됩니다. servlet-context.xml은 전체 애플리케이션의 구성을 관리하며, 각 계층 간의 의존성 주입을 담당합니다.

구현내용 

회원 관리 시스템
회원가입, 로그인, 마이페이지 기능


상품 관리 시스템
상품 목록 및 상세 정보 표시
상품 게시판 구현

장바구니 및 주문 시스템
장바구니 추가, 수정, 삭제 기능
주문 처리 기능

Ajax를 활용한 회원가입 시 실시간 아이디 중복 검사
Ajax를 이용한 실시간 수량 변경 및 금액 계산

r

게시판 시스템
질의응답 게시판 구현
CRUD(생성, 읽기, 수정, 삭제) 기능

보안 및 인증
로그인 인터셉터를 통한 접근 제어

데이터베이스 연동
Oracle 데이터베이스 사용
MyBatis를 통한 데이터 접근 계층 구현

프레임워크 및 라이브러리 활용
Spring MVC 기반 웹 애플리케이션 구조
HikariCP를 이용한 데이터베이스 커넥션 풀 관리
Log4jdbc를 통한 SQL 로깅


BoardController: 게시판 관련 기능을 처리합니다. 게시물 목록 조회, 상세 조회, 등록, 수정, 삭제, 답글 작성 등의 기능을 담당합니다.
HomeController: 애플리케이션의 홈 페이지를 처리합니다. 현재는 게시물 목록으로 리다이렉트하고 있습니다.
LoginController: 로그인, 로그아웃 기능을 처리합니다. 세션을 통해 사용자 인증 상태를 관리합니다.
MemberController: 회원 관리 기능을 담당합니다. 회원 목록 조회, 상세 조회, 등록, 수정, 삭제, 아이디 중복 확인 등의 기능을 제공합니다.
ProductController: 상품 관리 기능을 담당합니다. 상품 등록, 목록 조회, 상세 조회, 수정, 삭제 및 이미지 업로드/조회 기능을 제공합니다.

이 컨트롤러들은 Spring MVC 패턴을 따르고 있으며, 각각의 비즈니스 로직을 처리하기 위해 해당 서비스 계층을 호출하고 있습니다. 또한 적절한 뷰로 데이터를 전달하거나 리다이렉트하는 역할을 수행합니다.


제공된 코드는 페이징 처리를 위한 두 개의 DTO(Data Transfer Object) 클래스를 정의하고 있습니다:
Criteria 클래스:
페이징 및 검색 정보를 저장하는 클래스입니다.
주요 필드:
pageNum: 요청된 페이지 번호 (기본값 1)
amount: 한 페이지에 표시할 게시물 수 (기본값 10)
searchText: 검색 키워드 (기본값 빈 문자열)
여러 생성자를 통해 다양한 초기화 방법을 제공합니다.

PageDto 클래스:
페이지 그룹 관련 정보를 계산하고 저장하는 클래스입니다.
주요 필드:
startPage: 시작 페이지 번호
endPage: 끝 페이지 번호
prev, next: 이전/다음 페이지 존재 여부
total: 전체 게시물 수
cri: Criteria 객체
생성자에서 페이지 그룹 정보를 계산합니다:
끝 페이지 번호 계산
시작 페이지 번호 계산
실제 끝 페이지 번호 계산 및 보정
이전/다음 페이지 존재 여부 결정
이 두 클래스는 함께 작동하여 페이지네이션 기능을 구현하는 데 사용됩니다. Criteria는 사용자의 요청 정보를 캡슐화하고, PageDto는 이를 바탕으로 실제 페이지 네비게이션에 필요한 정보를 계산합니다



LoginInterceptor 클래스
기능 개요:
LoginInterceptor는 Spring MVC의 인터셉터로, 사용자의 요청을 가로채어 로그인 상태를 확인하고, 권한을 검사하는 기능을 제공합니다.
HandlerInterceptorAdapter를 상속받아 preHandle, postHandle, afterCompletion 메소드를 오버라이드하여 요청 처리 전후에 특정 로직을 실행할 수 있습니다.
주요 메소드:
preHandle:
컨트롤러 메소드가 실행되기 전에 호출됩니다.
세션에서 로그인 사용자 정보를 확인하고, 로그인되지 않은 경우 로그인 페이지로 리다이렉트합니다.
관리자가 아닌 사용자가 회원 관련 요청을 할 경우 접근을 차단하고 게시물 목록으로 리다이렉트합니다.
반환값이 false일 경우, 요청 처리가 중단되고 컨트롤러 메소드로 진입하지 않습니다.
postHandle:
컨트롤러 메소드가 실행된 후, 뷰가 렌더링되기 직전에 호출됩니다.
이 메소드는 주로 모델에 추가된 데이터를 조작하거나 로그를 기록하는 데 사용됩니다.
afterCompletion:
뷰가 렌더링된 후에 항상 호출됩니다.
이 메소드는 요청 처리 후 정리 작업이나 리소스 해제를 수행하는 데 유용합니다.
로그 기록:
SLF4J 로거를 사용하여 각 단계에서 로그를 기록합니다. 이는 디버깅과 문제 해결에 도움이 됩니다.
결론:
LoginInterceptor는 사용자 인증 및 권한 관리를 위한 중요한 역할을 수행하며, 보안성을 높이는 데 기여합니다. 이를 통해 관리자는 특정 URL에 대한 접근을 제어하고, 로그인하지 않은 사용자를 적절한 페이지로 리다이렉트할 수 있습니다.


BoardRepository 인터페이스
기능: 게시판 관련 데이터베이스 작업을 처리하는 인터페이스입니다.
주요 메소드:
getBoardList(): 게시물 목록을 조회합니다.
getBoard(int boardNo): 특정 게시물의 내용을 조회합니다.
insertBoard(BoardVo boardVo): 게시물을 등록합니다.
updateBoard(BoardVo boardVo): 게시물을 수정합니다.
deleteBoard(int boardNo): 게시물을 삭제합니다.
increaseHitNo(int boardNo): 게시물 조회수를 증가시킵니다.
getBoardListPaging(Criteria cri): 페이징 처리된 게시물 목록을 조회합니다.
getTotalBoardCount(Criteria cri): 총 게시물 수를 조회합니다.
insertReply(BoardVo boardVo): 답글을 작성합니다.
updateReplyOrder(BoardVo boardVo): 답글 작성 시 필요한 사전 작업을 수행합니다.


LoginRepository 인터페이스
기능: 사용자 로그인 관련 데이터베이스 작업을 처리하는 인터페이스입니다.
주요 메소드:
checkLogin(String memberId, String password): 사용자 아이디와 비밀번호로 사용자를 조회합니다.


MemberRepository 인터페이스
기능: 회원 관련 데이터베이스 작업을 처리하는 인터페이스입니다.
주요 메소드:
getMemberList(): 회원 목록을 조회합니다.
getMember(String memberId): 특정 회원 정보를 조회합니다.
insertMember(MemberVo memberVo): 회원 정보를 추가합니다.
updateMember(MemberVo memberVo): 회원 정보를 수정합니다.
deleteMember(String memberId): 회원 정보를 삭제합니다.
existsById(String memberId): 아이디 중복 여부를 확인합니다.


ProductRepository 인터페이스
기능: 상품 관련 데이터베이스 작업을 처리하는 인터페이스입니다.
주요 메소드:
insertProduct(ProductVo product): 상품 정보를 등록합니다.
insertImages(List<ImgVo> images): 상품 이미지 정보를 등록합니다.
getAllProducts(): 모든 상품 목록을 조회합니다.
getProductWithImages(Long productId): 특정 상품과 관련된 이미지를 함께 조회합니다.
updateProductWithImages(ProductVo product): 상품 정보 및 이미지를 수정합니다.
deleteImagesByProductId(Long productId): 특정 상품의 이미지를 삭제합니다.
deleteProduct(Long productId): 특정 상품을 삭제합니다.
이들 인터페이스는 각 도메인에 대한 CRUD(Create, Read, Update, Delete) 작업을 정의하고 있으며, MyBatis와 같은 ORM 프레임워크와 함께 사용되어 실제 데이터베이스 작업을 수행하게 됩니다.


BoardService 인터페이스
기능: 게시판 관련 비즈니스 로직을 처리하는 서비스 인터페이스입니다.
주요 메소드:
getBoardList(): 게시물 목록을 조회합니다.
getBoard(int boardNo): 특정 게시물의 내용을 조회합니다.
insertBoard(BoardVo boardVo): 게시물을 등록합니다.
updateBoard(BoardVo boardVo): 게시물을 수정합니다.
deleteBoard(int boardNo): 게시물을 삭제합니다.
getBoardListPaging(Criteria cri): 페이징 처리된 게시물 목록을 조회합니다.
getTotalBoardCount(Criteria cri): 총 게시물 수를 조회합니다.
insertReply(BoardVo boardVo): 답글을 작성합니다.

BoardServiceImpl 클래스
기능: BoardService 인터페이스의 구현체로, 실제 비즈니스 로직을 수행합니다.
주요 메소드:
getBoardList(): 게시물 목록을 조회하여 반환합니다.
getBoard(int boardNo): 게시물 조회수 증가 후 특정 게시물을 반환합니다.
insertBoard(BoardVo boardVo): 게시물을 등록하고 결과를 반환합니다.
updateBoard(BoardVo boardVo): 게시물을 수정하고 결과를 반환합니다.
deleteBoard(int boardNo): 게시물을 삭제하고 결과를 반환합니다.
getTotalBoardCount(Criteria cri): 총 게시물 수를 조회하여 반환합니다.
insertReply(BoardVo reply): 답글 작성을 위한 메소드를 구현하며, 트랜잭션 관리가 포함되어 있습니다.

LoginService 인터페이스
기능: 로그인 관련 비즈니스 로직을 처리하는 서비스 인터페이스입니다.
주요 메소드:
checkLogin(String memberId, String password): 사용자 아이디와 비밀번호로 사용자를 확인합니다.

LoginServiceImpl 클래스
기능: LoginService 인터페이스의 구현체로, 실제 로그인 로직을 수행합니다.
주요 메소드:
checkLogin(String memberId, String password): 로그인 정보를 확인하고, 성공 시 사용자 정보를 반환합니다.

MemberService 인터페이스
기능: 회원 관련 비즈니스 로직을 처리하는 서비스 인터페이스입니다.
주요 메소드:
getMemberList(): 회원 목록을 조회합니다.
getMember(String memberId): 특정 회원 정보를 조회합니다.
insertMember(MemberVo memberVo): 회원 정보를 추가합니다.
updateMember(MemberVo memberVo): 회원 정보를 수정합니다.
deleteMember(String memberId): 회원 정보를 삭제합니다.
isMemberIdDuplicated(String memberId): 아이디 중복 여부를 확인합니다.

MemberServiceImpl 클래스
기능: MemberService 인터페이스의 구현체로, 실제 비즈니스 로직을 수행합니다.
주요 메소드:
모든 CRUD 작업을 처리하며, 아이디 중복 확인 기능도 포함되어 있습니다.

ProductService 인터페이스
기능: 상품 관련 비즈니스 로직을 처리하는 서비스 인터페이스입니다.
주요 메소드:
상품 등록, 조회, 수정 및 삭제 기능과 이미지 처리 기능이 포함되어 있습니다.

ProductServiceImpl 클래스
기능: ProductService 인터페이스의 구현체로, 실제 상품 관련 비즈니스 로직을 수행합니다.
주요 메소드:
상품 정보 등록 및 이미지 저장, 상품 목록 조회, 특정 상품 정보 조회, 상품 수정 및 삭제 기능을 포함하고 있습니다.
트랜잭션 관리가 포함되어 있어 데이터 무결성을 유지할 수 있습니다.
이제 다음 코드를 보내주시면 계속해서 검토하겠습니다!



BoardVo 클래스
기능: 게시물 정보를 저장하는 자바 빈즈 클래스입니다.
주요 필드:
boardNo: 게시물 번호
title: 게시물 제목
content: 게시물 내용
memberId: 게시물 작성자 ID
hitNo: 조회수
regDate: 게시물 작성일자
replyGroup, replyOrder, replyIndent: 계층형 답변 게시판용 속성으로, 답글의 그룹, 순서 및 들여쓰기를 관리합니다.
롬복 어노테이션: 생성자, 게터/세터, toString 메소드를 자동으로 생성합니다.


ImgVo 클래스
기능: 상품 이미지 정보를 저장하는 자바 빈즈 클래스입니다.
주요 필드:
imgId: 상품 이미지 ID
productId: 관련 상품 ID
imgPath: 이미지 경로
fileName: 이미지 파일명
isMain: 대표 이미지 여부 (0: 대표 이미지)


MemberVo 클래스
기능: 회원 정보를 저장하는 자바 빈즈 클래스입니다.
주요 필드:
memberId: 회원 ID
password: 비밀번호
name: 이름
email: 이메일 주소
roleId: 권한 (예: admin, user)
phone: 전화번호
address: 주소
regDate: 가입 일자


ProductVo 클래스
기능: 상품 정보를 저장하는 자바 빈즈 클래스입니다.
주요 필드:
productId: 상품 ID
name: 상품명
description: 상품 설명
unitPrice: 상품 단가
regDate: 등록일


ProductWithImageVo 클래스
기능: 상품 정보와 관련된 이미지 정보를 함께 담는 클래스입니다.
주요 필드:
productId, name, description, unitPrice, regDate: 상품 정보와 관련된 필드.
imgPath, fileName: 대표 이미지 경로 및 파일명.
imgList: 해당 상품의 여러 이미지를 담는 리스트.


ResponseVo 클래스
기능: AJAX 요청에서 서버의 처리 결과 상태와 메시지를 함께 전달하기 위한 객체입니다.
주요 필드:
success: 처리 결과 (true/false)
message: 구체적인 처리 결과 메시지


RoleVo 클래스
기능: 권한 정보를 저장하는 자바 빈즈 클래스입니다.
주요 필드:
roleId: 권한 ID
roleName: 권한 이름
이들 VO(Value Object) 클래스는 데이터베이스와의 상호작용 시 데이터를 캡슐화하여 전달하는 역할을 하며, 각 도메인 모델을 표현합니다.


BoardMapper.xml
기능: 게시물 관련 SQL 쿼리를 정의하는 MyBatis 매퍼 XML 파일입니다.
주요 쿼리:
getBoardList: 모든 게시물을 조회하는 쿼리입니다.
getBoardListPaging: 페이징 및 검색 기능을 지원하는 게시물 목록 조회 쿼리입니다. ROW_NUMBER()를 사용하여 페이징 처리를 합니다.
getBoard: 특정 게시물 번호로 게시물 내용을 조회합니다.
increaseHitNo: 특정 게시물의 조회수를 증가시키는 쿼리입니다.
getTotalBoardCount: 전체 게시물 수를 조회하는 쿼리입니다.
insertBoard: 새 게시물을 등록하는 쿼리입니다.
updateReplyOrder: 답글 순서를 조정하는 쿼리입니다.
insertReply: 답글을 삽입하는 쿼리입니다.
updateBoard: 게시물을 수정하는 쿼리입니다.
deleteBoard: 게시물을 삭제하는 쿼리입니다.

LoginMapper.xml
기능: 로그인 관련 SQL 쿼리를 정의하는 MyBatis 매퍼 XML 파일입니다.
주요 쿼리:
checkLogi

MemberMapper.xml
기능: 회원 관련 SQL 쿼리를 정의하는 MyBatis 매퍼 XML 파일입니다.
주요 쿼리:
getMemberList: 모든 회원 목록을 조회합니다.
getMember: 특정 회원 정보를 조회합니다.
insertMember: 새 회원 정보를 등록합니다.
updateMember: 회원 정보를 수정합니다.
deleteMember: 특정 회원 정보를 삭제합니다.
existsById: 특정 회원 ID의 중복 여부를 확인합니다.



ProductMapper.xml
기능: 상품 관련 SQL 쿼리를 정의하는 MyBatis 매퍼 XML 파일입니다.
주요 쿼리:
insertProduct: 새 상품 정보를 등록합니다. 상품 ID는 시퀀스를 사용하여 자동 생성됩니다.
getAllProducts: 모든 상품 목록을 조회합니다.
getProductWithImages: 특정 상품과 관련된 이미지를 함께 조회합니다.
updateProductWithImages: 상품 정보를 수정합니다.
deleteImagesByProductId: 특정 상품의 이미지를 삭제합니다.
deleteProduct: 특정 상품을 삭제합니다.

이들 XML 파일은 각 도메인에 대한 SQL 쿼리를 정의하고 있으며, MyBatis가 이들을 사용하여 데이터베이스와 상호작용하게 됩니다.

database.properties
기능: 데이터베이스 연결 정보를 설정하는 파일입니다.
주요 속성:
jdbc.driver: JDBC 드라이버 클래스 이름을 설정합니다. 현재는 log4jdbc를 사용하여 SQL 쿼리를 로깅합니다.
jdbc.url: 데이터베이스 연결 URL을 설정합니다. 여기서는 log4jdbc를 통해 Oracle 데이터베이스에 연결합니다.
jdbc.username: 데이터베이스 사용자 이름입니다.
jdbc.password: 데이터베이스 비밀번호입니다.



file.properties
기능: 파일 업로드 경로를 설정하는 파일입니다.
주요 속성:
file.path: 업로드된 파일이 저장될 디렉토리 경로를 설정합니다. 여기서는 Windows 경로 형식을 사용하고 있습니다.
이 두 파일은 애플리케이션의 설정을 관리하는 데 중요한 역할을 하며, 데이터베이스와 파일 시스템의 경로를 정의하여 코드에서 쉽게 사용할 수 있도록 합니다.


log4j.xml
기능: Log4j를 사용하여 애플리케이션의 로그를 설정하는 파일입니다.
주요 구성 요소:
Appender: 로그 메시지를 출력하는 방법을 정의합니다. 여기서는 콘솔에 로그를 출력하는 ConsoleAppender가 설정되어 있습니다.
Logger: 특정 패키지나 클래스에 대한 로그 레벨을 설정합니다. com.javalab.board 패키지와 Spring 관련 패키지에 대해 info 레벨로 설정되어 있습니다.
Root Logger: 최상위 로거로, 기본 로그 레벨을 warn으로 설정하고 콘솔에 로그를 출력하도록 지정합니다.


log4jdbc.log4j2.properties
기능: Log4jdbc의 로깅 설정을 정의하는 파일입니다.
주요 속성:
log4jdbc.spylogdelegator.name: Log4jdbc에서 사용할 로깅 프레임워크를 지정합니다. 여기서는 SLF4J를 사용하고 있습니다.

logback.xml
기능: Logback을 사용하여 애플리케이션의 로그를 설정하는 파일입니다.
주요 구성 요소:
Property: 로그 파일이 저장될 경로를 설정합니다.
Appender: 로그 메시지를 출력하는 방법을 정의합니다. 콘솔과 파일 모두에 로그를 출력하도록 설정되어 있습니다.
Logger: 특정 패키지 또는 클래스에 대한 로그 레벨을 설정합니다. Spring 프레임워크와 com.javalab.board 패키지에 대해 info 레벨로 설정되어 있습니다.
Root Logger: 최상위 로거로, 기본 로그 레벨을 info로 설정하고 콘솔과 파일에 로그를 출력하도록 지정합니다.
이들 파일은 애플리케이션의 로깅을 관리하는 데 중요한 역할을 하며, 다양한 로깅 프레임워크와 함께 사용되어 애플리케이션의 실행 중 발생하는 이벤트와 오류를 기록합니다.


servlet-context.xml
기능: Spring MVC 설정을 정의하는 파일로, 웹 애플리케이션의 요청 처리에 필요한 설정을 포함합니다.
주요 구성 요소:
mvc:annotation-driven: Spring MVC의 어노테이션 기반 기능을 활성화합니다.
mvc:resources: 정적 리소스(예: CSS, JS 파일)의 매핑을 설정합니다.
InternalResourceViewResolver: JSP 뷰 리졸버를 설정하여 JSP 파일의 경로를 지정합니다.
CommonsMultipartResolver: 파일 업로드 처리를 위한 설정으로, 업로드된 파일의 크기 및 인코딩을 지정합니다.
mvc:interceptors: 로그인 인터셉터를 등록하여 특정 URL 요청에 대해 인증 및 권한 검사를 수행합니다.
tx:annotation-driven: 트랜잭션 관리 기능을 활성화합니다.
context:component-scan: 컨트롤러 빈을 자동으로 스캔하여 등록합니다.

root-context.xml
기능: 애플리케이션의 전체적인 설정을 정의하는 파일로, 데이터베이스 연결 및 서비스 계층의 빈을 설정합니다.
주요 구성 요소:
mybatis-spring:scan: MyBatis 매퍼 인터페이스를 스캔하여 자동으로 빈으로 등록합니다.
context:property-placeholder: 외부 프로퍼티 파일에서 데이터베이스 연결 정보를 로드합니다.
HikariCP 설정: HikariCP를 사용하여 데이터베이스 연결 풀을 구성합니다.
SqlSessionFactoryBean: MyBatis의 SqlSessionFactory를 생성하여 매퍼 XML과 연결합니다.
SqlSessionTemplate: MyBatis와 Spring의 통합을 위한 템플릿 클래스를 생성합니다.
transactionManager: 데이터베이스 트랜잭션 관리를 위한 매니저를 설정합니다.
context:component-scan: 서비스 및 리포지토리 레이어의 빈을 자동으로 스캔하여 등록합니다.
이 두 파일은 Spring 애플리케이션의 핵심 설정을 포함하고 있으며, 데이터베이스 연결, 트랜잭션 관리, MVC 패턴 구현 등을 지원하는 역할을 합니다.



web.xml
기능: 웹 애플리케이션의 설정을 정의하는 배치 파일입니다.
주요 구성 요소:
context-param: Spring의 루트 컨텍스트 설정 파일(root-context.xml)의 위치를 지정합니다.
listener: Spring의 ContextLoaderListener를 등록하여 애플리케이션이 시작될 때 Spring 컨텍스트를 초기화합니다.
servlet: Spring MVC의 DispatcherServlet을 등록하여 모든 요청을 처리하도록 설정합니다. 이 서블릿은 servlet-context.xml에서 추가적인 설정을 로드합니다.
servlet-mapping: DispatcherServlet이 처리할 URL 패턴을 지정합니다. 여기서는 모든 요청("/")을 처리하도록 설정되어 있습니다.
filter: CharacterEncodingFilter를 사용하여 요청과 응답의 문자 인코딩을 UTF-8로 설정합니다.
filter-mapping: 필터가 적용될 URL 패턴을 지정합니다.


JSP 파일 (paste.txt, paste-2.txt, paste-3.txt)
기능: 회원 가입 페이지를 구현한 JSP 파일입니다. 이 페이지는 사용자로부터 회원 정보를 입력받고, AJAX를 사용하여 아이디 중복 확인 기능을 제공합니다.
주요 구성 요소:
HTML 구조: Bootstrap을 사용하여 스타일링된 회원 가입 폼이 포함되어 있습니다.
JavaScript/jQuery:
아이디 중복 확인 버튼 클릭 시 AJAX 요청을 통해 서버에 중복 여부를 확인합니다.
폼 제출 시 유효성 검사 함수를 호출하여 모든 입력값이 유효한지 확인합니다.
폼 필드: 아이디, 비밀번호, 이름, 이메일 등의 입력 필드가 있으며, 각 필드는 필수 입력으로 설정되어 있습니다.
오류 메시지 처리: 서버에서 반환된 오류 메시지를 사용자에게 표시합니다.
이러한 구성은 사용자가 쉽게 회원 가입을 할 수 있도록 도와주며, 클라이언트 측에서 유효성 검사를 통해 서버의 부담을 줄이는 데 기여합니다.


index.jsp
기능: 웹 애플리케이션의 메인 페이지를 구성하는 JSP 파일입니다.
주요 구성 요소:
JSP 태그 및 라이브러리:
page 지시어: JSP 페이지의 언어와 인코딩을 설정합니다.
taglib: JSTL(Core) 라이브러리를 사용하여 URL 생성 및 조건부 로직을 처리합니다.
HTML 구조:
페이지 제목과 헤더를 포함하고, 사용자가 클릭할 수 있는 링크를 제공합니다.
링크:
게시글 목록, 상품 목록, 회원 목록으로 이동하는 링크가 포함되어 있습니다. 각 링크는 <c:url> 태그를 사용하여 동적으로 URL을 생성합니다.
이 페이지는 사용자에게 애플리케이션의 주요 기능에 접근할 수 있는 간단한 인터페이스를 제공합니다.


boardinsert.jsp
기능: 게시물 작성을 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap을 사용하여 스타일링된 게시물 작성 폼이 포함되어 있습니다.
JavaScript/jQuery:
폼 제출 시 제목과 내용의 유효성을 검사하여 비어있거나 길이가 초과할 경우 경고 메시지를 표시합니다.
취소 버튼 클릭 시 게시물 목록으로 이동하는 기능을 구현합니다.
폼 필드:
제목, 내용, 작성자 ID 입력 필드가 있으며, 작성자 ID는 세션에서 가져옵니다.
제목과 내용은 필수 입력 필드로 설정되어 있습니다.


boardList.jsp
기능: 게시물 목록을 표시하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap을 사용하여 스타일링된 게시물 목록 테이블이 포함되어 있습니다.
검색 기능: 사용자가 검색어를 입력하고 게시물을 검색할 수 있는 입력란과 버튼이 있습니다.
게시물 테이블: 데이터베이스에서 조회한 게시물 정보를 테이블 형식으로 표시합니다. 각 게시물은 제목을 클릭하면 상세 보기로 이동합니다.
페이징 처리: 페이지 번호와 이전/다음 버튼을 통해 게시물 목록을 페이징할 수 있는 기능이 포함되어 있습니다.


boardReply.jsp
기능: 답글 작성을 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일의 답글 작성 폼이 포함되어 있습니다.
JavaScript/jQuery:
폼 제출 시 제목과 내용의 유효성을 검사합니다.
취소 버튼 클릭 시 게시물 목록으로 이동하는 기능을 구현합니다.
부모 게시물 정보: 부모 게시물의 제목, 작성자, 내용을 보여주는 읽기 전용 텍스트 영역이 포함되어 있습니다.


boardUpdate.jsp
기능: 기존 게시물을 수정하기 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일의 수정 폼이 포함되어 있습니다.
JavaScript/jQuery:
폼 제출 시 제목과 내용의 유효성을 검사합니다.
취소 버튼 클릭 시 수정 내용을 취소하고 상세 보기로 돌아가는 기능을 구현합니다.
폼 필드: 제목과 내용을 수정할 수 있는 입력 필드가 있으며, 작성자 ID는 읽기 전용으로 표시됩니다.


boardView.jsp
기능: 특정 게시물의 상세 정보를 보여주는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일로 구성된 상세 보기 페이지입니다.
게시물 정보 표시: 제목, 내용, 작성자 ID, 조회수 및 작성일 등의 정보를 읽기 전용으로 표시합니다.
버튼 기능: 수정, 삭제, 답글쓰기 및 목록으로 돌아가기 버튼이 포함되어 있습니다. 각 버튼에 대한 클릭 이벤트가 정의되어 있어 해당 기능을 수행합니다.
이러한 JSP 파일들은 사용자와 상호작용하며 애플리케이션의 다양한 기능을 제공하는 중요한 역할을 합니다.


login.jsp
기능: 사용자 로그인 기능을 제공하는 JSP 파일입니다.
주요 구성 요소:
JSP 태그 및 라이브러리:
page 지시어: JSP 페이지의 언어와 인코딩을 설정합니다.
taglib: JSTL(Core) 라이브러리를 사용하여 URL 생성 및 조건부 로직을 처리합니다.
HTML 구조: Bootstrap을 사용하여 스타일링된 로그인 폼이 포함되어 있습니다.
폼 필드:
아이디와 비밀번호 입력 필드가 있으며, 각 필드는 필수 입력으로 설정되어 있습니다.
JavaScript/jQuery:
로그인 폼 제출 시 유효성 검사를 수행하여 아이디와 비밀번호가 입력되었는지 확인합니다.
취소 버튼 클릭 시 메인 페이지로 이동하는 기능을 구현합니다.
에러 메시지 표시: 로그인 실패 시 서버에서 전달된 에러 메시지를 사용자에게 보여줍니다.
이 페이지는 사용자가 애플리케이션에 로그인할 수 있도록 도와주며, 유효성 검사를 통해 잘못된 입력을 방지합니다.


memberInsert.jsp
기능: 사용자 회원 가입을 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
JSP 태그 및 라이브러리:
page 지시어: JSP 페이지의 언어와 인코딩을 설정합니다.
taglib: JSTL(Core) 라이브러리를 사용하여 URL 생성 및 조건부 로직을 처리합니다.
HTML 구조: Bootstrap을 사용하여 스타일링된 회원 가입 폼이 포함되어 있습니다.
JavaScript/jQuery:
아이디 중복 확인 버튼 클릭 시 AJAX 요청을 통해 서버에 중복 여부를 확인합니다.
폼 제출 시 유효성 검사를 수행하여 모든 입력값이 유효한지 확인합니다.
취소 버튼 클릭 시 회원 목록으로 이동하는 기능을 구현합니다.
폼 필드: 아이디, 비밀번호, 이름, 이메일, 주소, 전화번호 등의 입력 필드가 있으며, 각 필드는 필수 입력으로 설정되어 있습니다.
에러 메시지 표시: 서버에서 전달된 오류 메시지를 사용자에게 보여줍니다.


memberList.jsp
기능: 등록된 회원 목록을 표시하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap을 사용하여 스타일링된 회원 목록 테이블이 포함되어 있습니다.
로그인/로그아웃 버튼: 사용자의 로그인 상태에 따라 다른 버튼을 표시합니다.
회원 목록 테이블: 데이터베이스에서 조회한 회원 정보를 테이블 형식으로 표시합니다. 각 회원의 이름은 클릭하면 상세 보기로 이동합니다.
회원가입 버튼: 로그인하지 않은 경우 회원가입 버튼이 표시됩니다.

memberUpdate.jsp
기능: 기존 회원 정보를 수정하기 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일의 수정 폼이 포함되어 있습니다.
폼 필드: 아이디(읽기 전용), 비밀번호, 이름, 이메일 등의 입력 필드가 있으며, 각 필드는 수정할 수 있도록 설정되어 있습니다.
버튼 기능: 수정 및 취소 버튼이 포함되어 있으며, 취소 버튼 클릭 시 회원 목록으로 돌아가는 기능이 구현되어 있습니다.


memberView.jsp
기능: 특정 회원의 상세 정보를 보여주는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일로 구성된 상세 보기 페이지입니다.
회원 정보 표시: 아이디, 비밀번호(읽기 전용), 이름, 이메일 등의 정보를 읽기 전용으로 표시합니다.
버튼 기능: 수정 및 삭제 버튼이 포함되어 있으며, 삭제 버튼 클릭 시 확인 메시지를 표시합니다. 수정 버튼 클릭 시 수정 페이지로 이동하는 기능이 구현되어 있습니다.
이러한 JSP 파일들은 사용자와 상호작용하며 애플리케이션의 다양한 기능을 제공하는 중요한 역할을 합니다.




productCreate.jsp
기능: 새 상품 등록을 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
JSP 태그 및 라이브러리:
page 지시어: JSP 페이지의 언어와 인코딩을 설정합니다.
taglib: JSTL(Core) 라이브러리를 사용하여 URL 생성 및 조건부 로직을 처리합니다.
HTML 구조: Bootstrap을 사용하여 스타일링된 상품 등록 폼이 포함되어 있습니다.
JavaScript/jQuery:
CKEditor를 사용하여 상품 설명 입력 필드를 초기화합니다.
파일 업로드 필드를 동적으로 추가하는 기능이 포함되어 있습니다.
폼 제출 시 유효성 검사를 수행하여 모든 입력값이 유효한지 확인하고, CKEditor에서 HTML 태그를 제거하여 순수 텍스트로 변환합니다.
취소 버튼 클릭 시 상품 목록으로 이동하는 기능을 구현합니다.
폼 필드: 상품명, 설명, 가격, 파일 업로드 필드가 있으며, 각 필드는 필수 입력으로 설정되어 있습니다.


productDetail.jsp
기능: 특정 상품의 상세 정보를 보여주는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일로 구성된 상세 보기 페이지입니다.
상품 정보 표시: 상품명, 상품 ID, 설명, 단가, 입고일 등의 정보를 읽기 전용으로 표시합니다.
이미지 목록: 관련된 이미지들을 보여주는 섹션이 포함되어 있습니다. 이미지 경로를 동적으로 생성하여 표시합니다.
버튼 기능: 수정, 삭제 및 목록으로 돌아가기 버튼이 포함되어 있으며, 각 버튼에 대한 클릭 이벤트가 정의되어 있습니다.


productList.jsp
기능: 등록된 상품 목록을 표시하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap을 사용하여 스타일링된 상품 목록 테이블이 포함되어 있습니다.
검색 기능: 사용자가 검색어를 입력하고 상품을 검색할 수 있는 입력란과 버튼이 있습니다.
상품 테이블: 데이터베이스에서 조회한 상품 정보를 테이블 형식으로 표시합니다. 각 상품의 이름은 클릭하면 상세 보기로 이동합니다.
페이징 처리: 페이지 번호와 이전/다음 버튼을 통해 상품 목록을 페이징할 수 있는 기능이 포함되어 있습니다.


productUpdate.jsp
기능: 기존 상품 정보를 수정하기 위한 폼을 제공하는 JSP 파일입니다.
주요 구성 요소:
HTML 구조: Bootstrap 스타일의 수정 폼이 포함되어 있습니다.
폼 필드: 상품 ID(숨겨진 필드), 상품명, 설명, 가격 등의 입력 필드가 있으며, 각 필드는 수정할 수 있도록 설정되어 있습니다.
버튼 기능: 수정 및 취소 버튼이 포함되어 있으며, 취소 버튼 클릭 시 상품 목록으로 돌아가는 기능이 구현되어 있습니다.
이러한 JSP 파일들은 사용자와 상호작용하며 애플리케이션의 다양한 기능을 제공하는 중요한 역할을 합니다.

pom.xml
기능: Maven 프로젝트의 설정 파일로, 프로젝트의 의존성, 빌드 설정 및 플러그인을 정의합니다.
주요 구성 요소:
project: Maven 프로젝트의 기본 정보를 포함합니다. 여기에는 그룹 ID, 아티팩트 ID, 프로젝트 이름, 버전 등이 포함됩니다.
properties: 프로젝트에서 사용할 버전 정보를 정의합니다. 예를 들어, Java 버전, Spring 버전 등이 있습니다.
dependencies: 프로젝트에서 사용하는 라이브러리와 그 버전을 정의합니다. 주요 의존성으로는 Spring Framework, MyBatis, HikariCP, SLF4J, Log4j 등이 포함됩니다.
각 의존성은 그룹 ID, 아티팩트 ID 및 버전을 포함하며, 필요한 경우 스코프를 설정할 수 있습니다.
예를 들어, spring-webmvc, mybatis, ojdbc8 등의 의존성이 있습니다.
build: 빌드 관련 설정을 정의합니다. 여기에는 Maven 플러그인 설정이 포함됩니다. 예를 들어, Maven Compiler Plugin을 사용하여 Java 소스 및 타겟 버전을 설정하고, Exec Maven Plugin을 사용하여 특정 클래스를 실행할 수 있습니다.
이 파일은 Maven 빌드를 통해 의존성을 관리하고 프로젝트를 구성하는 데 중요한 역할을 합니다.






