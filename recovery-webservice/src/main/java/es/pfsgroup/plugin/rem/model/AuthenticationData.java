package es.pfsgroup.plugin.rem.model;

import java.util.List;

public class AuthenticationData {
	
	private String userName;	
	
	private Long userId;
	
	private List<String> authorities;
	
	private List<String> roles;
	
	private String codigoGestor;
	
	private Integer esGestorSustituto;
	

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public List<String> getAuthorities() {
		return authorities;
	}

	public void setAuthorities(List<String> authorities) {
		this.authorities = authorities;
	}

	public List<String> getRoles() {
		return roles;
	}

	public void setRoles(List<String> roles) {
		this.roles = roles;
	}

	public String getCodigoGestor() {
		return codigoGestor;
	}

	public void setCodigoGestor(String codigoGestor) {
		this.codigoGestor = codigoGestor;
	}

	public Integer getEsGestorSustituto() {
		return esGestorSustituto;
	}

	public void setEsGestorSustituto(Integer esGestorSustituto) {
		this.esGestorSustituto = esGestorSustituto;
	}

}
