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
	 
	 private String idElemento;  
	 
	 private String tipoElemento;
	 
	 private String tipoElementoCodigo;

	 private String referenciaCatastral;
	 
	 private Double participacion;
	 
	 private String tipoActivo;
	 
	 private String direccion;
	 
	 private Double importeProporcinalTotal;
	 
	 private Double importeTotalLinea;
	 
	 private Double importeTotalSujetoLinea;
	 
	 private String carteraBcCodigo;
	 
	 private String carteraBc;
	 
	 private String tipoTransmisionCodigo;
	 
	 private String tipoTransmision;
	 
	 private String grupo;
	 
	 private String tipo;
	 
	 private String subtipo;
	 
	 private String primeraPosesion;
	 
	 private String subpartidaEdifCodigo;
	 
	 private String subpartidaEdif;
	 
	 private String elementoPep;
	 
	 private String promocionCodigo;
	 
	 private String promocion;
	 
	 private String situacionComercialCodigo;
	 
	 private String situacionComercial;

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

	public String getIdElemento() {
		return idElemento;
	}

	public void setIdElemento(String idElemento) {
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

	public Double getImporteTotalSujetoLinea() {
		return importeTotalSujetoLinea;
	}

	public void setImporteTotalSujetoLinea(Double importeTotalSujetoLinea) {
		this.importeTotalSujetoLinea = importeTotalSujetoLinea;
	}

	public String getCarteraBcCodigo() {
		return carteraBcCodigo;
	}

	public void setCarteraBcCodigo(String carteraBcCodigo) {
		this.carteraBcCodigo = carteraBcCodigo;
	}

	public String getCarteraBc() {
		return carteraBc;
	}

	public void setCarteraBc(String carteraBc) {
		this.carteraBc = carteraBc;
	}

	public String getTipoTransmisionCodigo() {
		return tipoTransmisionCodigo;
	}

	public void setTipoTransmisionCodigo(String tipoTransmisionCodigo) {
		this.tipoTransmisionCodigo = tipoTransmisionCodigo;
	}

	public String getTipoTransmision() {
		return tipoTransmision;
	}

	public void setTipoTransmision(String tipoTransmision) {
		this.tipoTransmision = tipoTransmision;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getSubtipo() {
		return subtipo;
	}

	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}

	public String getPrimeraPosesion() {
		return primeraPosesion;
	}

	public void setPrimeraPosesion(String primeraPosesion) {
		this.primeraPosesion = primeraPosesion;
	}

	public String getSubpartidaEdifCodigo() {
		return subpartidaEdifCodigo;
	}

	public void setSubpartidaEdifCodigo(String subpartidaEdifCodigo) {
		this.subpartidaEdifCodigo = subpartidaEdifCodigo;
	}

	public String getSubpartidaEdif() {
		return subpartidaEdif;
	}

	public void setSubpartidaEdif(String subpartidaEdif) {
		this.subpartidaEdif = subpartidaEdif;
	}

	public String getElementoPep() {
		return elementoPep;
	}

	public void setElementoPep(String elementoPep) {
		this.elementoPep = elementoPep;
	}

	public String getPromocionCodigo() {
		return promocionCodigo;
	}

	public void setPromocionCodigo(String promocionCodigo) {
		this.promocionCodigo = promocionCodigo;
	}

	public String getPromocion() {
		return promocion;
	}

	public void setPromocion(String promocion) {
		this.promocion = promocion;
	}

	public String getSituacionComercialCodigo() {
		return situacionComercialCodigo;
	}

	public void setSituacionComercialCodigo(String situacionComercialCodigo) {
		this.situacionComercialCodigo = situacionComercialCodigo;
	}

	public String getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}
	
}
