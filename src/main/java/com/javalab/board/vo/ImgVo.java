package com.javalab.board.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 상품 이미지 클래스
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
@ToString
public class ImgVo {
	private Long imgId;			// 상품이미지ID(자동증가)
	private Long productId;		// 상품ID
	private String imgPath;		// 상품이미지 경로
	private String fileName;	// 상품 이미지명
	private int isMain;			// 대표 이미지 여부(0-대표이미지)
}
