package com.javalab.board.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.javalab.board.vo.ImgVo;
import com.javalab.board.vo.ProductVo;
import com.javalab.board.vo.ProductWithImageVo;

/**
 * 상품 매퍼 인터페이스
 * - 서비스 레이어와 매퍼XML을 연결해주는 Bridge 역할
 */
@Mapper
public interface ProductRepository {
	// 상품 정보 등록
	void insertProduct(ProductVo product);
	// 상품 이미지 정보 등록
	void insertImages(List<ImgVo> images);
	// 상품 목록 조회
	List<ProductVo> getAllProducts();
	// 상품 조회
	ProductWithImageVo getProductWithImages(@Param("productId") Long productId);
	
	//ProductVo getPRoductById(@Param("productId") Long productId);
	//List<ImgVo> getImgagesByProductId(@Param("productId") Long productId);
	
    // 상품 수정
    void updateProductWithImages(ProductVo product);
    
    // 상품과 관련된 이미지를 삭제하는 메소드
    void deleteImagesByProductId(Long productId);

    // 상품 삭제
    void deleteProduct(@Param("productId") Long productId);

}

