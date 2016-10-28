package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el grid de llaves en la pestaña situacion posesoria y llaves del Activo.
 */
public class DtoLlaves extends WebDto{

	private static final long serialVersionUID = 1L;

	private String idMovimiento;
	private String idLlave;
	private String idActivo;
	private String nomCentroLlave;
	private String codCentroLlave;
	private String archivo1;
	private String archivo2;
	private String archivo3;
	private Integer juegoCompleto;
	private String motivoIncompleto;
	private String codigoTipoTenedor;
	private String descripcionTipoTenedor;
	private String codTenedor;	
	private String nomTenedor;
	private Date fechaEntrega;
	private Date fechaDevolucion;



	public String getIdMovimiento() {
		return idMovimiento;
	}
	public void setIdMovimiento(String idMovimiento) {
		this.idMovimiento = idMovimiento;
	}
	public String getIdLlave() {
		return idLlave;
	}
	public void setIdLlave(String idLlave) {
		this.idLlave = idLlave;
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
	public String getCodigoTipoTenedor() {
		return codigoTipoTenedor;
	}
	public void setCodigoTipoTenedor(String codigoTipoTenedor) {
		this.codigoTipoTenedor = codigoTipoTenedor;
	}
	public String getDescripcionTipoTenedor() {
		return descripcionTipoTenedor;
	}
	public void setDescripcionTipoTenedor(String descripcionTipoTenedor) {
		this.descripcionTipoTenedor = descripcionTipoTenedor;
	}
	public String getCodTenedor() {
		return codTenedor;
	}
	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}
	public String getNomTenedor() {
		return nomTenedor;
	}
	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}
	public Date getFechaEntrega() {
		return fechaEntrega;
	}
	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}
	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}
	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}
	public String getCodCentroLlave() {
		return codCentroLlave;
	}
	public void setCodCentroLlave(String codCentroLlave) {
		this.codCentroLlave = codCentroLlave;
	}
}