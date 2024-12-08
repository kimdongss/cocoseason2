package com.javalab.board.repository;

import java.util.List;
import com.javalab.board.vo.OrderVo;

/**
 * 주문 매퍼 인터페이스
 * - 주문 관련 데이터베이스 작업을 정의합니다.
 */
public interface OrderRepository {
    void insertOrder(OrderVo order); // 주문 추가
    List<OrderVo> selectAllOrders(); // 모든 주문 조회
    List<OrderVo> selectOrdersByMember(String memberId); // 특정 회원의 주문 조회
}