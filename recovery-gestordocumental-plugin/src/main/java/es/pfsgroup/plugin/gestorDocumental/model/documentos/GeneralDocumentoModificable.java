package es.pfsgroup.plugin.gestorDocumental.model.documentos;

import java.util.Date;

public class GeneralDocumentoModificable {

	/**
	 * Número de registro del documento
	 */
	private String numRegistro;

	/**
	 * Pais de expedición cuando el documento es un TDN1 DOCI (Documento
	 * identificativo)
	 */
	private String paisExpedicion;

	/**
	 * Tipo de identificación cuando el documento es un TDN1 DOCI (Documento
	 * identificativo)
	 */
	private String tipoIdentificacion;

	/**
	 * Número de identificación cuando el documento es un TDN1 DOCI (Documento
	 * identificativo)
	 */
	private String numIdentificacion;

	/**
	 * Fecha de Borrador o anulación de documento
	 */
	private Date fechaBajaLogica;

	/**
	 * Fecha de caducidad del documento
	 */
	private Date fechaCaducidad;

	/**
	 * Fecha de expurgo del documento
	 */
	private Date fechaExpurgo;

	/**
	 * Proceso de carga del documento, por ejemplo, Recovery, REM….
	 */
	private String procesoCarga;

	/**
	 * Nivel LOPD
	 */
	private String lopd;

	/**
	 * Serie Documental. Segundo Nivel de agrupación del cuadro de clasificación
	 */
	private String serieDocumental;

	/**
	 * Tipo documental N1
	 */
	private String tdn1;

	/**
	 * Unidad documental N2
	 */
	private String tdn2;

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getPaisExpedicion() {
		return paisExpedicion;
	}

	public void setPaisExpedicion(String paisExpedicion) {
		this.paisExpedicion = paisExpedicion;
	}

	public String getTipoIdentificacion() {
		return tipoIdentificacion;
	}

	public void setTipoIdentificacion(String tipoIdentificacion) {
		this.tipoIdentificacion = tipoIdentificacion;
	}

	public String getNumIdentificacion() {
		return numIdentificacion;
	}

	public void setNumIdentificacion(String numIdentificacion) {
		this.numIdentificacion = numIdentificacion;
	}

	public Date getFechaBajaLogica() {
		return fechaBajaLogica;
	}

	public void setFechaBajaLogica(Date fechaBajaLogica) {
		this.fechaBajaLogica = fechaBajaLogica;
	}

	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

	public Date getFechaExpurgo() {
		return fechaExpurgo;
	}

	public void setFechaExpurgo(Date fechaExpurgo) {
		this.fechaExpurgo = fechaExpurgo;
	}

	public String getProcesoCarga() {
		return procesoCarga;
	}

	public void setProcesoCarga(String procesoCarga) {
		this.procesoCarga = procesoCarga;
	}

	public String getLopd() {
		return lopd;
	}

	public void setLopd(String lopd) {
		this.lopd = lopd;
	}

	public String getSerieDocumental() {
		return serieDocumental;
	}

	public void setSerieDocumental(String serieDocumental) {
		this.serieDocumental = serieDocumental;
	}

	public String getTdn1() {
		return tdn1;
	}

	public void setTdn1(String tdn1) {
		this.tdn1 = tdn1;
	}

	public String getTdn2() {
		return tdn2;
	}

	public void setTdn2(String tdn2) {
		this.tdn2 = tdn2;
	}

}