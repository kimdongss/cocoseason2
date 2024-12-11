package com.javalab.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.javalab.board.service.OrderService;
import com.javalab.board.vo.MemberVo;
import com.javalab.board.vo.OrderVo;
import com.javalab.board.vo.ShoppingCartVo;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping("/place")
    public String placeOrder(Model model, @SessionAttribute("loginUser") MemberVo loginUser) {
        // 사용자의 장바구니 아이템을 가져옵니다.
        List<ShoppingCartVo> cartItems = orderService.getCartItemsForOrder(loginUser.getMemberId());
        
        if (cartItems.isEmpty()) {
            model.addAttribute("error", "장바구니에 상품이 없습니다.");
            return "cart/view"; // 장바구니 페이지로 돌아갑니다.
        }

        model.addAttribute("cartItems", cartItems);
        return "order/orderList"; // 주문 페이지로 이동
    }

    @GetMapping("/list")
    public String listOrders(Model model) {
        model.addAttribute("orderList", orderService.getAllOrders()); // 모든 주문 가져오기 (서비스 메소드 구현 필요)
        return "admin/orderList"; // JSP 경로로 변경 필요 
    }
    
    @GetMapping("/my-orders")
    public String myOrders(Model model, @SessionAttribute("loginUser") String memberId) {
        model.addAttribute("myOrders", orderService.getOrdersByMember(memberId));
        return "member/myOrders"; 
    }
}