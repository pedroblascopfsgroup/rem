package es.capgemini.pfs.acuerdo.dto;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para asuntos.
 * Por el momento la �nica propiedad que se necesita es el id del gestor.
 * @author pamuller
 *
 */
public class DtoAcuerdo extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idAcuerdo;
	private Long idAsunto;
	private Long idExpediente;
	private String tipoAcuerdo;
	private String solicitante;
	private String estado;
	private String tipoPago;
	private String importePago;
	private String observaciones;
	private String periodicidad;
	private Long periodo;
	private String fechaCierre;
	private String fechaLimite;
	private Long importeCostas;	
	private String guid;
	private Long idJBPM;
	private Date fechaEstado;

	/**
	 * @return the tipoAcuerdo
	 */
	public String getTipoAcuerdo() {
		return tipoAcuerdo;
	}


	/**
	 * @param tipoAcuerdo the tipoAcuerdo to set
	 */
	public void setTipoAcuerdo(String tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}


	/**
	 * @return the solicitante
	 */
	public String getSolicitante() {
		return solicitante;
	}


	/**
	 * @param solicitante the solicitante to set
	 */
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}


	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}


	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}


	/**
	 * @return the tipoPago
	 */
	public String getTipoPago() {
		return tipoPago;
	}


	/**
	 * @param tipoPago the tipoPago to set
	 */
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}


	/**
	 * @return the importePago
	 */
	public String getImportePago() {
		return importePago;
	}


	/**
	 * @param importePago the importePago to set
	 */
	public void setImportePago(String importePago) {
		this.importePago = importePago;
	}


	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}


	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}


	/**
	 * @return the periodicidad
	 */
	public String getPeriodicidad() {
		return periodicidad;
	}


	/**
	 * @param periodicidad the periodicidad to set
	 */
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	/**
	 * @return the idAcuerdo
	 */
	public Long getIdAcuerdo() {
		return idAcuerdo;
	}


	/**
	 * @param idAcuerdo the idAcuerdo to set
	 */
	public void setIdAcuerdo(Long idAcuerdo) {
		this.idAcuerdo = idAcuerdo;
	}


	/**
	 * @return the idAsunto
	 */
	public Long getIdAsunto() {
		return idAsunto;
	}


	/**
	 * @param idAsunto the idAsunto to set
	 */
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}


	/**
	 * @return the periodo
	 */
	public Long getPeriodo() {
		return periodo;
	}


	/**
	 * @param periodo the periodo to set
	 */
	public void setPeriodo(Long periodo) {
		this.periodo = periodo;
	}


	/**
	 * @return the fechaCierre
	 */
	public String getFechaCierre() {
		return fechaCierre;
	}


	/**
	 * @param fechaCierre the fechaCierre to set
	 */
	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}


	public String getFechaLimite() {
		return fechaLimite;
	}


	public void setFechaLimite(String fechaLimite) {
		this.fechaLimite = fechaLimite;
	}

	public Long getImporteCostas() {
		return importeCostas;
	}


	public void setImporteCostas(Long importeCostas) {
		this.importeCostas = importeCostas;
	}
	
	public Long getIdExpediente() {
		return idExpediente;
	}


	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	
	public boolean esPropuesta(){
		if (idExpediente!=null){
			return true;
		}else{
			return false;
		}
	}
	
	public String getGuid() {
		return guid;
	}


	public void setGuid(String guid) {
		this.guid = guid;
	}


	public Long getIdJBPM() {
		return idJBPM;
	}


	public void setIdJBPM(Long idJBPM) {
		this.idJBPM = idJBPM;
	}


	public Date getFechaEstado() {
		return fechaEstado;
	}


	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
	}

}