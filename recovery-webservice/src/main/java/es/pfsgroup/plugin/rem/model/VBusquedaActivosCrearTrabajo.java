package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_CREAR_TBJ", schema = "${entity.schema}")
public class VBusquedaActivosCrearTrabajo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="ACT_ID")
	private String idActivo;
	
	@Column(name="ACT_NUM_ACTIVO")
	private String numActivoHaya;
	
	@Column(name="ACT_NUM_ACTIVO_REM")
	private String numActivoRem;
	
	@Column(name="CARTERA")
	private String cartera;
	
	@Column(name="TIPO_ACTIVO")
	private String tipoActivo;
	
	@Column(name="SUBTIPO_ACTIVO")
	private String subtipoActivo;
	
	@Column(name="SITUACION_COMERCIAL")
	private String situacionComercial;
	
	@Column(name="NUM_FINCA_REGISTRAL")
	private String numFincaRegistral;

	@Column(name="PER_GESTION")
	private String tienePerimetroGestion;
	
	@Column(name="IN_PRP_TRAMITACION")
	private Boolean activoEnPropuestaEnTramitacion;
	
	@Column(name="PRO_ID")
	private String propietarioId;
	
	@Column(name = "ACT_COD_PROMOCION_PRINEX")
    private String codigoPromocionPrinex;
	
	@Column(name="CODIGO_CARTERA")
	private String codigoCartera;
	
	@Column(name="ACT_EN_TRAMITE")
	private Boolean activoTramite;

	public String getPropietarioId() {
		return propietarioId;
	}

	public void setPropietarioId(String propietarioId) {
		this.propietarioId = propietarioId;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getNumActivoHaya() {
		return numActivoHaya;
	}

	public void setNumActivoHaya(String numActivoHaya) {
		this.numActivoHaya = numActivoHaya;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
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

	public String getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
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

	public Boolean getActivoEnPropuestaEnTramitacion() {
		return activoEnPropuestaEnTramitacion;
	}

	public void setActivoEnPropuestaEnTramitacion(Boolean activoEnPropuestaEnTramitacion) {
		this.activoEnPropuestaEnTramitacion = activoEnPropuestaEnTramitacion;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public String getCodigoCartera() {
		return codigoCartera;
	}

	public void setCodigoCartera(String codigoCartera) {
		this.codigoCartera = codigoCartera;
	}

	public Boolean getActivoTramite() {
		return activoTramite;
	}

	public void setActivoTramite(Boolean activoTramite) {
		this.activoTramite = activoTramite;
	}
	
	
}
