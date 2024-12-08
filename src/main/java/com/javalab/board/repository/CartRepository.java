package com.javalab.board.repository;

import java.util.List;
import com.javalab.board.vo.ShoppingCartVo;

/**
 * 장바구니 매퍼 인터페이스
 * - 장바구니 관련 데이터베이스 작업을 정의합니다.
 */
public interface CartRepository {
    void insertCartItem(ShoppingCartVo item); // 장바구니 아이템 추가
    void deleteCartItem(Long spCartId); // 장바구니 아이템 삭제
    List<ShoppingCartVo> selectCartItems(String memberId); // 특정 회원의 장바구니 아이템 조회
    void clearCart(String memberId); // 특정 회원의 장바구니 비우기
}