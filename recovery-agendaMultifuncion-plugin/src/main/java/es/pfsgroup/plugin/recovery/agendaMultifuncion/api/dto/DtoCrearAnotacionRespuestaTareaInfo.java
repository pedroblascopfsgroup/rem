package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

public interface DtoCrearAnotacionRespuestaTareaInfo {

	public Long getIdTarea();
	
	public Long getIdUg();

	public String getCodUg();
	public boolean isLeido();
	
	public String getRespuesta();
	
	public Long getIdUsuarioEmisor();
}
