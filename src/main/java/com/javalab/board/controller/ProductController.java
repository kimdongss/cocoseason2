package com.javalab.board.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javalab.board.service.ProductService;
import com.javalab.board.vo.BoardVo;
import com.javalab.board.vo.MemberVo;
import com.javalab.board.vo.ProductVo;
import com.javalab.board.vo.ProductWithImageVo;

import lombok.extern.slf4j.Slf4j;

/**
 * 상품 정보 등록 컨트롤러
 *
 */
@Controller
@RequestMapping("/product")
@Slf4j
public class ProductController {
	
	// 의존성 주입
	private final ProductService productService;
	
	public ProductController(ProductService productService) {
		this.productService = productService;
	}
	
	/*
	 * file.properties 파일에 정의된 파일 저장 경로값 읽어오기
	 * - /config/file.properties 파일에 저장한 값을 읽어온다.
	 */
	@Value("${file.path}") // import org.springframework.beans.factory.annotation.Value;
	private String filePath; // 읽어온 값이 저장되는 변수
	
	/*
	 * 상품 등록 폼
	 */
	@GetMapping("/create")
	public String createForm() {
		return "product/productCreate";
	}
	
	/*
	 * 상품 등록 처리
	 */
	@PostMapping("/create")
	public String handleUpload(ProductVo productVo, 
								@RequestParam("files") ArrayList<MultipartFile> files,
								Model model) {
		log.info("productVo 화면에서 받은 값 : {}", productVo);
		log.info("filepath 화면에서 받은 값 : {}", filePath);
		
		// 서비스 레이어로 파일 업로드 및 상품/이미지 등록 위임
		boolean isUploaded = productService.saveProductWithImages(productVo, files, filePath);
		
		if (!isUploaded) {
			return "uploadFailure";
		}
		return "redirect:/product/list";
	}

	
	/*
	 * 상품 목록 조회
	 */
	@GetMapping("/list")
	public String listProducts(Model model, HttpSession session) {
	    List<ProductVo> productList = productService.getAllProducts();
	    
	    // 세션에서 로그인된 사용자 정보를 가져옴
	    MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");

	    // 로그인된 사용자가 정회원 또는 관리자인지 확인
	    boolean showCartButton = false;
	    if (loginUser != null && (loginUser.getRoleId().equals("member") || loginUser.getRoleId().equals("admin"))) {
	        showCartButton = true;
	    }

	    // 모델에 데이터 추가
	    model.addAttribute("productList", productList);
	    model.addAttribute("showCartButton", showCartButton);  // 장바구니 버튼을 표시할지 여부

	    return "/product/productList";
	}


	
	/*
	 * 상품 내용 보기 
	 * @PathVariable : URL 경로에 있는 값을 파라미터로 받을 때 사용
	 * - {productId} : URL 경로에 있는 productId의 값을 파라미터로 받음
	 * - {PathVariable("productId") : URL 경로에 있는 productId값을 받아서 Long productId에 할당
	 */
	@GetMapping("/detail/{productId}")
	public String productDetail(@PathVariable("productId") Long productId, Model model) {
		// 상품 조회 
		ProductWithImageVo productWithImages = productService.getProductWithImages(productId);
		
		log.info("detail product : " + productWithImages);
		
		model.addAttribute("product", productWithImages);
		return "/product/productDetail";
	}
	
	
	/**
     * 외부 경로에 저장된 이미지를 제공하는 메소드
     * 
     * ResponseEntity를 사용함으로써 응답 정보(헤더, 상태 코드 등)를 더 세밀하게 제어할 수 있다.
     * @param year, @param month, @param day, @param filename
     * 
     * 이 메소드를 통해서 이미지가 화면에 출력되는 순서
     * 1. 화면에서 <img src="/product/upload/2024/07/19/a1d20f23-41e3-40d6-a07d-3eeeb36195cb_bird.jpg"> 와 같이 요청
     * 2. 컨트롤러가 요청을 받아서 전달된 경로 변수들을 파싱하여 파라미터에 값을 세팅한다.
     * 3. 해당 파일의 MIME 타입을 조회함 : Files.probeContentType(resource.getFile().toPath())
     *  - 보통 이미지이면 MIME 타입이 image/로 시작함.
     * 4. 스프링은 이 MIME 타입을 HTTP 응답의 Content-Type 헤더로 설정한다.
     * 5. @ResponseBody를 통해서 웹브라우저의 본문에 바로 제공
     * 6. 브라우저는 이 Content-Type 헤더를 보고 해당 파일을 어떻게 처리할지 결정. 
     *    "image/"로 시작하는 MIME 타입을 받으면, 브라우저는 그 내용을 이미지로 해석하고 표시함. 
     * 7. filename:.+ : 확장자를 포함한 파일명을 받기 위해 정규 표현식을 사용함
     */
    @GetMapping("/upload/{year}/{month}/{day}/{filename:.+}")
    @ResponseBody   // 메소드의 반환값이 직접 응답 본문으로 사용되어야 함을 나타냄.
    public ResponseEntity<Resource> serveFile(@PathVariable("year") String year,
                                              @PathVariable("month") String month,
                                              @PathVariable("day") String day,
                                              @PathVariable("filename") String filename) {
        try {
            String imgPath = year + File.separator + month + File.separator + day;
            // ex) c:\\filetest\\upload\\년\\월\\일\\파일명
            String imagePath = filePath + File.separator + imgPath + File.separator + filename;
            log.info("imagePath : " + imagePath);
            
            // 해당 경로의 이미지를 핸들링할 수 있는 객체 생성
            FileSystemResource resource = new FileSystemResource(imagePath);

            if (!resource.exists()) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }

            HttpHeaders headers = new HttpHeaders();
            // Files.probeContentType을 사용하여 파일의 MIME 타입을 결정. 이 MIME 타입을 응답 헤더의 Content-Type으로 설정함.
            // 웹브라우저가 해당 MIME 타입을 인식해서 웹브라우저에 해당 이미지를 렌더링한다. 
            // MIME 타입이 브라우저에서 직접 표시되지 않는 경우 파일을 다운로드 합니다.
            headers.add(HttpHeaders.CONTENT_TYPE, Files.probeContentType(resource.getFile().toPath()));
            
            // 브라우저는 받은 응답의 Content-Type 헤더를 확인하고, 이를 이미지로 인식하게되며 응답 본문의 데이터를 이미지로 디코딩하여 화면에 표시한다.
            return new ResponseEntity<>(resource, headers, HttpStatus.OK);
        } catch (IOException e) {
            log.error("Error while serving image file: " + filename, e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
    
	/*
	 * 게시물 수정 폼 보기 메소드
	 * - 게시물 번호를 받아서 해당 게시물의 정보를 조회해서 수정 폼으로 이동
	 */
	@GetMapping("/update")
	   public String updateProductForm(@RequestParam("productId") Long productId, 
	                                  @ModelAttribute("product") ProductVo productVo, 
	                                  Model model, HttpSession session,
	                                  RedirectAttributes redirectAttributes) {

		
		// 세션에서 로그인 사용자 정보 가져오기
//		MemberVo loginUser = (MemberVo) session.getAttribute("loginUser");
		
		// 로그인 사용자가 없을 경우[인터셉터에서 처리]
		// 로그인 사용자가 없을 경우[인터셉터에서 처리]
	       //if (loginUser == null) {
	       //    redirectAttributes.addFlashAttribute("errorMessage", "로그인 후 이용해주세요.");
	       //    return "redirect:/login"; // 로그인 페이지로 리다이렉트
	       //}

		
		// 게시물 조회 
		ProductWithImageVo  existingProduct = productService.getProductWithImages(productId);
		
//		// 게시물이 없거나 작성자와 로그인한 사용자가 다를 경우
//		 if (existingProduct == null || !existingProduct.getMemberId().equals(loginUser.getMemberId())) {
//	           redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
//	           return "redirect:/product/view?productId=" + productId; // 게시물 상세 보기로 이동
//	       }
        if (existingProduct == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정할 상품이 존재하지 않습니다.");
            return "redirect:/product/list";
        }

		
		// 수정폼에 보여줄 게시물 조회 최초로 수정폼을 열었을경우
//		 if (productVo.getName() == null) { // 기존 입력값이 없으면 DB에서 조회 : 게시물이 최초로 열린다는 뜻
//			 productVo = existingProduct;  // 수정할 게시물 정보를 기존 게시물로 설정
//			 model.addAttribute("product", productVo); // 모델에 저장
//		    }
        
    	// 모델에 상품 정보 저장
        model.addAttribute("product", existingProduct);
		// 수정폼(화면)으로 이동
		 return "product/productUpdate";

	}

	/*
     * 상품 수정 처리
     */
    @PostMapping("/update")
    public String updateProduct(@ModelAttribute ProductVo productVo,
                                @RequestParam("files") ArrayList<MultipartFile> files,
                                RedirectAttributes redirectAttributes) {
        try {
            // 상품 정보 업데이트 및 새 이미지 저장
            boolean isUpdated = productService.updateProductWithImages(productVo, files, filePath);
            if (isUpdated) {
                redirectAttributes.addFlashAttribute("successMessage", "상품이 성공적으로 수정되었습니다.");
                return "redirect:/product/detail/" + productVo.getProductId();
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "상품 수정에 실패했습니다.");
                return "redirect:/product/update?productId=" + productVo.getProductId();
            }
        } catch (Exception e) {
            log.error("상품 수정 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("errorMessage", "상품 수정 중 오류가 발생했습니다.");
            return "redirect:/product/update?productId=" + productVo.getProductId();
        }
    }

    /*
     * 상품 삭제 메소드
     */
    @PostMapping("/delete")
    public String deleteProduct(@RequestParam("productId") Long productId,
                                RedirectAttributes redirectAttributes) {
        try {
            boolean isDeleted = productService.deleteProduct(productId);
            if (isDeleted) {
                redirectAttributes.addFlashAttribute("successMessage", "상품이 성공적으로 삭제되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "상품 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            log.error("상품 삭제 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("errorMessage", "상품 삭제 중 오류가 발생했습니다.");
        }
        return "redirect:/product/list";
    }
}	

