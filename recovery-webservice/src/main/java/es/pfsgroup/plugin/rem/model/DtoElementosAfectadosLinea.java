package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona los elementos de un gasto
 *  
 * @author Lara Pablo
 */
public class DtoElementosAfectadosLinea extends WebDto {
	

	private static final long serialVersionUID = 1L;
	

	 private Long id;  //Id dl elemento de la gld_ent
	 
	 private Long idLinea;
	 
	 private Long idActivo;
	 
	 private String descripcionLinea;
	
	 private Long idGasto;
	 
	 private Long idElemento;  
	 
	 private String tipoElemento;
	 
	 private String tipoElementoCodigo;

	 private String referenciaCatastral;
	 
	 private Double participacion;
	 
	 private String tipoActivo;
	 
	 private String direccion;
	 
	 private Double importeProporcinalTotal;
	 
	 private Double importeTotalLinea;
	 

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getIdLinea() {
		return idLinea;
	}

	public void setIdLinea(Long idLinea) {
		this.idLinea = idLinea;
	}
	
	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getDescripcionLinea() {
		return descripcionLinea;
	}

	public void setDescripcionLinea(String descripcionLinea) {
		this.descripcionLinea = descripcionLinea;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public Long getIdElemento() {
		return idElemento;
	}

	public void setIdElemento(Long idElemento) {
		this.idElemento = idElemento;
	}

	public String getTipoElemento() {
		return tipoElemento;
	}

	public void setTipoElemento(String tipoElemento) {
		this.tipoElemento = tipoElemento;
	}

	public String getTipoElementoCodigo() {
		return tipoElementoCodigo;
	}

	public void setTipoElementoCodigo(String tipoElementoCodigo) {
		this.tipoElementoCodigo = tipoElementoCodigo;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public Double getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Double participacion) {
		this.participacion = participacion;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Double getImporteProporcinalTotal() {
		return importeProporcinalTotal;
	}

	public void setImporteProporcinalTotal(Double importeProporcinalTotal) {
		this.importeProporcinalTotal = importeProporcinalTotal;
	}

	public Double getImporteTotalLinea() {
		return importeTotalLinea;
	}

	public void setImporteTotalLinea(Double importeTotalLinea) {
		this.importeTotalLinea = importeTotalLinea;
	}
	
	

}
