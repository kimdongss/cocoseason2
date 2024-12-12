package com.javalab.board.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.javalab.board.vo.OrderVo;

/**
 * 주문 매퍼 인터페이스
 * - 주문 관련 데이터베이스 작업을 정의합니다.
 */
public interface OrderRepository {
	
	
    void insertOrder(OrderVo order); // 주문 추가
    
    List<OrderVo> selectAllOrders(); // 모든 주문 조회
    List<OrderVo> selectOrdersByMember(String memberId); // 특정 회원의 주문 조회
    void deleteOrder(Long orderId);
    
    // 주문에서 수량변경 안하기로함 비즈로직상 하면안됨 원래 대부분 쇼핑몰이 전체 취소 후 재 주문임 
    void updateOrderQuantity(
    		@Param("spCartId") Long spCartId, 
    		@Param("quantity") int quantity);
}