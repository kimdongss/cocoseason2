package com.javalab.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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

        for (ShoppingCartVo cartItem : cartItems) {
            OrderVo order = new OrderVo();
            order.setProductId(cartItem.getProductId());
            order.setMemberId(loginUser.getMemberId());
            order.setProductName(cartItem.getProductName());
            order.setUnitPrice(cartItem.getUnitPrice());
            order.setQuantity(cartItem.getQuantity());
            order.setAddress(loginUser.getAddress());
            order.setPhone(loginUser.getPhone());
            
            orderService.placeOrder(order);
        }

        return "redirect:/order/my-orders";
    }

	/*
	 * @GetMapping("/list") public String listOrders(Model model) {
	 * model.addAttribute("orderList", orderService.getAllOrders()); // 모든 주문 가져오기
	 * (서비스 메소드 구현 필요) return "admin/orderList"; // JSP 경로로 변경 필요 }
	 */
    
    @GetMapping("/my-orders")
    public String myOrders(Model model, @SessionAttribute("loginUser") MemberVo loginUser) {
        List<OrderVo> myOrders = orderService.getOrdersByMember(loginUser.getMemberId());
        model.addAttribute("orderList", myOrders);
        return "order/orderList";
    }
    
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteOrder(@RequestParam Long orderId) {
        Map<String, Object> response = new HashMap<>();
        try {
            orderService.deleteOrder(orderId); // 서비스 호출하여 주문 삭제
            response.put("status", "success"); // 성공 상태 반환
        } catch (Exception e) {
            response.put("status", "error"); // 오류 상태 반환
            response.put("message", e.getMessage()); // 오류 메시지 반환
        }
        return ResponseEntity.ok(response); // 응답 반환
    }
    
    @GetMapping("/admin")
    public String adminOrders(Model model) {
        List<OrderVo> allOrders = orderService.getAllOrders();
        model.addAttribute("orderList", allOrders);
        return "order/adminOrder"; 
    }
    
    @PostMapping("/updateQuantity")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQuantity(@RequestParam Long orderId, @RequestParam int quantity) {
        Map<String, Object> response = new HashMap<>();
        try {
            orderService.updateOrderQuantity(orderId, quantity); // 서비스 호출하여 주문 수량 업데이트
            response.put("status", "success"); // 성공 상태 반환
        } catch (Exception e) {
            response.put("status", "error"); // 오류 상태 반환
            response.put("message", e.getMessage()); // 오류 메시지 반환
        }
        return ResponseEntity.ok(response); // 응답 반환
    }
}