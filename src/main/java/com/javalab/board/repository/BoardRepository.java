package com.javalab.board.repository;

import java.util.List;

import com.javalab.board.dto.Criteria;
import com.javalab.board.vo.BoardVo;

/**
 * 게시판 Repository 매퍼 인터페이스
 * - 매퍼 인터페이스는 마이바티스에서 인터페이스의 메소드와 매퍼XML의 쿼리문을 연결하는 역할을 한다.
 * - 서비스 레이어의 구현체인 BoardServiceImpl로 매퍼 인터페이스 타입이 의존성 주입된다.
 *   하지만 실제로 주입되는 객체는 동적으로 만들어지는 "매퍼 프록시 객체" 빈이다.
 *   이렇게 되면 BoardServiceImpl에서 BoardRepository 인터페이스의 메소드를 호출하면
 *   매퍼 프록시 객체가 그 요청을 매퍼XML의 쿼리문으로 매핑한다.
 * [조건]
 * 1. 매퍼 인터페이스의 메소드명과 매퍼XML의 쿼리메소드 이름은 동일해야 한다.
 * 2. 메소드의 매개변수 타입은 매퍼XML의 parmeterType과 동일해야 한다.
 * 3. 메소드의 반환타입은 매퍼XML 파일의 쿼리문이 반환하는 타입과 동일해야 한다.  
 * 4. 메소드의 반환타입이 List<BoardVo> 매퍼XML의 resultType에는 BoardVo로 해야 한다.
 */
public interface BoardRepository {
	// 게시물 목록 조회
	public List<BoardVo> getBoardList();
	// 게시물 내용 조회
	public BoardVo getBoard(int boardNo);
	// 게시물 저장(등록)
	public int insertBoard(BoardVo boardVo);
	// 게시물 수정
	public int updateBoard(BoardVo boardVo);
	// 게시물 삭제
	public int deleteBoard(int boardNo);
	// 게시물 조회수 증가
	void increaseHitNo(int boardNo);
	// 게시물 목록 조회(페이징)
	public List<BoardVo> getBoardListPaging(Criteria cri);
	// 게시물 총건수
	public int getTotalBoardCount(Criteria cri);
	// 답글 작성
	public int insertReply(BoardVo boardVo);
	// 답글 작성시 사전작업
	public int updateReplyOrder(BoardVo boardVo);
	
}
