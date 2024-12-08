package com.javalab.board.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class OrderVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long orderId;      // 주문 ID
    private Long productId;    // 상품 ID
    private String memberId;   // 회원 ID
    private String productName; // 상품명
    private Double unitPrice;   // 단가
    private Integer quantity;   // 수량
    private String address;     // 배송 주소
    private String phone;       // 전화번호
    private Date orderDate;     // 주문 날짜
}
