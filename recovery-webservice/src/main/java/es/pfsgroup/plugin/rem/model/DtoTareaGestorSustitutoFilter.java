package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de tareas para los Gestores Sustitutos
 * @author Vicente Martinez Cifre
 *
 */
public class DtoTareaGestorSustitutoFilter extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long contrato;//id del tramite
	
	private Long idGestorOriginal;
	
	private Long idGestorSustituto;
	
	private String codEntidad;//Numero del Activo
	
	private Long idTarea;
	
	private String nombreTarea;//Descripcion de la tarea
	
	private String descripcionEntidad;//Tipo de tramite
	
	private String codigoTipoTramite;
	
	private String gestor;//Usuario responsable
	
	private Date fechaInicio;
	
	private Date fechaVenc;//Fecha de fin
	
	private Long diasVencidaNumber;//Plazo de vencimiento
	
	private Long semaforo;//prioridad
	
	private Long idEntidad;//id activo

	public Long getContrato() {
		return contrato;
	}

	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}

	public Long getIdGestorOriginal() {
		return idGestorOriginal;
	}

	public void setIdGestorOriginal(Long idGestorOriginal) {
		this.idGestorOriginal = idGestorOriginal;
	}

	public Long getIdGestorSustituto() {
		return idGestorSustituto;
	}

	public void setIdGestorSustituto(Long idGestorSustituto) {
		this.idGestorSustituto = idGestorSustituto;
	}

	public String getCodEntidad() {
		return codEntidad;
	}

	public void setCodEntidad(String codEntidad) {
		this.codEntidad = codEntidad;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public String getNombreTarea() {
		return nombreTarea;
	}

	public void setNombreTarea(String nombreTarea) {
		this.nombreTarea = nombreTarea;
	}

	public String getDescripcionEntidad() {
		return descripcionEntidad;
	}

	public void setDescripcionEntidad(String descripcionEntidad) {
		this.descripcionEntidad = descripcionEntidad;
	}

	public String getCodigoTipoTramite() {
		return codigoTipoTramite;
	}

	public void setCodigoTipoTramite(String codigoTipoTramite) {
		this.codigoTipoTramite = codigoTipoTramite;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaVenc() {
		return fechaVenc;
	}

	public void setFechaVenc(Date fechaVenc) {
		this.fechaVenc = fechaVenc;
	}

	public Long getDiasVencidaNumber() {
		return diasVencidaNumber;
	}

	public void setDiasVencidaNumber(Long diasVencidaNumber) {
		this.diasVencidaNumber = diasVencidaNumber;
	}

	public Long getSemaforo() {
		return semaforo;
	}

	public void setSemaforo(Long semaforo) {
		this.semaforo = semaforo;
	}

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

}
