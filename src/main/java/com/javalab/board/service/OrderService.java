package com.javalab.board.service;

import java.util.List;
import com.javalab.board.vo.OrderVo;
import com.javalab.board.vo.ShoppingCartVo;

public interface OrderService {
   void placeOrder(OrderVo order);
   List<OrderVo> getAllOrders(); // 관리자용: 모든 주문 조회 
   List<OrderVo> getOrdersByMember(String memberId); // 회원별 주문 조회 
   List<ShoppingCartVo> getCartItemsForOrder(String memberId); // 장바구니 아이템을 주문을 위해 가져오기
}