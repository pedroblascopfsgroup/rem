package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Modelo que gestiona la información comercial específica de los activos de
 * tipo local comercial.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_LCO_LOCAL_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name = "ICO_ID")
public class ActivoLocalComercial extends ActivoInfoComercial implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Column(name = "LCO_MTS_FACHADA_PPAL")
	private Float mtsFachadaPpal;

	@Column(name = "LCO_MTS_FACHADA_LAT")
	private Float mtsFachadaLat;

	@Column(name = "LCO_MTS_LUZ_LIBRE")
	private Float mtsLuzLibre;

	@Column(name = "LCO_MTS_ALTURA_LIBRE")
	private Float mtsAlturaLibre;

	@Column(name = "LCO_MTS_LINEALES_PROF")
	private Float mtsLinealesProf;

	@Column(name = "LCO_DIAFANO")
	private Integer diafano;

	@Column(name = "LCO_USO_IDONEO")
	private String usuIdoneo;

	@Column(name = "LCO_USO_ANTERIOR")
	private String usuAnterior;

	@Column(name = "LCO_OBSERVACIONES")
	private String observaciones;

	@Column(name = "LCO_SALIDA_HUMOS")
	private Integer existeSalidaHumos;
	
	@Column(name = "LCO_SALIDA_EMERGENCIA")
	private Integer existeSalidaEmergencias;
	
	@Column(name = "LCO_ACCESO_MINUSVALIDOS")
	private Integer existeAccesoMinusvalidos;
	
	@Column(name = "LCO_OTROS_OTRAS_CARACT")
	private String otrosOtrasCaracteristicas;
	
	@Column(name = "LCO_NUMERO_ESTANCIAS")
	private Integer comercialNumEstancias;
	
	@Column(name = "LCO_NUMERO_BANYOS")
	private Integer comercialNumBanyos;
	
	@Column(name = "LCO_NUMERO_ASEOS")
	private Integer comercialNumAseos;

	public Float getMtsFachadaPpal() {
		return mtsFachadaPpal;
	}

	public void setMtsFachadaPpal(Float mtsFachadaPpal) {
		this.mtsFachadaPpal = mtsFachadaPpal;
	}

	public Float getMtsFachadaLat() {
		return mtsFachadaLat;
	}

	public void setMtsFachadaLat(Float mtsFachadaLat) {
		this.mtsFachadaLat = mtsFachadaLat;
	}

	public Float getMtsLuzLibre() {
		return mtsLuzLibre;
	}

	public void setMtsLuzLibre(Float mtsLuzLibre) {
		this.mtsLuzLibre = mtsLuzLibre;
	}

	public Float getMtsAlturaLibre() {
		return mtsAlturaLibre;
	}

	public void setMtsAlturaLibre(Float mtsAlturaLibre) {
		this.mtsAlturaLibre = mtsAlturaLibre;
	}

	public Float getMtsLinealesProf() {
		return mtsLinealesProf;
	}

	public void setMtsLinealesProf(Float mtsLinealesProf) {
		this.mtsLinealesProf = mtsLinealesProf;
	}

	public Integer getDiafano() {
		return diafano;
	}

	public void setDiafano(Integer diafano) {
		this.diafano = diafano;
	}

	public String getUsuIdoneo() {
		return usuIdoneo;
	}

	public void setUsuIdoneo(String usuIdoneo) {
		this.usuIdoneo = usuIdoneo;
	}

	public String getUsuAnterior() {
		return usuAnterior;
	}

	public void setUsuAnterior(String usuAnterior) {
		this.usuAnterior = usuAnterior;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Integer getExisteSalidaHumos() {
		return existeSalidaHumos;
	}

	public void setExisteSalidaHumos(Integer existeSalidaHumos) {
		this.existeSalidaHumos = existeSalidaHumos;
	}

	public Integer getExisteSalidaEmergencias() {
		return existeSalidaEmergencias;
	}

	public void setExisteSalidaEmergencias(Integer existeSalidaEmergencias) {
		this.existeSalidaEmergencias = existeSalidaEmergencias;
	}

	public Integer getExisteAccesoMinusvalidos() {
		return existeAccesoMinusvalidos;
	}

	public void setExisteAccesoMinusvalidos(Integer existeAccesoMinusvalidos) {
		this.existeAccesoMinusvalidos = existeAccesoMinusvalidos;
	}

	public String getOtrosOtrasCaracteristicas() {
		return otrosOtrasCaracteristicas;
	}

	public void setOtrosOtrasCaracteristicas(String otrosOtrasCaracteristicas) {
		this.otrosOtrasCaracteristicas = otrosOtrasCaracteristicas;
	}

	public Integer getComercialNumEstancias() {
		return comercialNumEstancias;
	}

	public void setComercialNumEstancias(Integer comercialNumEstancias) {
		this.comercialNumEstancias = comercialNumEstancias;
	}

	public Integer getComercialNumBanyos() {
		return comercialNumBanyos;
	}

	public void setComercialNumBanyos(Integer comercialNumBanyos) {
		this.comercialNumBanyos = comercialNumBanyos;
	}

	public Integer getComercialNumAseos() {
		return comercialNumAseos;
	}

	public void setComercialNumAseos(Integer comercialNumAseos) {
		this.comercialNumAseos = comercialNumAseos;
	}

}
