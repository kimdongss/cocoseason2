package com.javalab.board.controller;

import com.javalab.board.service.CartService;
import com.javalab.board.vo.MemberVo;
import com.javalab.board.vo.ShoppingCartVo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/add")
    public String addToCart(@ModelAttribute ShoppingCartVo item) {
        cartService.addToCart(item);
        return "redirect:/cart/view"; // 장바구니 보기 페이지로 리다이렉트
    }

    @GetMapping("/view")
    public String viewCart(Model model, @SessionAttribute("loginUser") MemberVo loginUser) {
        List<ShoppingCartVo> cartItems = cartService.getCartItems(loginUser.getMemberId());
        model.addAttribute("cartItems", cartItems);
        return "cart/cartView";
    }

    @GetMapping("/remove")
    public String removeFromCart(@RequestParam Long spCartId) {
        cartService.removeFromCart(spCartId); 
        return "redirect:/cart/cartView";
    }
}