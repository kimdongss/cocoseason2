package com.javalab.board.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.javalab.board.dto.Criteria;
import com.javalab.board.repository.ProductRepository;
import com.javalab.board.vo.ImgVo;
import com.javalab.board.vo.ProductVo;
import com.javalab.board.vo.ProductWithImageVo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service // 빈 생성해서 올라감
@Slf4j // 롬복 사용
@RequiredArgsConstructor // 속성을 매개변수로 갖는 생성자 생성
public class ProductServiceImpl implements ProductService {
	// 의존성 주입
	private final ProductRepository productRepository;
	
	@Override
	public void addProduct(ProductVo product) {
		productRepository.insertProduct(product);
	}

	/*
	 * 상품 정보 저장, 관련된 이미지 업로드하여 저장 경로(파일시스템)에 저장한 후 그 정보를 DB에 저장
	 * UUID.randomUUID() : 랜덤한 UUID를 생성하는 메소드로 파일명 중복을 방지하기 위함.
	 * UUID : Universally Unique Identifier, 범용 고유 식별자
	 * 파라미터 product : 저장할 상품 정보 보관 객체
	 * 파라미터 files : 상품의 이미지 파일 리스트
	 * 파라미터 filePath : 파일이 저장될 디렉토리 경로
	 * 반환값 : 상품정보 + 이미지 저장 성공 시 true, 실패시 false 
	 * @Transactional : 상품 정보 저장과 상품 이미지 저장을 하나의 작업단위로 묶어서 모두 성공 또는 모두 실패로 처리
	 * - 만약 실패시 예외가 발생하면 @Transactional 어노테이션이 같은 작업 단위로 묶인 작업을 모두 롤백처리한다.  
	 */
	@Override
	@Transactional
	public boolean saveProductWithImages(ProductVo product, List<MultipartFile> files, String filePath) {
		try {
			
			// 상품 정보를 데이터베이스에 저장
			addProduct(product);
			
			// 저장된 상품의 ID를 가져옴
			Long productId = product.getProductId();
			
			// 날짜 기반으로 파일 저장 경로를 생성
			String uploadFolderPath = getFolder(); // 날짜별 폴더 생성
			String uploadPath = filePath + File.separator + uploadFolderPath; // 전체 파일 경로 생성
			File uploadFilePath = new File(uploadPath); // 파일 경로 객체 생성
			
			// 파일 저장 경로가 존재하지 않으면 디렉토리를 생성
			if (!uploadFilePath.exists()) {
				uploadFilePath.mkdirs(); // 경로에 해당하는 디렉토리를 생성
			}
			
			// 업로드된 파일들을 처리하고 이미지 정보를 생성
			List<ImgVo> imageList = new ArrayList<>(); // 이미지 정보를 담을 리스트 생성
			for (int i = 0; i < files.size(); i++) { // 업로드된 파일 리스트를 순회
				MultipartFile file = files.get(i); // 현재 파일 가져오기
				
				// 파일이 비어있지 않은 경우 처리
				if (!file.isEmpty()) {
					String originalFileName = file.getOriginalFilename(); // 원본 파일명 가져오기
					String uniqueFileName = UUID.randomUUID() + "_" + originalFileName; // 고유한 파일명 생성
					File saveFile = new File(uploadFilePath, uniqueFileName); // 저장할 파일 객체 생성
					
					file.transferTo(saveFile); // 파일을 지정된 경로에 저장
					
					// 이미지 정보를 생성하여 리스트에 추가
					ImgVo img = new ImgVo();
					img.setProductId(productId); // 상품 ID 설정
					img.setImgPath(uploadFolderPath); // 이미지가 저장된 폴더 경로 설정
					img.setFileName(uniqueFileName); // 저장된 파일명 설정
					img.setIsMain(i == 0 ? 1 : 0); // 첫 번째 이미지를 메인 이미지로 설정
					imageList.add(img); // 리스트에 이미지 정보 추가
				}
			}
			
			// 이미지 리스트가 비어있지 않다면 데이터베이스에 이미지 정보 저장
			if (!imageList.isEmpty()) {
				insertImages(imageList); // 이미지 정보를 데이터베이스에 삽입
			}
			// 모든 작업이 성공적으로 완료된 경우 true 반환
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("파일 저장 실패", e); // 트랜잭션 롤백 되도록 런타임 예외 발생해줌!
		}
	}
	
	/*
	 * 날짜 별로 폴더를 생성 메소드 
	 */
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // java.util.Date
		Date date = new Date();
		String str = sdf.format(date); // 날짜를 문자열로 변환
		return str.replace("-", File.separator); // 구분자("-")를 파일 시스템에 맞게 변경, 윈도우즈에서는 e.g) 2021\\07\\01 -> 폴더 경로로 폴더 생성 
	}
	
	/**
	 * 모든 상품 정보를 조회하는 메소드
	 * @return 상품 리스트
	 */
	@Override
	public List<ProductVo> getAllProducts() {
		return productRepository.getAllProducts();
	}

	/**
	 * 특정 상품 정보를 조회하는 메소드
	 * @param productId 조회할 상품 ID
	 * @retrun 상품 정보
	 */
	@Override
	public ProductWithImageVo getProductWithImages(Long productId) {
		ProductWithImageVo productWithImageVo = productRepository.getProductWithImages(productId);
		log.info("서비스 productWithImageVo : " + productWithImageVo);
		return productWithImageVo;
	}

	/**
	 * 이미지 정보를 DB에 저장
	 */
	@Override
	public void insertImages(List<ImgVo> images) {
		productRepository.insertImages(images);
	}
	
	
	
	/**
     * 상품 정보를 수정하고 관련된 이미지를 업데이트하는 메소드.
     * @param product 수정할 상품 정보 (ProductVo 객체)
     * @param files 수정할 이미지 파일 리스트
     * @param filePath 파일이 저장될 디렉토리 경로
     * @return 성공 시 true, 실패 시 false
     */
    @Override
    @Transactional
    public boolean updateProductWithImages(ProductVo product, List<MultipartFile> files, String filePath) {
        try {
            // 상품 정보를 업데이트
            productRepository.updateProductWithImages(product);

            // 이미지 처리 로직은 saveProductWithImages와 유사하게 구현 가능
            Long productId = product.getProductId();
            String uploadFolderPath = getFolder();
            String uploadPath = filePath + File.separator + uploadFolderPath;
            File uploadFilePath = new File(uploadPath);

            if (!uploadFilePath.exists()) {
                uploadFilePath.mkdirs();
            }

            List<ImgVo> imageList = new ArrayList<>();
            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String uniqueFileName = UUID.randomUUID() + "_" + originalFileName;
                    File saveFile = new File(uploadFilePath, uniqueFileName);
                    file.transferTo(saveFile);

                    ImgVo img = new ImgVo();
                    img.setProductId(productId);
                    img.setImgPath(uploadFolderPath);
                    img.setFileName(uniqueFileName);
                    img.setIsMain(i == 0 ? 1 : 0); // 첫 번째 이미지를 메인 이미지로 설정
                    imageList.add(img);
                }
            }

            if (!imageList.isEmpty()) {
                insertImages(imageList); // 새로운 이미지 정보를 데이터베이스에 삽입
            }
            
            return true; // 모든 작업이 성공적으로 완료된 경우 true 반환
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("상품 수정 실패", e); // 트랜잭션 롤백을 위해 런타임 예외 발생
        }
    }

    /**
     * 상품을 삭제하는 메소드.
     * @param productId 삭제할 상품 ID
     * @return 성공 시 true, 실패 시 false
     */
    @Override
    @Transactional
    public boolean deleteProduct(Long productId) {
        try {
        	// 먼저 관련된 이미지 삭제
        	productRepository.deleteImagesByProductId(productId);
        	// 그 다음 상품 삭제
            productRepository.deleteProduct(productId); // 상품 삭제 로직 실행
            
            
            return true; // 성공적으로 삭제된 경우 true 반환
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("상품 삭제 실패", e); // 트랜잭션 롤백을 위해 런타임 예외 발생
        }
    }

	@Override
	public List<ProductVo> getProductListPaging(Criteria cri) {
		List<ProductVo> productlist = productRepository.getProductListPaging(cri);
		return productlist;
	}

	@Override
	public int getTotalProductCount(Criteria cri) {
		return this.productRepository.getTotalProductCount(cri);
	}
    
    
}
