package com.javalab.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.javalab.board.repository.OrderRepository; // OrderRepository로 변경
import com.javalab.board.vo.OrderVo;
import com.javalab.board.vo.ShoppingCartVo;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private CartService cartService; // CartService 주입
  
	@Autowired
	private OrderRepository orderRepository; // OrderRepository 주입
	
	@Override
	public void placeOrder(OrderVo order) {
	orderRepository.insertOrder(order); // 매퍼를 통해 DB에 추가
	
	// 장바구니에서 해당 상품 제거 로직 추가 필요 
	cartService.clearCart(order.getMemberId()); // 장바구니에서 상품 제거 
	}
	
	@Override
	public List<OrderVo> getAllOrders() {
	    return orderRepository.selectAllOrders(); // 모든 주문 반환 
	}
	
	@Override
	public List<OrderVo> getOrdersByMember(String memberId) {
	    return orderRepository.selectOrdersByMember(memberId); // 특정 회원의 주문 반환 
   }
	
	@Override
    public List<ShoppingCartVo> getCartItemsForOrder(String memberId) {
        return cartService.getCartItems(memberId); // CartService에서 장바구니 아이템을 가져옵니다.
    }
	
	@Override
	public void deleteOrder(Long orderId) {
	    orderRepository.deleteOrder(orderId); // 레포지토리 호출하여 주문 삭제
	}
	
    @Override
    public void updateOrderQuantity(Long orderId, int quantity) {
    	orderRepository.updateOrderQuantity(orderId, quantity);  // DB에서 수량 업데이트
    }

	@Override
	public OrderVo getAllOrders(String memberId, Long productId) {
		// TODO Auto-generated method stub
		return null;
	}
}
