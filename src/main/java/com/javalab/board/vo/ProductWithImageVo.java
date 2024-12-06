package com.javalab.board.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 상품 정보와 이미지 정보를 함께 담는 클래스
 * - 상품정보(ProductVo)와 이미지 정보(ImgVo)를 조인한 결과를 담는 클래스
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter 
@Setter
@ToString
public class ProductWithImageVo {
	// 속성, 필드, 멤버변수
	private Long productId;			// 상품ID
	private String name;			// 상품명
	private String description;		// 상품설명
	private Double unitPrice;		// 상품단가
	private Date regDate;			// 상품등록일
	private String imgPath;			// 대표 이미지 경로
	private String fileName;		// 대표 이미지명
	private List<ImgVo> imgList;	// 한 상품의 여러개 이미지
}
