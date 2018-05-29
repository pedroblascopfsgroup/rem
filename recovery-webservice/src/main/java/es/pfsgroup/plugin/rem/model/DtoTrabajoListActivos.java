package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * 
 * Dto para el listado de activos al crear una agrupación
 * @author Daniel Gutiérrez
 */

public class DtoTrabajoListActivos extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String idActivo;
	private String numActivoRem;
	private String numActivoHaya;
	private String tipoActivo;
	private String subtipoActivo;
	private String cartera;
	private String situacionComercial;
	private String situacionPosesoria;
	private String numFincaRegistral;
	private String tienePerimetroGestion;
	private String codigoPromocionPrinex;
	
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public String getNumActivoHaya() {
		return numActivoHaya;
	}
	public void setNumActivoHaya(String numActivoHaya) {
		this.numActivoHaya = numActivoHaya;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}
	public String getSubtipoActivo() {
		return subtipoActivo;
	}
	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getSituacionComercial() {
		return situacionComercial;
	}
	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}
	public String getSituacionPosesoria() {
		return situacionPosesoria;
	}
	public void setSituacionPosesoria(String situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}
	public String getNumFincaRegistral() {
		return numFincaRegistral;
	}
	public void setNumFincaRegistral(String numFincaRegistral) {
		this.numFincaRegistral = numFincaRegistral;
	}
	public String getTienePerimetroGestion() {
		return tienePerimetroGestion;
	}
	public void setTienePerimetroGestion(String tienePerimetroGestion) {
		this.tienePerimetroGestion = tienePerimetroGestion;
	}
	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}
	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}
	
}