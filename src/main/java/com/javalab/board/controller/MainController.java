package com.javalab.board.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javalab.board.dto.Criteria;
import com.javalab.board.dto.PageDto;
import com.javalab.board.vo.BoardVo;
import com.javalab.board.vo.MemberVo;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/home")
@Slf4j
public class MainController {
	
	@GetMapping("/main") 
	public String getListPaging(Criteria cri, Model model, HttpSession session) {
		MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");
		log.info("왔다");
		if(loginUser != null) {
			log.info(loginUser.getName() + "으앵");
		}
		return "home/main"; // jsp 페이지
	}
	
	@PostMapping("/main")
    public String login(String memberId, String password, HttpSession session, Model model) {
        // 로그인 서비스 호출
		MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");

        if (loginUser != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장
            session.setAttribute("oginUser", loginUser);
            return "home/main";
        } else {
            // 로그인 실패 시 에러 메시지와 함께 로그인 폼으로 이동
            model.addAttribute("errorMessage", "아이디 또는 비밀번호가 잘못되었습니다.");
            return "login/login";
        }
    }
}
