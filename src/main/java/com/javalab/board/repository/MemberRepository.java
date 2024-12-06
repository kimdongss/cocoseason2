package com.javalab.board.repository;

import java.util.List;

import com.javalab.board.vo.MemberVo;

/**
 * 멤버 매퍼 인터페이스
 * - 멤버 정보를 조회, 추가, 수정, 삭제하는 기능을 제공한다.
 * - 서비스 계층의 요청을 처리하기 위한 메서드를 정의한다.
 * - 런타임에 매퍼XML을 구현한 매퍼 프록시 객체를 생성한다.
 */
public interface MemberRepository {
    // 회원 목록 조회
    List<MemberVo> getMemberList();
    // 회원 조회
    MemberVo getMember(String memberId);
    // 회원 추가
    int insertMember(MemberVo memberVo);
    // 회원 수정
    int updateMember(MemberVo memberVo);
    // 회원 삭제
    int deleteMember(String memberId);
    // 회원 아이디 중복 여부
    int existsById(String memberId);
}
