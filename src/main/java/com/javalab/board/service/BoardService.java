package com.javalab.board.service;

import java.util.List;

import com.javalab.board.dto.Criteria;
import com.javalab.board.vo.BoardVo;

public interface BoardService {
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
	// 게시물 목록 조회(페이징)
	public List<BoardVo> getBoardListPaging(Criteria cri);
	// 게시물 총건수
	public int getTotalBoardCount(Criteria cri);
	// 답글 작성
	public int insertReply(BoardVo boardVo);
}
