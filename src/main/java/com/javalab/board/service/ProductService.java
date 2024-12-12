package com.javalab.board.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartFile;

import com.javalab.board.dto.Criteria;
import com.javalab.board.vo.ImgVo;
import com.javalab.board.vo.ProductVo;
import com.javalab.board.vo.ProductWithImageVo;

public interface ProductService {
	// 상품 정보 등록
	void addProduct(ProductVo product);
	// 상품 이미지 정보 등록
	boolean saveProductWithImages(ProductVo product, List<MultipartFile> files, String filePath);
	// 상품 목록 조회
	List<ProductVo> getAllProducts();
	// 상품 조회
	ProductWithImageVo getProductWithImages(@Param("productId") Long productId);
	// 이미지 저장
	void insertImages(List<ImgVo> images);
	
	//ProductVo getPRoductById(@Param("productId") Long productId);
	//List<ImgVo> getImgagesByProductId(@Param("productId") Long productId);
	
    // 상품 수정
    boolean updateProductWithImages(ProductVo product, List<MultipartFile> files, String filePath);
    
    // 상품 삭제
    boolean deleteProduct(@Param("productId") Long productId);
    
    // 게시물 목록 조회(페이징)
  	public List<ProductVo> getProductListPaging(Criteria cri);
  	// 게시물 총건수
  	public int getTotalProductCount(Criteria cri);

}
