package es.pfsgroup.plugin.rem.model;

import java.util.Date;




/**
 * Dto para la pestaña Comercial/visitas de la ficha de Activo
 * @author Luis Caballero
 *
 */
public class DtoVisitasActivo {

	private static final long serialVersionUID = 0L;

	
	private Long id;
	private Long idActivo;
	private Long numVisita;
	private Date fechaSolicitud;
	private String nombre;
	private String numDocumento;
	private Date fechaVisita;
	private Long numActivo;
	private String solicitante;
	private String nifSolicitante;
	private String telefonoSolicitante;
	private String emailSolicitante;
	private Date fechaContactoCliente;
	private String estadoVisitaCodigo;
	private Date fechaVisitaConcertada;
	private Date fechaFinalizacion;
	private String motivoFinalizacion;
	private String observacionesVisita;
	
	public Long getNumVisita() {
		return numVisita;
	}
	public void setNumVisita(Long numVisita) {
		this.numVisita = numVisita;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNumDocumento() {
		return numDocumento;
	}
	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
	public String getNifSolicitante() {
		return nifSolicitante;
	}
	public void setNifSolicitante(String nifSolicitante) {
		this.nifSolicitante = nifSolicitante;
	}
	public String getTelefonoSolicitante() {
		return telefonoSolicitante;
	}
	public void setTelefonoSolicitante(String telefonoSolicitante) {
		this.telefonoSolicitante = telefonoSolicitante;
	}
	public String getEmailSolicitante() {
		return emailSolicitante;
	}
	public void setEmailSolicitante(String emailSolicitante) {
		this.emailSolicitante = emailSolicitante;
	}
	public Date getFechaContactoCliente() {
		return fechaContactoCliente;
	}
	public void setFechaContactoCliente(Date fechaContactoCliente) {
		this.fechaContactoCliente = fechaContactoCliente;
	}
	public String getEstadoVisitaCodigo() {
		return estadoVisitaCodigo;
	}
	public void setEstadoVisitaCodigo(String estadoVisitaCodigo) {
		this.estadoVisitaCodigo = estadoVisitaCodigo;
	}
	public Date getFechaVisitaConcertada() {
		return fechaVisitaConcertada;
	}
	public void setFechaVisitaConcertada(Date fechaVisitaConcertada) {
		this.fechaVisitaConcertada = fechaVisitaConcertada;
	}
	public Date getFechaFinalizacion() {
		return fechaFinalizacion;
	}
	public void setFechaFinalizacion(Date fechaFinalizacion) {
		this.fechaFinalizacion = fechaFinalizacion;
	}
	public String getMotivoFinalizacion() {
		return motivoFinalizacion;
	}
	public void setMotivoFinalizacion(String motivoFinalizacion) {
		this.motivoFinalizacion = motivoFinalizacion;
	}
	public String getObservacionesVisita() {
		return observacionesVisita;
	}
	public void setObservacionesVisita(String observacionesVisita) {
		this.observacionesVisita = observacionesVisita;
	}

	
}