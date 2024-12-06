package com.javalab.board.service;

import java.util.List;

import com.javalab.board.vo.MemberVo;

/**
 * 멤버 서비스 인터페이스
 * - 컨트롤러와 매퍼 사이에서 요청을 처리하는 인터페이스
 * - 매퍼의 기능을 서비스 계층에서 사용할 수 있도록 메서드를 정의한다.
 * - 비즈니스 로직을 처리하고 트랜잭션 처리와 같은 기능을 제공한다.
 */
public interface MemberService {
    List<MemberVo> getMemberList();
    MemberVo getMember(String memberId);
    int insertMember(MemberVo memberVo);
    int updateMember(MemberVo memberVo);
    int deleteMember(String memberId);
    boolean isMemberIdDuplicated(String memberId);
}
