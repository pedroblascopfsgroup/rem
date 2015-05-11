package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroPoliticaDeAcuerdosDto extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 844321113827171223L;
	
	private Long id;
	private String nombre;
	private String codigo;
	private String tipoPalanca;
	private String subTipoPalanca;
	private String estado;
	
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getTipoPalanca() {
		return tipoPalanca;
	}
	public void setTipoPalanca(String tipoPalanca) {
		this.tipoPalanca = tipoPalanca;
	}
	public String getSubTipoPalanca() {
		return subTipoPalanca;
	}
	public void setSubTipoPalanca(String subTipoPalanca) {
		this.subTipoPalanca = subTipoPalanca;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}	

}
