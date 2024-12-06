package com.javalab.board.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


/**
 * 게시물 자바 빈즈 클래스
 * - 롬복 적용
 */
@NoArgsConstructor	// 매개변수가 없는 생성자를 자동 생성
@AllArgsConstructor	// 모든 필드를 매개변수로 갖는 생성자 자동 생성
@Getter @Setter	// 게터/세터 메소드를 자동 생성
@ToString		// toString() 메소드 자동 생성
public class BoardVo implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int boardNo;			// 게시물번호	
	private String title;		// 게시물 제목
	private String content;		// 게시물 내용
	private String memberId;	// 게시물 작성자ID
	private int hitNo;			// 조회수
	private Date regDate ;		// 게시물 작성일자	
	/* 계층형 답변 게시판용 속성 */
	private int replyGroup;		// 그룹번호(본글과 답글을 묶어주는 역할) 
	private int replyOrder;		// 그룹내순서(그룹 내에서의 순서를 결정) 
	private int replyIndent;	// 들여쓰기(본글을 기준으로 depth가 내려갈 때마다 한칸씩 들여씀)
}
