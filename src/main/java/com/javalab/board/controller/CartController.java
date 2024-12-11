package com.javalab.board.controller;

import com.javalab.board.service.CartService;
import com.javalab.board.vo.MemberVo;
import com.javalab.board.vo.ShoppingCartVo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/add")
    public String addToCart(@ModelAttribute ShoppingCartVo item, @SessionAttribute(value = "loginUser", required = false) MemberVo loginUser) {
        if (loginUser == null) {
            return "redirect:/login"; // 로그인하지 않았으면 로그인 페이지로 리다이렉트
        }
        item.setMemberId(loginUser.getMemberId()); // 로그인한 사용자 아이디 설정
        cartService.addToCart(item);  // 장바구니에 추가
        return "redirect:/cart/view"; // 장바구니 페이지로 리다이렉트
    }

    @GetMapping("/view")
    public String viewCart(Model model, @SessionAttribute(value = "loginUser", required = false) MemberVo loginUser) {
        if (loginUser == null) {
            return "redirect:/login"; // 로그인 페이지로 리다이렉트
        }
        
        List<ShoppingCartVo> cartItems = cartService.getCartItems(loginUser.getMemberId());
        model.addAttribute("cartItems", cartItems);
        
        return "cart/cartView"; // JSP 페이지로 이동
    }
    
    
    @GetMapping("/remove")
    public String removeFromCart(@RequestParam Long spCartId) {
        cartService.removeFromCart(spCartId); 
        return "redirect:/cart/view";
    }
    
    @PostMapping("/update")
    public String updateCartItemQuantity(@RequestParam("spCartId") Long spCartId,
                                          @RequestParam("quantity") int quantity,
                                          @SessionAttribute(value = "loginUser", required = false) MemberVo loginUser) {
        if (loginUser == null) {
            return "redirect:/login"; // 로그인하지 않았으면 로그인 페이지로 리다이렉트
        }

        cartService.updateCartItemQuantity(spCartId, quantity);  // 장바구니 수량 업데이트
        return "redirect:/cart/view";  // 장바구니 페이지로 리다이렉트
    }
    
    
 // 장바구니 수량 업데이트
    @PostMapping("/updateQuantity")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQuantity(@RequestParam("spCartId") Long spCartId, 
                                                               @RequestParam("quantity") int quantity) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 수량 업데이트 서비스 호출
            cartService.updateCartItemQuantity(spCartId, quantity);

            // 성공적인 응답
            response.put("status", "success");
        } catch (Exception e) {
            // 실패한 경우
            response.put("status", "error");
            response.put("message", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }
}