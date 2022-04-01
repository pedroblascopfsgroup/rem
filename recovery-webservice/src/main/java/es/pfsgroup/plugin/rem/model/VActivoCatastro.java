package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "VI_ACTIVO_CATASTRO", schema = "${entity.schema}")
public class VActivoCatastro implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "IDACTIVOCATASTRO")
	private Long idActivoCatastro;
	
	@Column(name = "IDACTIVO")
	private Long idActivo;
	
	@Column(name = "REFCATASTRAL")
	private String refCatastral;
	
	@Column(name = "CORRECTO")
	private Boolean correcto;
	
	@Column(name = "VALORCATASTRALCONST")
	private Double valorCatastralConst;
	
	@Column(name = "VALORCATASTRALSUELO")
	private Double valorCatastralSuelo;
	
	@Column(name = "FECHAREVVALORCATASTRAL")
	private Date fechaRevValorCatastral;
	
	@Column(name = "FECHAALTACATASTRO")
	private Date fechaAltaCatastro;
	
	@Column(name = "SUPERFICIEPARCELA")
	private Double superficieParcela;
	
	@Column(name = "SUPERFICIECONSTRUIDA")
	private Double superficieConstruida;
	
	@Column(name = "ANYOCONSTRUCCION")
	private Integer anyoConstruccion;
	
	@Column(name = "CODIGOPOSTAL")
	private String codigoPostal;
	
	@Column(name = "TIPOVIA")
	private String tipoVia;
	
	@Column(name = "NOMBREVIA")
	private String nombreVia;
	
	@Column(name = "NUMEROVIA")
	private String numeroVia;
	
	@Column(name = "PLANTA")
	private String planta;
	
	@Column(name = "PUERTA")
	private String puerta;
	
	@Column(name = "ESCALERA")
	private String escalera;
	
	@Column(name = "PROVINCIA")
	private String provincia;
	
	@Column(name = "MUNICIPIO")
	private String municipio;
	
	@Column(name = "LATITUD")
	private String latitud;
	
	@Column(name = "LONGITUD")
	private String longitud;

	public Long getIdActivoCatastro() {
		return idActivoCatastro;
	}

	public void setIdActivoCatastro(Long idActivoCatastro) {
		this.idActivoCatastro = idActivoCatastro;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getRefCatastral() {
		return refCatastral;
	}

	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}

	public Boolean getCorrecto() {
		return correcto;
	}

	public void setCorrecto(Boolean correcto) {
		this.correcto = correcto;
	}

	public Double getValorCatastralConst() {
		return valorCatastralConst;
	}

	public void setValorCatastralConst(Double valorCatastralConst) {
		this.valorCatastralConst = valorCatastralConst;
	}

	public Double getValorCatastralSuelo() {
		return valorCatastralSuelo;
	}

	public void setValorCatastralSuelo(Double valorCatastralSuelo) {
		this.valorCatastralSuelo = valorCatastralSuelo;
	}

	public Date getFechaRevValorCatastral() {
		return fechaRevValorCatastral;
	}

	public void setFechaRevValorCatastral(Date fechaRevValorCatastral) {
		this.fechaRevValorCatastral = fechaRevValorCatastral;
	}

	public Date getFechaAltaCatastro() {
		return fechaAltaCatastro;
	}

	public void setFechaAltaCatastro(Date fechaAltaCatastro) {
		this.fechaAltaCatastro = fechaAltaCatastro;
	}

	public Double getSuperficieParcela() {
		return superficieParcela;
	}

	public void setSuperficieParcela(Double superficieParcela) {
		this.superficieParcela = superficieParcela;
	}

	public Double getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Double superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public Integer getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(Integer anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(String tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getNumeroVia() {
		return numeroVia;
	}

	public void setNumeroVia(String numeroVia) {
		this.numeroVia = numeroVia;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getLatitud() {
		return latitud;
	}

	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}

	public String getLongitud() {
		return longitud;
	}

	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}
}
