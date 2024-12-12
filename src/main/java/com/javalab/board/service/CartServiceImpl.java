package com.javalab.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.javalab.board.repository.CartRepository;
import com.javalab.board.vo.ShoppingCartVo;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartRepository cartRepository; // CartRepository 주입
    
    private static final Logger logger = LoggerFactory.getLogger(CartServiceImpl.class);

    @Override
    public void addToCart(ShoppingCartVo item) {
        ShoppingCartVo existingItem = getCartItem(item.getMemberId(), item.getProductId());
        if (existingItem != null) {
            // 수량이 증가하는 로직
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
            // 기존 아이템의 spCartId 사용
            updateCartItemQuantity(existingItem.getSpCartId(), existingItem.getQuantity());
        } else {
            // 상품이 장바구니에 없으면 새로 추가
            cartRepository.insertCartItem(item);
        }
    }


    @Override
    public void removeFromCart(Long spCartId) {
        cartRepository.deleteCartItem(spCartId); // 매퍼를 통해 DB에서 삭제
    }

    @Override
    public List<ShoppingCartVo> getCartItems(String memberId) {
        if (memberId == null) {
            throw new IllegalArgumentException("Member ID cannot be null");
        }
        return cartRepository.selectCartItems(memberId); // 매퍼를 통해 DB에서 조회
    }
    @Override
    public void clearCart(String memberId) {
        cartRepository.clearCart(memberId); // 매퍼를 통해 DB에서 비우기
    }
    
    public List<ShoppingCartVo> getCartItemsForOrder(String memberId) {
        // 장바구니 항목을 가져옵니다.
        return cartRepository.selectCartItems(memberId);
    }
    
    @Override
    public ShoppingCartVo getCartItem(String memberId, Long productId) {
        return cartRepository.selectCartItem(memberId, productId);
    }

    @Override
    public void updateCartItemQuantity(Long spCartId, int quantity) {
        cartRepository.updateCartItemQuantity(spCartId, quantity);  // DB에서 수량 업데이트
    }

  
    
}