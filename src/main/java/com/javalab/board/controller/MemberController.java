package com.javalab.board.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.javalab.board.service.MemberService;
import com.javalab.board.vo.BoardVo;
import com.javalab.board.vo.MemberVo;
import com.javalab.board.vo.ResponseVo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member") // 클래스 차원의 RequestMapping
@RequiredArgsConstructor
@Slf4j
public class MemberController {
    private final MemberService memberService;

    /**
     * 회원 목록 조회
     * - @GetMapping : @RequestMapping + get요청
     */
    //@RequestMapping(value = "/member/list", method = RequestMethod.GET)
    @GetMapping("/list")
    public String listMembers(Model model) {
        List<MemberVo> memberList = memberService.getMemberList();
        model.addAttribute("memberList", memberList);
        return "member/memberList"; // JSP 이름
    }

    /**
     * 회원 상세 보기
     * @RequestParam : 클라이언트에서 전달된 파라미터를 추출
     */
    @GetMapping("/view")
    public String viewMember(@RequestParam("memberId") String memberId, Model model) {
        MemberVo member = memberService.getMember(memberId);
        model.addAttribute("member", member);
        return "member/memberView"; // JSP 이름
    }

    /**
     * 회원 등록 폼
     */
    @GetMapping("/insert")
    public String insertMemberForm(Model model) {
        model.addAttribute("member", new MemberVo()); // 빈 객체를 모델에 추가
        return "member/memberInsert"; // JSP 이름
    }

    /**
     * 회원 등록 처리
     * @PostMapping : @RequestMapping + post요청
     * 1. MemberVo memberVo : 화면의 회원정보를 MemberVo객체로 자동 바인딩됨.
     * 2. 자동으로 바인딩된 객체는 다시 회원 등록 페이지로 자동 전달.
     * 3. @ModelAttribute("member") : 폼 데이터를 MemberVo 바인딩 한 후에 다시 회원가입 페이지로
     *    이동할 때 이동하는 객체의 이름을 "member"로 지정한다. 그러면 jsp에서는 member꺼내 쓰면 된다.
     * 4. @ModelAttribute("member")를 사용하지 않으면 MemberVo -> memberVo 이름으로 전달된다.   
     */
    @PostMapping("/insert")
    public String insertMember(@ModelAttribute("member") MemberVo memberVo, Model model) {
        log.info("insertMember ==============");
        
        try {
            // 아이디 중복 확인
            if (memberService.isMemberIdDuplicated(memberVo.getMemberId())) {
                model.addAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
                return "member/memberInsert"; // 입력 화면으로 돌아감
            }
            memberService.insertMember(memberVo);
            return "redirect:/member/list";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "회원 등록 중 오류가 발생했습니다.");
            return "member/memberInsert"; // 입력 화면으로 돌아감
        }
    }



    /**
     * 회원 수정 폼
     * @RequestParam : 회원 ID를 받아 기존 데이터 조회
     */
    @GetMapping("/update")
    public String updateMemberForm(@RequestParam("memberId") String memberId, Model model) {
        MemberVo member = memberService.getMember(memberId);
        model.addAttribute("member", member);
        return "member/memberUpdate"; // JSP 이름
    }

    /**
     * 회원 수정 처리
     * @ModelAttribute : 폼 데이터를 MemberVo 객체로 매핑
     * 잘못 입력된 경우 기존 입력 데이터를 유지
     */
    @PostMapping("/update")
    public String updateMember(@ModelAttribute("member") MemberVo memberVo, Model model) {
        try {
            memberService.updateMember(memberVo);
            return "redirect:/member/list"; // 성공 시 회원 목록을 보여주는 메소드 호출
        } catch (Exception e) {
            model.addAttribute("errorMessage", "회원 수정 중 오류가 발생했습니다.");
            return "member/memberUpdate"; // 오류 발생 시 수정 폼으로 다시 이동
        }
    }

    /**
     * 회원 삭제
     * @RequestParam : 회원 ID를 받아 삭제 처리
     */
    @PostMapping("/delete")
    public String deleteMember(@RequestParam("memberId") String memberId, Model model) {
        try {
            memberService.deleteMember(memberId);
            return "redirect:/member/list"; // 성공 시 회원 목록 페이지로 이동
        } catch (Exception e) {
            try {
                // 오류 메시지를 URL에 포함시키기 위해 인코딩
                String errorMessage = URLEncoder.encode("회원 삭제 중 오류가 발생했습니다: ", StandardCharsets.UTF_8.toString());
                return "redirect:/member/view?memberId=" + memberId + "&errorMessage=" + errorMessage;
            } catch (Exception encodingException) {
                // 인코딩 실패 시 기본 오류 메시지 처리
                return "redirect:/member/view?memberId=" + memberId + "&errorMessage=Unknown%20error";
            }
        }
    }
    /**
     * 아이디 중복 확인
     * ResponseEntity : 서버의 처리 상태코드와 전달하려는 데이터를 함께 담아서 보낼 수 있다.
     * @param memberId
     * @return
     */
    @GetMapping("/checkId")
    public ResponseEntity<ResponseVo> checkId(@RequestParam("memberId") String memberId) {
        // 중복 여부를 확인하는 비즈니스 로직 호출
        boolean isDuplicate = memberService.isMemberIdDuplicated(memberId);
        String message = isDuplicate ? "이미 사용 중인 아이디입니다." : "사용 가능한 아이디입니다."; // 삼항연산자 사용

        // ResponseVo 객체 생성
        ResponseVo responseVo = new ResponseVo(isDuplicate, message);

        //HttpStatus status = HttpStatus.OK;
        //ResponseEntity<BoardVo> responseEntity = ResponseEntity.status(status).body(responseVo);
        
        // ResponseEntity로 응답 반환 ok() : 응답상태코드 : 200, body 부분에 자동으로 responseVo 담긴다.
        return ResponseEntity.ok(responseVo); // HttpStatus.OK는 기본값
    }

}
