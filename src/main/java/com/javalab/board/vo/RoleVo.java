package com.javalab.board.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

/**
 * 권한 관련 클래스 
 *
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
@ToString
public class RoleVo {
	private String roleId;
	private String roleName;

}
