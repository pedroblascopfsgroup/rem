package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la solicitud de prórrogas de las tareas de activo
 * @author Daniel Gutiérrez
 *
 */
public class DtoSolicitarProrrogaTarea extends WebDto {

	private static final long serialVersionUID = 0L;
	private Long idTareaExterna;
	private String motivoAutoprorroga;
	private String detalleAutoprorroga;
	private String nuevaFechaProrroga;
	private String antiguaFechaProrroga;
	
	private String descripcionTareaProrrogada;
	
	public Long getIdTareaExterna() {
		return idTareaExterna;
	}
	public void setIdTareaExterna(Long idTareaExterna) {
		this.idTareaExterna = idTareaExterna;
	}
	public String getMotivoAutoprorroga() {
		return motivoAutoprorroga;
	}
	public void setMotivoAutoprorroga(String motivoAutoprorroga) {
		this.motivoAutoprorroga = motivoAutoprorroga;
	}
	public String getDetalleAutoprorroga() {
		return detalleAutoprorroga;
	}
	public void setDetalleAutoprorroga(String detalleAutoprorroga) {
		this.detalleAutoprorroga = detalleAutoprorroga;
	}
	public String getNuevaFechaProrroga() {
		return nuevaFechaProrroga;
	}
	public void setNuevaFechaProrroga(String nuevaFechaProrroga) {
		this.nuevaFechaProrroga = nuevaFechaProrroga;
	}
	public String getAntiguaFechaProrroga() {
		return antiguaFechaProrroga;
	}
	public void setAntiguaFechaProrroga(String antiguaFechaProrroga) {
		this.antiguaFechaProrroga = antiguaFechaProrroga;
	}
	/**
	 * @return the descripcionTareaProrrogada
	 */
	public String getDescripcionTareaProrrogada() {
		return descripcionTareaProrrogada;
	}
	/**
	 * @param descripcionTareaProrrogada the descripcionTareaProrrogada to set
	 */
	public void setDescripcionTareaProrrogada(String descripcionTareaProrrogada) {
		this.descripcionTareaProrrogada = descripcionTareaProrrogada;
	}
	
}