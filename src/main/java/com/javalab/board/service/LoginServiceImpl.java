package com.javalab.board.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javalab.board.repository.LoginRepository;
import com.javalab.board.vo.MemberVo;

@Service
public class LoginServiceImpl implements LoginService{

    @Autowired
    private LoginRepository loginRepository;

    // 사용자 로그인 확인
    public MemberVo checkLogin(String memberId, String password) {
        return loginRepository.checkLogin(memberId, password);
    }
}
