package com.javalab.board.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.javalab.board.vo.MemberVo;


/**
 * 인터셉터 클래스
 *  - 중간에 요청을 가로채서 컨트롤러 메소드로 가기 전에 실행됨.
 *  - HandlerInterceptorAdapter를 상속받으면 인터셉터 객체가 되며
 *    preHandle(), postHandle(), afterCompletion() 3가지를
 *    오버라이딩해서 각각 원하는 역할을 부여할 수 있다.
 */
public class LoginInterceptor extends HandlerInterceptorAdapter {

    private static final Logger log = LoggerFactory.getLogger(LoginInterceptor.class);

    /*
     * [프리 핸들러]
     * - 컨트롤러(즉 RequestMapping이 선언된 메서드 진입) 실행 직전에 동작.
     * - 반환 값이 true일 경우 즉, 로그인 여부를 체크해서 로그인을 했으면 true를
     *   반환하고 안했으면 false를 반환하게 한다. 만약 false이면 컨트롤러의 메소드로
     *   진입 못한다. 실행이 멈춘다.
     */

    @Override
    public boolean preHandle(HttpServletRequest request, 
    						HttpServletResponse response, 
    						Object handler) throws Exception {

    	log.info("preHandle 메소드===================================");
        HttpSession session = request.getSession();
        MemberVo user = (MemberVo)session.getAttribute("loginUser");
        
		// 세션에 사용자 정보가 없다는 것은 로그인  안한 사용자!
        if(user == null) {
        	 log.info("세션에 사용자 정보가 없음");
        	 
        	// 인터셉터 오기 전에 가려고 했던 Url 추출
        	String previousUrl = request.getRequestURL().toString();

        	// 세션에 저장했다가 나중에 로그인이 되면 그 때 이동하기 위해서 저장
        	request.setAttribute("previousUrl", previousUrl);
        	log.info("원래 가려고 했던 URL : " + previousUrl);
        	
        	// 로그인 안한 사용자는 로그인 폼으로 이동		
        	String contextPath = request.getContextPath();
        	
        	// 로그인폼 띄워주는 메소드(핸들러) 호출
        	String url = contextPath + "/login"; 
        	response.sendRedirect(url); // 로그인 폼으로 이동
        	
        	return false; // 더이상 컨트롤러 요청으로 가지 않도록 false로 반환함
        }
//        //여기까지 왔으면 세션에 사용자 정보 있음. 즉, 로그인한 사용자
//        log.info("세션에 사용자 정보 있으므로 요청 처리");
//        return true; // 요청된 메소드로 갈수 있다. true이니까
        
        // [추가] 사용자 권한 관련 추가 코드 
        String roleId = user.getRoleId(); // 세션에서 사용자 권한 추출
        String requestUri = request.getRequestURI(); // 사용자가 요청한 URI
        
        // 관리자가 아닌 일반사용자가 /member/** 와 같은 형태의 요청시 접근 차단 
        if(!roleId.equals("admin") && requestUri.startsWith(request.getContextPath()+"/member")) {
        	log.info("권한없음 roleId : " + roleId);
        	response.sendRedirect(request.getContextPath() + "/member/mypage"); // 일반사용자가 회원관련 요청시 게시물 목록으로 강제 이동
        	return false;
        	// 관리자가 아닌 일반사용자가 /product/** 와 같은 형태의 요청시 접근 차단 
        }else if(!roleId.equals("admin") && requestUri.startsWith(request.getContextPath()+"/product")) {
        	log.info("권한없음 roleId : " + roleId);
        	response.sendRedirect(request.getContextPath() + "/product/list"); // 일반사용자가 상품등록 못하게 하기 
        	return false;
        } else if(!roleId.equals("admin") && requestUri.startsWith(request.getContextPath()+"/board/reply")) {
        	log.info("권한없음 roleId : " + roleId);
        	response.sendRedirect(request.getContextPath() + "/board/list"); // 일반사용자가 질의응답게시판 답글 못달게하기
        	return false;
        } else if(!roleId.equals("admin") && requestUri.startsWith(request.getContextPath()+"/order/admin")) {
        	log.info("권한없음 roleId : " + roleId);
        	response.sendRedirect(request.getContextPath() + "/order/my-orders"); // 일반사용자가 전체주문 접근시 내주문보기로 보내버림(아래 어드민하고 뎁스 수정해서 통합가능)
        	return false;
        } else if(!roleId.equals("admin") && requestUri.startsWith(request.getContextPath()+"/admin")) {
        	log.info("권한없음 roleId : " + roleId);
        	response.sendRedirect(request.getContextPath() + "member/mypage"); // 일반사용자가 관리자 페이지 접근시 마이페이지로 보내버림
        	return false;
        }

        //여기까지 왔으면 세션에 사용자 정보 있음. 즉, 로그인한 사용자
        log.info("세션에 사용자 정보 있으므로 요청 처리");
        return true; // 요청된 메소드로 갈수 있다. true이니까
    }    
    
    /*
     * 컨트롤러가 수행되고 난 후에 화면이 보여지기 직전에 수행되는 메서드
     * 컨트롤러 진입 후 view가 랜더링 되기 전에 수행됨.
     * 전달인자의 modelAndView을 통해 화면 단에 들어가는 데이터 등의 조작이 가능함.
     * Controller에서 Exception이 발생 할 경우 posthandle로 요청이 넘어오지 않는다.
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, 
    						Object handler, ModelAndView modelAndView) throws Exception {
    	super.postHandle(request, response, handler, modelAndView);
    	log.info("postHandle 메소드 ===================================");

    }

    // [무조건 실행] 컨트롤러의 메소드(핸들러)가 실행되고 난 다음에 무조건 실행되는 로직 구현
    // 컨트롤러에서 Exception이 발생하여도 이 메소드는 실행된다. 즉, 뷰단은 실행된다.
    // view까지 처리하고 난 후에 처리됨
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        super.afterCompletion(request, response, handler, ex);
    	log.info("afterCompletion ===================================");
    }    
    
}
