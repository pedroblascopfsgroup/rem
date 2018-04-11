package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el salto entre tareas tareas
 *
 */
public class DtoSaltoTarea extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long idTramite;
	
	private String codigoTareaDestino;
	
	private Integer conflictoIntereses;
	
	private Integer riesgoReputacional;
	
	private String comiteSancionador;
	
	private Date fechaEnvioSancion;
	
	private Integer firmaEscritura;
	
	private Date fechaFirmaPropietario;
	
	private Date fechaFirmaReserva;
	
	private String notario;
	
	private String numProtocolo;
	
	private Double precioEscrituracion;
	
	private String motivoAnulacion;
	
	private Date fechaRespuestaComite;
	
	private Date fechaRespuestaOfertante;
	
	private Integer resolucion;
	
	private Double importeContraoferta;
	
	private Integer aceptaContraoferta;
	
	private Double importeOfertante;
	
	private String tipoArras;
	
	private Date fechaEnvioReserva;
	
	private Integer pbcAprobado;
	
	private Integer solicitaReserva;
	
	
	public Long getIdTramite() {
		return idTramite;
	}
	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}
	public String getCodigoTareaDestino() {
		return codigoTareaDestino;
	}
	public void setCodigoTareaDestino(String codigoTareaDestino) {
		this.codigoTareaDestino = codigoTareaDestino;
	}
	public Integer getConflictoIntereses() {
		return conflictoIntereses;
	}
	public void setConflictoIntereses(Integer conflictoIntereses) {
		this.conflictoIntereses = conflictoIntereses;
	}
	public Integer getRiesgoReputacional() {
		return riesgoReputacional;
	}
	public void setRiesgoReputacional(Integer riesgoReputacional) {
		this.riesgoReputacional = riesgoReputacional;
	}
	public String getComiteSancionador() {
		return comiteSancionador;
	}
	public void setComiteSancionador(String comiteSancionador) {
		this.comiteSancionador = comiteSancionador;
	}
	public Date getFechaEnvioSancion() {
		return fechaEnvioSancion;
	}
	public void setFechaEnvioSancion(Date fechaEnvioSancion) {
		this.fechaEnvioSancion = fechaEnvioSancion;
	}
	public Integer getFirmaEscritura() {
		return firmaEscritura;
	}
	public void setFirmaEscritura(Integer firmaEscritura) {
		this.firmaEscritura = firmaEscritura;
	}
	public Date getFechaFirmaPropietario() {
		return fechaFirmaPropietario;
	}
	public void setFechaFirmaPropietario(Date fechaFirmaPropietario) {
		this.fechaFirmaPropietario = fechaFirmaPropietario;
	}
	public Date getFechaFirmaReserva() {
		return fechaFirmaReserva;
	}
	public void setFechaFirmaReserva(Date fechaFirmaReserva) {
		this.fechaFirmaReserva = fechaFirmaReserva;
	}
	public String getNotario() {
		return notario;
	}
	public void setNotario(String notario) {
		this.notario = notario;
	}
	public String getNumProtocolo() {
		return numProtocolo;
	}
	public void setNumProtocolo(String numProtocolo) {
		this.numProtocolo = numProtocolo;
	}
	public Double getPrecioEscrituracion() {
		return precioEscrituracion;
	}
	public void setPrecioEscrituracion(Double precioEscrituracion) {
		this.precioEscrituracion = precioEscrituracion;
	}
	public String getMotivoAnulacion() {
		return motivoAnulacion;
	}
	public void setMotivoAnulacion(String motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}
	public Date getFechaRespuestaComite() {
		return fechaRespuestaComite;
	}
	public void setFechaRespuestaComite(Date fechaRespuestaComite) {
		this.fechaRespuestaComite = fechaRespuestaComite;
	}
	public Date getFechaRespuestaOfertante() {
		return fechaRespuestaOfertante;
	}
	public void setFechaRespuestaOfertante(Date fechaRespuestaOfertante) {
		this.fechaRespuestaOfertante = fechaRespuestaOfertante;
	}
	public Integer getResolucion() {
		return resolucion;
	}
	public void setResolucion(Integer resolucion) {
		this.resolucion = resolucion;
	}
	public Double getImporteContraoferta() {
		return importeContraoferta;
	}
	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}
	public Integer getAceptaContraoferta() {
		return aceptaContraoferta;
	}
	public void setAceptaContraoferta(Integer aceptaContraoferta) {
		this.aceptaContraoferta = aceptaContraoferta;
	}
	public Double getImporteOfertante() {
		return importeOfertante;
	}
	public void setImporteOfertante(Double importeOfertante) {
		this.importeOfertante = importeOfertante;
	}
	public String getTipoArras() {
		return tipoArras;
	}
	public void setTipoArras(String tipoArras) {
		this.tipoArras = tipoArras;
	}
	public Date getFechaEnvioReserva() {
		return fechaEnvioReserva;
	}
	public void setFechaEnvio(Date fechaEnvioReserva) {
		this.fechaEnvioReserva = fechaEnvioReserva;
	}
	public Integer getPbcAprobado() {
		return pbcAprobado;
	}
	public void setPbcAprobado(Integer pbcAprobado) {
		this.pbcAprobado = pbcAprobado;
	}
	public Integer getSolicitaReserva() {
		return solicitaReserva;
	}
	public void setSolicitaReserva(Integer solicitaReserva) {
		this.solicitaReserva = solicitaReserva;
	}
	
	
	

}