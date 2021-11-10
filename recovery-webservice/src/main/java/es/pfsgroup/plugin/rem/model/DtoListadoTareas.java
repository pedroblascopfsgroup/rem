package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar las tareas
 * @author Daniel Gutiérrez
 *
 */
public class DtoListadoTareas extends WebDto {

	private static final long serialVersionUID = 1L;

	private Long idTareaExterna;

	private Long id;
	
	private String tipoTarea;
	
	private Long idTramite;
	
	private String tipoTramite;
	
	private Date fechaInicio;
	
	private Date fechaFin;
	
	private Date fechaVenc;
	
	private Long idGestor;
	
	private String gestor;
	
	private String subtipoTareaCodigoSubtarea;
	
	private String codigoTarea;
	
	private String nombreUsuarioGestor;
	
	private Long idSupervisor;
	
	private String nombreUsuarioSupervisor;
	
	private String usuarioFinaliza;
	
	private String nombre;
	
	public Long getIdTareaExterna() {
		return idTareaExterna;
	}

	public void setIdTareaExterna(Long idTareaExterna) {
		this.idTareaExterna = idTareaExterna;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTipoTarea() {
		return tipoTarea;
	}

	public void setTipoTarea(String tipoTarea) {
		this.tipoTarea = tipoTarea;
	}

	public Long getIdTramite() {
		return idTramite;
	}

	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}

	public String getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(String tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Date getFechaVenc() {
		return fechaVenc;
	}

	public void setFechaVenc(Date fechaVenc) {
		this.fechaVenc = fechaVenc;
	}

	public Long getIdGestor() {
		return idGestor;
	}

	public void setIdGestor(Long idGestor) {
		this.idGestor = idGestor;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}
	
	public String getSubtipoTareaCodigoSubtarea() {
		return subtipoTareaCodigoSubtarea;
	}

	public void setSubtipoTareaCodigoSubtarea(String subtipoTareaCodigoSubtarea) {
		this.subtipoTareaCodigoSubtarea = subtipoTareaCodigoSubtarea;
	}
	
	public String getCodigoTarea(){
		return codigoTarea;
	}
	
	public void setCodigoTarea(String codigoTarea){
		this.codigoTarea = codigoTarea;
	}

	public String getNombreUsuarioGestor() {
		return nombreUsuarioGestor;
	}

	public void setNombreUsuarioGestor(String nombreUsuarioGestor) {
		this.nombreUsuarioGestor = nombreUsuarioGestor;
	}

	public Long getIdSupervisor() {
		return idSupervisor;
	}

	public void setIdSupervisor(Long idSupervisor) {
		this.idSupervisor = idSupervisor;
	}

	public String getNombreUsuarioSupervisor() {
		return nombreUsuarioSupervisor;
	}

	public void setNombreUsuarioSupervisor(String nombreUsuarioSupervisor) {
		this.nombreUsuarioSupervisor = nombreUsuarioSupervisor;
	}
	
	public String getUsuarioFinaliza(){
		return usuarioFinaliza;
	}
	
	public void setUsuarioFinaliza(String usuarioFinaliza){
		this.usuarioFinaliza = usuarioFinaliza;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

}