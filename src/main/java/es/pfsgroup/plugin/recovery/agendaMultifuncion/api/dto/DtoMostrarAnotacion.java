package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;


public class DtoMostrarAnotacion {

	private Long idAsunto;
	private String codUg;
	private String situacion;
	private String fecha;
	private String descripcion;
	private String emisor;
	private String destinatario;
	private String fechaVencimiento;
	private String tipoAnotacion;
	private boolean flagEmail;
	private Long idTarea;
	private String respuesta;
	private boolean tieneResponder;
	private String nombreAsunto;
	private String numLitigio;
	private String numeroLitigio;
	private String nombreDeudor;
	private Long idTraza;

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public String getSituacion() {
		return situacion;
	}

	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

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

	public String getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public String getTipoAnotacion() {
		return tipoAnotacion;
	}

	public void setTipoAnotacion(String tipoAnotacion) {
		this.tipoAnotacion = tipoAnotacion;
	}

	public boolean isFlagEmail() {
		return flagEmail;
	}

	public void setFlagEmail(boolean flagEmail) {
		this.flagEmail = flagEmail;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	public void setTieneResponder(boolean tieneResponder) {
		this.tieneResponder = tieneResponder;
	}

	public boolean isTieneResponder() {
		return tieneResponder;
	}

	public void setCodUg(String codUg) {
		this.codUg = codUg;
	}

	public String getCodUg() {
		return codUg;
	}

	public void setNombreAsunto(String nombreAsunto) {
		this.nombreAsunto = nombreAsunto;
	}

	public String getNombreAsunto() {
		return nombreAsunto;
	}

	public void setNumLitigio(String numLitigio) {
		this.numLitigio = numLitigio;
	}

	public String getNumLitigio() {
		return numLitigio;
	}
	
	public void setNumeroLitigio(String numeroLitigio) {
		this.numeroLitigio = numeroLitigio;
	}

	public String getNumeroLitigio() {
		return numeroLitigio;
	}
	
	public void setNombreDeudor(String nombreDeudor) {
		this.nombreDeudor = nombreDeudor;
	}

	public String getNombreDeudor() {
		return nombreDeudor;
	}

	public Long getIdTraza() {
		return idTraza;
	}

	public void setIdTraza(Long idTraza) {
		this.idTraza = idTraza;
	}	
}
