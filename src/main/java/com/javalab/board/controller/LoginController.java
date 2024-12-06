package com.javalab.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.javalab.board.service.LoginService;
import com.javalab.board.vo.MemberVo;

@Controller
public class LoginController {

    @Autowired
    private LoginService loginService;

    // 로그인 화면 이동
    @GetMapping("/login")
    public String loginForm(HttpSession session) {
        // 세션에서 로그인 정보 확인
        MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");

        if (loginUser != null) {
            // 이미 로그인된 경우 게시물 목록 페이지로 이동
            return "redirect:/board/list";
        }

        // 로그인 폼으로 이동
        return "login/login";
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(String memberId, String password, HttpSession session, Model model) {
        // 로그인 서비스 호출
        MemberVo loginUser = loginService.checkLogin(memberId, password);

        if (loginUser != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장
            session.setAttribute("loginUser", loginUser);
            return "redirect:/board/list";
        } else {
            // 로그인 실패 시 에러 메시지와 함께 로그인 폼으로 이동
            model.addAttribute("errorMessage", "아이디 또는 비밀번호가 잘못되었습니다.");
            return "login/login";
        }
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 초기화
        return "redirect:/login"; // 로그인 페이지로 이동
    }
}
