package com.javalab.board.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 상품 클래스
 * - Long : 포장클래스, 오라클에 number와 매핑, int보다 더 많은 값을 저장, 
 * 			데이터베이스 값이 없을 경우 널을 저장할 수 있다. 하지만 int, long, double 기본형이기 때문에 
 * 			null 값을 저장할 수 없다. -> Long 포장클래스 사용 이유 
 * 
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ProductVo {
	// 속성, 필드, 멤버변수
	private Long productId;			// 상품ID
	private String name;			// 상품명
	private String description;		// 상품설명
	private Double unitPrice;		// 상품단가
	private Date regDate;			// 상품등록일
}
