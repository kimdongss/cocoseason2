package com.javalab.board.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javalab.board.dto.Criteria;
import com.javalab.board.dto.PageDto;
import com.javalab.board.service.BoardService;
import com.javalab.board.vo.BoardVo;
import com.javalab.board.vo.MemberVo;

import lombok.extern.slf4j.Slf4j;

/**
 * 게시물 컨트롤러
 * - 스프링 MVC의 주요 구성요소
 * - 사용자의 요청을 처리하고 응답을 반환하는 컨트롤러 클래스
 * - @Controller : 스프링에서 컨트롤러로 사용할 수 있도록 빈으로 등록
 * - 생성자가 한 개 뿐이면 @Autowired 어노테이션 생략 가능
 *  - 생성자가 한 개 뿐이면 스프링이 자동으로 주입해준다.
 *  - 이건 스프링 버전 4.3부터 가능하다.
 */
@Controller
@RequestMapping("/board") // 클래스 차원의 RequestMapping, 각 메소드에 있던 중복된 url 부분을(board) 클래스에 설정 
//@RequiredArgsConstructor // 롬복의 @RequiredArgsConstructor 어노테이션을 통한 의존성 주입, 생성자 자동 생성
@Slf4j	// 클래스에 @Slf4j를 추가하면 log라는 이름의 SLF4J 로거 객체를 자동으로 생성합니다.
public class BoardController {
	// 스프링 컨테이너로부터 BoardService Type의 빈을 찾아서 주입해준다.
	// 타입은 인터페이스이지만 실제 구현체인 BoardServiceImpl 객체가 주입된다.
	
	// [1] @Autowired 통한 의존성 주입	
	//@Autowired	// 스프링컨테이너에서 BoardService 타입의 구현체를 찾아서 주입하려고 시도한다.
	
	// [2] @Autowired + @Qualifier("service2")
	// @Autowired
	//@Qualifier("service2")	// 만약 같은 타입의 빈이 두 개 이상이라면 "service2"라는 이름으로 주입시도
	
	// [3] @Resource(name="주입할빈이름")
	// 위의 두 줄을 한줄로 변경 @Resuource(name="service2")로 대체할 수 있다.
	//@Resource(name="service2")
	//private BoardService service;
	
	// [4] 생성자를 통한 의존성 주입, 이때는 필드를 final로 설정, annotation 불필요
	// 스프링 4.3 버전부터 생성자가 한 개이면 @Autowired없이 의존성이 주입된다.
	private final BoardService service;
	// 4.1 생성자의 매개변수로 주입받을 의존성을 명시
	public BoardController(BoardService service) {
		this.service = service;
	}
	
	// [5] 롬복의 @RequiredArgsConstructor 어노테이션을 통한 의존성 간편 주입
	// 롬복의 @RequiredArgsConstructor 어노테이션을 통해 생성자를 만들어서 의존성 주입을 간편하게 처리할 수 있다.
	
	/*
	 * 게시물 목록 보기 메소드
	 * - 게시물 목록을 조회해서 jsp 페이지에 전달
	 * @RequestMapping : 요청 URL과 Controller의 메소드를 매핑
	 * Model : request와 유사한 기능, 여기에 저장하면 jsp에서 참조할 수 있게된다.
	 */
	//@RequestMapping(value="/board/list", method = RequestMethod.GET)
	/*
	 * @GetMapping("/list") public String listBoard(Locale locale, Model model) {
	 * log.info("listBoard 메소드 ==============================================="); //
	 * 이전 메소드에서 addFlashAttribute로 저장한 값이 Model에 자동으로 저장되었는지 확인
	 * model.asMap().forEach((key, value) -> { log.info("Key: " + key + ", Value: "
	 * + value); });
	 * 
	 * List<BoardVo> boardList = service.getBoardList();
	 * model.addAttribute("boardList", boardList); // 모델에 boardList return
	 * "board/boardList"; // jsp 페이지 이름 }
	 */
	
	
	/*
	 * 페이징, 검색 기능이 추가된 메소드
	 * - Criteria : 화면에서 전달된 요청 페이지, 검색어 취합(바인딩)
	 * - total : 총 게시물 건수
	 * - PageDto : cri와 total을 인자로 전달해서 페이지 그룹 관련 정보 생성
	 * 
	 */
	@GetMapping("/list") 
	public String getListPaging(Criteria cri, Model model) {
		log.info("selectBoardList 메소드 Criteria : " + cri);
		// 게시물 목록 조회
		List<BoardVo> boardList = service.getBoardListPaging(cri);
		model.addAttribute("boardList", boardList);
		// 게시물 건수 조회
		int total = service.getTotalBoardCount(cri);
		// 페이징관련 정보와 게시물 정보를 PageDto에 포장
		// 페이지 하단에 표시될 페이지 그룹과 관련된 정보 생성 
		PageDto dto = new PageDto(cri, total);
		
		log.info("dto : " + dto.toString());
		model.addAttribute("pageMaker", dto);
		
		return "board/boardList"; // jsp 페이지
	}

	
	/*
	 * 게시물 내용 조회
	 * - 게시물 번호를 받아서 해당 게시물의 상세 정보를 조회해서 jsp 페이지에 전달
	 * - int boardNo : 화면에서 인자로 전달받는 게시물번호
	 * - Model model : request와 같은 기능으로 jsp에서 사용할 정보를 저장
	 */
	//@RequestMapping(value="/board/view", method = RequestMethod.GET)
	@GetMapping(value="/view")
	public String viewBoard(int boardNo, Model model) {
		// 게시물 내용 조회
		BoardVo board = service.getBoard(boardNo);
		// 조회 결과 모델에 저장
		model.addAttribute("board", board);
		// 게시물 내용 페이지로 이동
		return "board/boardView";
	}	
	
	/*
	 * 게시물 등록 폼 보기 메소드
	 * - 게시물 등록 폼을 보여주는 jsp 페이지로 이동
	 * addFlashAttribute("board", boardVo)
	 * 	- 게시물 등록 메소드에서 오류로 인해서 addFlashAttribute메소드에 저장한 값이 자동으로 model에 담긴다. 
	 * 	- 기존 메소드에서 "board"라는 이름으로 저장하면 model에 "board"라는 이름으로 저장된다.
	 */	
	//@RequestMapping(value="/board/insert", method = RequestMethod.GET)
//	@GetMapping("/insert")
//	public String insertBoardForm(BoardVo boardVo, Model model) {
//	    // 모델에 "board"가 없는 경우 빈 BoardVo 객체를 추가
//	    if (!model.containsAttribute("board")) {
//	        model.addAttribute("board", new BoardVo());
//	    }
//	    model.addAttribute("board", boardVo);
//	    // 게시물 등록폼 페이지로 이동
//	    return "board/boardInsert";
//	}
	// 자동으로 flash에 담아줘버리니 위 처럼 수동으로 담아줄 필요가 없다.
	// 아래 등록처리에서 담긴게 여기로와서 모델에 담긴다. 
	@GetMapping("/insert")
	public String insertBoardForm(Model model) {
	    // 1. 모델에 "board"가 없는 경우 빈 BoardVo 객체를 추가 : 최초로 페이지가 열린 경우
		// 2. 게시물 등록 처리 메소드에서 처리중 오류가 발생해서 여기로 온 경우에는? 
		//		게시물 등록 처리에서 세션에 담았던 데이터를 그대로 입력화면으로 전달해야 하기 때문에 빈 객체를 생성해서 보내지 않는다. 
	    if (!model.containsAttribute("board")) { // model에 "board"라는 이름으로 객체가 저장되어 있는지 검사 
	        model.addAttribute("board", new BoardVo()); // 빈 객체 생성해서 페이지에 전달 즉, 페이지가 최초로 열렸을 때 보드에 아무것도 없으면 빈 객체 만들어서 보냄 
	    }
	    // 게시물 등록폼 페이지로 이동
	    return "board/boardInsert";
	}

	/*
	 * 게시물 등록 처리
	 * - 게시물 등록 폼에서 입력한 데이터를 받아서 DB에 저장
	 * - 화면에서 입력한 데이터를 BoardVo 객체로 받아서 insertBoard 메소드 호출, 
	 *   이렇게 화면의 정보를 받아주는 클래스를 DTO(Data Transfer Object)라고 한다.
	 * - 화면에서 입력한 데이터를 DTO로 받는 것을 "바인딩"이라고 한다.
	 * [순서]
	 * 1. 사용자가 화면에 게시물 정보 입력후 엔터
	 * 2. 스프링이 현재 메소드의 매개변수(DTO)를 객체로 생성하고 알맞은 세터메소드를 호출해서
	 *   화면에서 전달 된 값을 세팅해준다.
	 *   BoardVo : 바인딩 객체, 즉 화면의 게시물 데이터를 모두 자동으로 바인딩해준다. 
	 *   RedirectAttributes : sendRedirect() 요청이 있을 때 요청과 함께 데이터를 담아서 보내는 역할.
	 *   addFlashAttribute : 이 메소드를 통해서 값을 저장하면 sendRedirect로 요청한 컨트롤러 메소드에서 그 값이 자동으로 model에 저장된다.
	 *   						이렇게 저장한 값은 일시적으로 세션에 보관된다.
	 */
	@PostMapping("/insert")
	public String insertBoard(BoardVo boardVo, RedirectAttributes redirectAttributes) {
	    try {
	        service.insertBoard(boardVo); // 게시물 등록 처리 
	        redirectAttributes.addFlashAttribute("successMessage", "게시물이 정상적으로 등록되었습니다!");
	        redirectAttributes.addFlashAttribute("board", boardVo); // 이렇게 저장하면 다음 메소드에서 사용 가능
	        return "redirect:/board/list";
	    } catch (Exception e) {
	        // 오류 메시지와 기존 입력값 전달
	        redirectAttributes.addFlashAttribute("errorMessage", "게시물 등록 중 오류가 발생했습니다.");
	        redirectAttributes.addFlashAttribute("board", boardVo); // 기존 입력값을 board라는 이름으로 세션(session)에 잠깐 저장
	        // 게시물 등록 폼으로 이동
	        return "redirect:/board/insert";
	    }
	}
	

	/*
	 * 게시물 수정 폼 보기 메소드
	 * - 게시물 번호를 받아서 해당 게시물의 정보를 조회해서 수정 폼으로 이동
	 */
	@GetMapping("/update")
	   public String updateBoardForm(@RequestParam("boardNo") int boardNo, 
	                                  @ModelAttribute("board") BoardVo boardVo, 
	                                  Model model, HttpSession session,
	                                  RedirectAttributes redirectAttributes) {

		
		// 세션에서 로그인 사용자 정보 가져오기
		 MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");
		
		// 로그인 사용자가 없을 경우[인터셉터에서 처리]
		// 로그인 사용자가 없을 경우[인터셉터에서 처리]
	       //if (loginUser == null) {
	       //    redirectAttributes.addFlashAttribute("errorMessage", "로그인 후 이용해주세요.");
	       //    return "redirect:/login"; // 로그인 페이지로 리다이렉트
	       //}

		
		// 게시물 조회 
		 BoardVo existingBoard = service.getBoard(boardNo);
		
		// 게시물이 없거나 작성자와 로그인한 사용자가 다를 경우
		 if (existingBoard == null || !existingBoard.getMemberId().equals(loginUser.getMemberId())) {
	           redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
	           return "redirect:/board/view?boardNo=" + boardNo; // 게시물 상세 보기로 이동
	       }

		
		// 수정폼에 보여줄 게시물 조회 최초로 수정폼을 열었을경우
		 if (boardVo.getTitle() == null) { // 기존 입력값이 없으면 DB에서 조회 : 게시물이 최초로 열린다는 뜻
			 boardVo = existingBoard;  // 수정할 게시물 정보를 기존 게시물로 설정
			 model.addAttribute("board", boardVo); // 모델에 저장
		    }
		// 수정폼(화면)으로 이동
		 return "board/boardUpdate";

	}

	/*
	 * 게시물 수정 처리
	 * - 게시물 수정 폼에서 입력한 데이터를 받아서 DB에 저장
	 * - DTO로 화면의 값을 한꺼번에 바인딩받고 있다.
	 */
	@PostMapping("/update")
	public String updateBoard(BoardVo boardVo, RedirectAttributes redirectAttributes) {
	    try {
	        // 업데이트 결과를 확인
	        int rowsAffected = service.updateBoard(boardVo);
	        if (rowsAffected > 0) {
	            redirectAttributes.addFlashAttribute("successMessage", "게시물이 정상적으로 수정되었습니다!");
	            return "redirect:/board/view?boardNo=" + boardVo.getBoardNo();
	        } else {
	            redirectAttributes.addFlashAttribute("errorMessage", "수정하려는 게시물이 존재하지 않습니다.");
	            return "redirect:/board/list";
	        }
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("errorMessage", "게시물 수정 중 오류가 발생했습니다.");
	        redirectAttributes.addFlashAttribute("board", boardVo); // 기존 입력값을 세션에 임시 보관(보드라는 이름으로)
	        return "redirect:/board/update?boardNo=" + boardVo.getBoardNo();
	    }
	}


	
	/*
	 * 게시물 삭제 메소드
	 * - 게시물 번호를 받아서 해당 게시물을 삭제
	 */
	@PostMapping("/delete")
	public String deleteBoard(int boardNo) {
		// 게시물 삭제
		service.deleteBoard(boardNo);
		// 게시물 목록 컨트롤러 요청
		return "redirect:/board/list";
	}	
	
	
	/**
     * 답글 등록 폼 보기
     * - 부모 게시물 번호를 받아서 답글 작성을 위한 폼으로 이동
     */
    @GetMapping("/reply")
    public String replyBoardForm(@RequestParam("parentBoardNo") int parentBoardNo, Model model) {
        // 부모 게시물 정보 조회
    	BoardVo parentBoard = service.getBoard(parentBoardNo);

    	log.info("parentBoard : " + parentBoard);
        if (parentBoard == null) {
            model.addAttribute("errorMessage", "존재하지 않는 게시물입니다.");
            return "redirect:/board/list";
        }

        
        
//        // 답글 작성에 필요한 초기값 설정
//        BoardVo replyBoard = new BoardVo();
//        replyBoard.setReplyGroup(parentBoard.getReplyGroup());	// 부모의 group을 답글의 group으로 설정
//        replyBoard.setReplyOrder(parentBoard.getReplyOrder() + 1); // 답글, 부모 order + 1
//        replyBoard.setReplyIndent(parentBoard.getReplyIndent() + 1); // 답글, 부모 indent + 1

        // 모델에 답글 정보를 추가
        model.addAttribute("parentBoard", parentBoard);
//        model.addAttribute("replyBoard", replyBoard);

        // 답글 작성 폼으로 이동
        return "board/boardReply";
    }

    /**
     * 답글 등록 처리
     * - 답글 폼에서 입력한 데이터를 DB에 저장
     */
    @PostMapping("/reply")
    public String replyBoard(@ModelAttribute("replyBoard") BoardVo replyBoard, RedirectAttributes redirectAttributes) {
        try {
        	log.info("replyBoard : " + replyBoard);
            // 답글 등록 처리
            int result = service.insertReply(replyBoard);
            if (result > 0) {
                redirectAttributes.addFlashAttribute("successMessage", "답글이 정상적으로 등록되었습니다!");
                return "redirect:/board/list";
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "답글 등록 중 문제가 발생했습니다.");
                return "redirect:/board/reply?parentBoardNo=" + replyBoard.getReplyGroup();
            }
        } catch (Exception e) {
            log.error("답글 등록 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("errorMessage", "답글 등록 중 오류가 발생했습니다.");
            return "redirect:/board/reply?parentBoardNo=" + replyBoard.getReplyGroup();
        }
    }
}