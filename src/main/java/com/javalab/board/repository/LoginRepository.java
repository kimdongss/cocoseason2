package com.javalab.board.repository;


import org.apache.ibatis.annotations.Param;

import com.javalab.board.vo.MemberVo;

public interface LoginRepository {

    // 사용자 아이디와 비밀번호로 사용자 조회
    MemberVo checkLogin(@Param("memberId") String memberId, @Param("password") String password);
}
