package com.javalab.board.service;

import java.util.List;
import com.javalab.board.vo.ShoppingCartVo;

public interface CartService {
   void addToCart(ShoppingCartVo item);
   void removeFromCart(Long spCartId); // 카트 ID로 삭제
   List<ShoppingCartVo> getCartItems(String memberId);
   void clearCart(String memberId);
   List<ShoppingCartVo> getCartItemsForOrder(String memberId); // 장바구니 아이템을 주문을 위해 가져오기
   
   ShoppingCartVo getCartItem(String memberId, Long productId);
   void updateCartItemQuantity(Long spCartId, int quantity);
}