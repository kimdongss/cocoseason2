package com.javalab.board.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ShoppingCartVo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long spCartId;    // 장바구니 ID
    private String memberId;   // 회원 ID
    private Long productId;    // 상품 ID
    private String productName; // 상품명
    private Double unitPrice;   // 단가
    private Integer quantity;    // 수량
}

