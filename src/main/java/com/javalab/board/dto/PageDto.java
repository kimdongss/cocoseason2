package com.javalab.board.dto;

import lombok.Getter;
import lombok.ToString;

/**
 * 1. 페이징과 관련해서 조회할 조건에 대한 정보 / PageDto 한 페이지에 보여줄 구체적인 정보(시작페이지번호, 끝페이지번호)보관용 클래스 
 * - Criteria : 요청된 페이지 정보와 한페이지에 보여줄 게시물 수 정보, 검색 키워드 정보
 * 2. 페이지 그룹과 관련된 정보
 * - startPage :  시작 페이지 번호
 * - endPage : 끝 페이지 번호
 * - prev : 이전 페이지 유무
 * - next : 다음 페이지 유무
 * - total : 전체 게시물 수 
 * 
 */
@Getter
@ToString
public class PageDto {

	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	// 오버로딩 생성자
	public PageDto(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		// 페이지 그룹에서 끝 페이지 번호를 계산합니다.
		// 예: 현재 페이지가 1~10이면 (1~10.0) / 10.0 -> 올림(Math.ceil) -> 1, 끝 페이지 번호는 1 * 10 = 10
		// 예: 현재 페이지가 11~20이면 (11~20.0) / 10.0 -> 올림(Math.ceil) -> 2, 끝 페이지 번호는 2 * 10 = 20
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
		// 시작 페이지 번호
		// 한 페이지에 10개의 페이지 그룹을 보여주기 때문에 끝 페이지 번호에서 -9하면 첫 페이지 번호가 나온다.
		this.startPage = this.endPage -9;
		/*
		 * 실제 끝 페이지 번호 계산 (한 페이지에 20개의 게시물을 출력한다고 가정)
		 * - 전체 게시물이 201개라고 가정하면,
		 * 	201 / 20 = 10.05가 되어야 하지만, 자바의 정수 나눗셈은 몫만 취하므로 결과는 10이 됨.
		 * - 이를 방지하기 위해 total에 1.0을 곱해서 실수로 변환한 후 나눗셈을 수행
		 * 	201 * 1.0 / 20 = 10.5가 되고, Math.ceil로 올림 처리하면 결과는 11이 됨.
		 * - 이 계산을 통해 실제 끝 페이지 번호(예: 11)를 정확히 구할 수 있음.
		 */
		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
		// 끝 페이지 번호 보정(다시 계산)
		// 실제 끝 페이지 번호(realEnd)가 규칙에서 정해놓은 그룹의 끝 페이지 번호(endPage)보다 작으면
		// 끝 페이지 번호를 실제 끝 페이지로 보전한다.
		if (realEnd <= this.endPage) {
			this.endPage = realEnd; // 실제 끝페이지 번호가 끝 페이지 번호가 됨.
		}
		// 이전(<)은 시작페이지 번호가 1보다 크면 존재
		// 첫 번째 페이지의 페이지 그룹은 [1 ... 10] 이기 때문에 <가 필요
		// 두 번째 페이지 부터는 페이지 그룹이 [11 ... 20] 이기 때문에 <가 필요
		this.prev = this.startPage > 1;
		// 다음 (>)은 구해둔 끝페이지번호가 실제 끝 페이지 번호보다 작으면 존재
		// 예를들어 실제 끝페이지가 11인데 공식에 의해서 구한 끝 페이지가 10이면 > 가 필요함 
		this.next = this.endPage < realEnd; // 
	}
	
}
