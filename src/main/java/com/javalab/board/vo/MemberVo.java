package com.javalab.board.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor	// 매개변수가 없는 생성자를 자동 생성
@AllArgsConstructor	// 모든 필드를 매개변수로 갖는 생성자 자동 생성
@Getter @Setter	// 게터/세터 메소드를 자동 생성
@ToString		// toString() 메소드 자동 생성
public class MemberVo {
	private String memberId;
	private String password;
	private String name;
	private String email;
	private Date regDate;	
}
