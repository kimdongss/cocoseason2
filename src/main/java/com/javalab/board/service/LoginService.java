package com.javalab.board.service;

import com.javalab.board.vo.MemberVo;

public interface LoginService {
	public MemberVo checkLogin(String memberId, String password);

}
