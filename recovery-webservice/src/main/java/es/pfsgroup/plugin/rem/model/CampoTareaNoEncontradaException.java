package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.exception.UserException;

/***
 * @author jyebenes
 * 
 * Excepción utilizada cuando no se encuentra un campo de la tarea al evaluar un script de plazoTarea
 * 
 * 
 * */
public class CampoTareaNoEncontradaException extends UserException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8055123453190924610L;
		
	public CampoTareaNoEncontradaException(String nombreCampo, String nombreTarea, Long idTareaExterna,Long tokenIdBPM, Long idProcedimiento, String campo,String tarea){
		
		super("ERROR_CAMPO_NO_ENCONTRADO"+"%"+nombreCampo+"%"+nombreTarea+"%"+idTareaExterna+"%"+tokenIdBPM+"%"+idProcedimiento+"%"+campo+"%"+tarea);
		this.nombreTarea = nombreTarea;
		this.nombreCampo = nombreCampo;
		this.idTareaExterna = idTareaExterna;
		this.tokenIdBPM = tokenIdBPM;
		this.setIdProcedimiento(idProcedimiento);
	}
	
	private String nombreTarea;

	private String nombreCampo;
	
	private Long idTareaExterna;
	
	private Long tokenIdBPM;
	
	private Long idProcedimiento;
	
	public String getNombreTarea() {
		return nombreTarea;
	}
	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}
	public String getNombreCampo() {
		return nombreCampo;
	}
	public void setNombreCampo(String nombreCampo) {
		this.nombreCampo = nombreCampo;
	}
	public Long getIdTareaExterna() {
		return idTareaExterna;
	}
	public void setIdTareaExterna(Long idTareaExterna) {
		this.idTareaExterna = idTareaExterna;
	}
	public void setTokenIdBPM(Long tokenIdBPM) {
		this.tokenIdBPM = tokenIdBPM;
	}
	public Long getTokenIdBPM() {
		return tokenIdBPM;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	

}
