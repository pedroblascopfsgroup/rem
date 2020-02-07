package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;


/**
 * Dto para el grid de llaves en la pestaña situacion posesoria y llaves del Activo.
 */
public class DtoLlaves extends WebDto {

	private static final long serialVersionUID = 1L;

	private String id;// id LLave
	private String idActivo;
	private String nomCentroLlave;
	private String codCentroLlave;
	private String archivo1;
	private String archivo2;
	private String archivo3;
	private Integer juegoCompleto;
	private String motivoIncompleto;
	private String numLlave;

	private String tipoTenedor;
	private String nombreTenedor;
	private String telefonoTenedor;
	private Date fechaPrimerAnillado;
	private Date fechaRecepcion;
	private String observaciones;
	

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public void setIdEntidad(String idEntidad) {
		this.idActivo = idEntidad;
	}
	public String getNomCentroLlave() {
		return nomCentroLlave;
	}
	public void setNomCentroLlave(String nomCentroLlave) {
		this.nomCentroLlave = nomCentroLlave;
	}
	public String getArchivo1() {
		return archivo1;
	}
	public void setArchivo1(String archivo1) {
		this.archivo1 = archivo1;
	}
	public String getArchivo2() {
		return archivo2;
	}
	public void setArchivo2(String archivo2) {
		this.archivo2 = archivo2;
	}
	public String getArchivo3() {
		return archivo3;
	}
	public void setArchivo3(String archivo3) {
		this.archivo3 = archivo3;
	}
	public Integer getJuegoCompleto() {
		return juegoCompleto;
	}
	public void setJuegoCompleto(Integer juegoCompleto) {
		this.juegoCompleto = juegoCompleto;
	}
	public String getMotivoIncompleto() {
		return motivoIncompleto;
	}
	public void setMotivoIncompleto(String motivoIncompleto) {
		this.motivoIncompleto = motivoIncompleto;
	}
	public String getCodCentroLlave() {
		return codCentroLlave;
	}
	public void setCodCentroLlave(String codCentroLlave) {
		this.codCentroLlave = codCentroLlave;
	}
	public String getNumLlave() {
		return numLlave;
	}
	public void setNumLlave(String numLlave) {
		this.numLlave = numLlave;
	}
	public String getTipoTenedor() {
		return tipoTenedor;
	}
	public void setTipoTenedor(String tipoTenedor) {
		this.tipoTenedor = tipoTenedor;
	}
	public String getNombreTenedor() {
		return nombreTenedor;
	}
	public void setNombreTenedor(String nombreTenedor) {
		this.nombreTenedor = nombreTenedor;
	}
	public String getTelefonoTenedor() {
		return telefonoTenedor;
	}
	public void setTelefonoTenedor(String telefonoTenedor) {
		this.telefonoTenedor = telefonoTenedor;
	}
	public Date getFechaPrimerAnillado() {
		return fechaPrimerAnillado;
	}
	public void setFechaPrimerAnillado(Date fechaPrimerAnillado) {
		this.fechaPrimerAnillado = fechaPrimerAnillado;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
}