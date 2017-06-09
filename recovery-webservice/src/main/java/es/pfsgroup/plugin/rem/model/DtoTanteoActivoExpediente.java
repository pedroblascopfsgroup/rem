package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoTanteoActivoExpediente extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String id;
	private String codigoTipoAdministracion;
	private String descTipoAdministracion;
	private Date fechaComunicacion;
	private Date fechaRespuesta;
	private String numeroExpediente;
	private String solicitaVisita;
	private Date fechaFinTanteo;
	private String codigoTipoResolucion;
	private String descTipoResolucion;
	private Date fechaVencimiento;
	private Date fechaVisita;
	private Date fechaSolicitudVisita;
	private Date fechaResolucion;
	private Long idActivo;
	private Long ecoId;
	private String condiciones;

	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getEcoId() {
		return ecoId;
	}

	public void setEcoId(Long ecoId) {
		this.ecoId = ecoId;
	}

	public String getCodigoTipoAdministracion() {
		return codigoTipoAdministracion;
	}

	public void setCodigoTipoAdministracion(String codigoTipoAdministracion) {
		this.codigoTipoAdministracion = codigoTipoAdministracion;
	}
	
	public String getDescTipoAdministracion() {
		return descTipoAdministracion;
	}

	public void setDescTipoAdministracion(String descTipoAdministracion) {
		this.descTipoAdministracion = descTipoAdministracion;
	}

	public Date getFechaComunicacion() {
		return fechaComunicacion;
	}

	public void setFechaComunicacion(Date fechaComunicacion) {
		this.fechaComunicacion = fechaComunicacion;
	}

	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}

	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}

	public String getNumeroExpediente() {
		return numeroExpediente;
	}

	public void setNumeroExpediente(String numeroExpediente) {
		this.numeroExpediente = numeroExpediente;
	}

	public String getSolicitaVisita() {
		return solicitaVisita;
	}

	public void setSolicitaVisita(String solicitaVisita) {
		this.solicitaVisita = solicitaVisita;
	}

	public Date getFechaFinTanteo() {
		return fechaFinTanteo;
	}

	public void setFechaFinTanteo(Date fechaFinTanteo) {
		this.fechaFinTanteo = fechaFinTanteo;
	}

	public String getCodigoTipoResolucion() {
		return codigoTipoResolucion;
	}

	public void setCodigoTipoResolucion(String codigoTipoResolucion) {
		this.codigoTipoResolucion = codigoTipoResolucion;
	}
	
	public String getDescTipoResolucion() {
		return descTipoResolucion;
	}

	public void setDescTipoResolucion(String descTipoResolucion) {
		this.descTipoResolucion = descTipoResolucion;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Date getFechaVisita() {
		return fechaVisita;
	}

	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public Date getFechaSolicitudVisita() {
		return fechaSolicitudVisita;
	}

	public void setFechaSolicitudVisita(Date fechaSolicitudVisita) {
		this.fechaSolicitudVisita = fechaSolicitudVisita;
	}

	public String getCondiciones() {
		return condiciones;
	}

	public void setCondiciones(String condiciones) {
		this.condiciones = condiciones;
	}
}
