package com.javalab.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.javalab.board.repository.CartRepository; // CartRepository로 변경

import com.javalab.board.vo.ShoppingCartVo;

import java.util.List;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartRepository cartRepository; // CartRepository 주입

    @Override
    public void addToCart(ShoppingCartVo item) {
        cartRepository.insertCartItem(item); // 매퍼를 통해 DB에 추가
    }

    @Override
    public void removeFromCart(Long spCartId) {
        cartRepository.deleteCartItem(spCartId); // 매퍼를 통해 DB에서 삭제
    }

    @Override
    public List<ShoppingCartVo> getCartItems(String memberId) {
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
}