package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

public class DtoCrearAnotacionRespuestaTarea implements
		DtoCrearAnotacionRespuestaTareaInfo {

	private Long idUg;
	private String codUg;
	private Long idTarea;
	private Long idUsuarioEmisor;

	private String respuesta;
	private boolean leido;
	
	
	
	

	@Override
	public Long getIdTarea() {
		return this.idTarea;
	}

	@Override
	public String getRespuesta() {
		return this.respuesta;
	}

	@Override
	public boolean isLeido() {
		return this.leido;
	}


	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	public void setLeido(boolean leido) {
		this.leido = leido;
	}

	public void setIdUsuarioEmisor(Long idUsuarioEmisor) {
		this.idUsuarioEmisor = idUsuarioEmisor;
	}

	@Override
	public Long getIdUsuarioEmisor() {
		return idUsuarioEmisor;
	}

	public void setIdUg(Long idUg) {
		this.idUg = idUg;
	}

	@Override
	public Long getIdUg() {
		return idUg;
	}

	public void setCodUg(String codUg) {
		this.codUg = codUg;
	}

	@Override
	public String getCodUg() {
		return codUg;
	}
}
