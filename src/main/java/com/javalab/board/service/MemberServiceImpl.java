package com.javalab.board.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.javalab.board.repository.MemberRepository;
import com.javalab.board.vo.MemberVo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
    private final MemberRepository repository;

    @Override
    public List<MemberVo> getMemberList() {
        return repository.getMemberList();
    }

    @Override
    public MemberVo getMember(String memberId) {
        return repository.getMember(memberId);
    }

    /**
     * 회원 아이디 중복 여부 확인
     * @param memberId 중복 체크할 회원 ID
     * @return 중복 여부 (true: 중복, false: 중복 아님)
     */
    public boolean isMemberIdDuplicated(String memberId) {
        int result = repository.existsById(memberId); // 결과는 1(중복) 또는 0(중복아님)
        boolean isExist = result > 0 ? true : false; // 삼항 연산자로 변환 1/0을 true(중복)/false(중복아님)로 변환
        return isExist;
    }

    
    @Override
    public int insertMember(MemberVo memberVo) {
        return repository.insertMember(memberVo);
    }

    @Override
    public int updateMember(MemberVo memberVo) {
        return repository.updateMember(memberVo);
    }

    @Override
    public int deleteMember(String memberId) {
        return repository.deleteMember(memberId);
    }
}
