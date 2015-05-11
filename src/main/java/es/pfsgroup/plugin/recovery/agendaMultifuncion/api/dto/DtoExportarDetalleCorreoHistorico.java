package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

public class DtoExportarDetalleCorreoHistorico {

	private String emisor;
	private String destinatario;
	private String cc;
	private String fechaCreacion;
	private String nombreAsunto;
	private String numLitigio;
	private String situacion;
	private String asuntocorreo;
	private String idasunto;
	private String tipoentidad;
	private String texto;
	private String idTraza;
	
	public String getEmisor() {
		return emisor;
	}
	public void setEmisor(String emisor) {
		this.emisor = emisor;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getCc() {
		return cc;
	}
	public void setCc(String cc) {
		this.cc = cc;
	}
	public String getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(String fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	public String getNombreAsunto() {
		return nombreAsunto;
	}
	public void setNombreAsunto(String nombreAsunto) {
		this.nombreAsunto = nombreAsunto;
	}
	public String getNumLitigio() {
		return numLitigio;
	}
	public void setNumLitigio(String numLitigio) {
		this.numLitigio = numLitigio;
	}
	public String getSituacion() {
		return situacion;
	}
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}
	public String getAsuntocorreo() {
		return asuntocorreo;
	}
	public void setAsuntocorreo(String asuntocorreo) {
		this.asuntocorreo = asuntocorreo;
	}
	public String getIdasunto() {
		return idasunto;
	}
	public void setIdasunto(String idasunto) {
		this.idasunto = idasunto;
	}
	public String getTipoentidad() {
		return tipoentidad;
	}
	public void setTipoentidad(String tipoentidad) {
		this.tipoentidad = tipoentidad;
	}
	public String getTexto() {
		return texto;
	}
	public void setTexto(String texto) {
		this.texto = texto;
	}
	public String getIdTraza() {
		return idTraza;
	}
	public void setIdTraza(String idTraza) {
		this.idTraza = idTraza;
	}	
	
}
