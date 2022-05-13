package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoCatastro extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idActivo;
	private String numeroActivo;
	private String refCatastral;
	private String poligono;
	private String parcela;
	private String titularCatastral;
	private String superficieConstruida;
	private String superficieUtil;
	private String superficieReperComun;
	private String superficieParcela;
	private String superficieSuelo;
	private String valorCatastralConst;	
	private String valorCatastralSuelo;
	// FIXME SOLUCION PARA BORRAR FECHAS PONER A STRING
	private Date fechaRevValorCatastral;
	private Date fechaAltaCatastro;
	private Date fechaBajaCatastro;
	private String observaciones;
	private String idCatastro;
	private Date fechaSolicitud901;
	private String resultadoSiNO;
	private Date fechaAlteracion;
	private String origenDatosCatastrales;
	private String claseUsoCatastral;
	private Boolean catastroVigente;
	private Double valorCatastral;
	private String tipoMoneda;
	private String descripcion;
	private String id;
	private String correcto;
	private String codigo;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public String getRefCatastral() {
		return refCatastral;
	}
	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}
	public String getPoligono() {
		return poligono;
	}
	public void setPoligono(String poligono) {
		this.poligono = poligono;
	}
	public String getParcela() {
		return parcela;
	}
	public void setParcela(String parcela) {
		this.parcela = parcela;
	}
	public String getTitularCatastral() {
		return titularCatastral;
	}
	public void setTitularCatastral(String titularCatastral) {
		this.titularCatastral = titularCatastral;
	}
	public String getSuperficieConstruida() {
		return superficieConstruida;
	}
	public void setSuperficieConstruida(String superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}
	public String getSuperficieUtil() {
		return superficieUtil;
	}
	public void setSuperficieUtil(String superficieUtil) {
		this.superficieUtil = superficieUtil;
	}
	public String getSuperficieReperComun() {
		return superficieReperComun;
	}
	public void setSuperficieReperComun(String superficieReperComun) {
		this.superficieReperComun = superficieReperComun;
	}
	public String getSuperficieParcela() {
		return superficieParcela;
	}
	public void setSuperficieParcela(String superficieParcela) {
		this.superficieParcela = superficieParcela;
	}
	public String getSuperficieSuelo() {
		return superficieSuelo;
	}
	public void setSuperficieSuelo(String superficieSuelo) {
		this.superficieSuelo = superficieSuelo;
	}
	public String getValorCatastralConst() {
		return valorCatastralConst;
	}
	public void setValorCatastralConst(String valorCatastralConst) {
		this.valorCatastralConst = valorCatastralConst;
	}
	public String getValorCatastralSuelo() {
		return valorCatastralSuelo;
	}
	public void setValorCatastralSuelo(String valorCatastralSuelo) {
		this.valorCatastralSuelo = valorCatastralSuelo;
	}
	public String getIdCatastro() {
		return idCatastro;
	}
	public void setIdCatastro(String idCatastro) {
		this.idCatastro = idCatastro;
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
	public Date getFechaBajaCatastro() {
		return fechaBajaCatastro;
	}
	public void setFechaBajaCatastro(Date fechaBajaCatastro) {
		this.fechaBajaCatastro = fechaBajaCatastro;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaSolicitud901() {
		return fechaSolicitud901;
	}
	public void setFechaSolicitud901(Date fechaSolicitud901) {
		this.fechaSolicitud901 = fechaSolicitud901;
	}
	public String getResultadoSiNO() {
		return resultadoSiNO;
	}
	public void setResultadoSiNO(String resultadoSiNO) {
		this.resultadoSiNO = resultadoSiNO;
	}
	public Date getFechaAlteracion() {
		return fechaAlteracion;
	}
	public void setFechaAlteracion(Date fechaAlteracion) {
		this.fechaAlteracion = fechaAlteracion;
	}
	public String getOrigenDatosCatastrales() {
		return origenDatosCatastrales;
	}
	public void setOrigenDatosCatastrales(String origenDatosCatastrales) {
		this.origenDatosCatastrales = origenDatosCatastrales;
	}
	public String getClaseUsoCatastral() {
		return claseUsoCatastral;
	}
	public void setClaseUsoCatastral(String claseUsoCatastral) {
		this.claseUsoCatastral = claseUsoCatastral;
	}
	public Boolean getCatastroVigente() {
		return catastroVigente;
	}
	public void setCatastroVigente(Boolean catastroVigente) {
		this.catastroVigente = catastroVigente;
	}
	public Double getValorCatastral() {
		return valorCatastral;
	}
	public void setValorCatastral(Double valorCatastral) {
		this.valorCatastral = valorCatastral;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getCorrecto() {
		return correcto;
	}
	public void setCorrecto(String correcto) {
		this.correcto = correcto;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
}