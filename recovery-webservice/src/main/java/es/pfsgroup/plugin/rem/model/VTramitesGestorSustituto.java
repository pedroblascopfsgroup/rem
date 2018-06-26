package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_TRAMITES_GESTOR_SUSTITUTO", schema = "${entity.schema}")
public class VTramitesGestorSustituto implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "TRAMITE")
	private Long contrato;//id del trámite
	
	@Column(name = "GESTOR_ORI")
	private Long idGestorOriginal;
	
	@Column(name = "GESTOR_SUS")
	private Long idGestorSustituto;
	
	//Numero del activo
	@Column (name = "ACTIVO")
	private String codEntidad;
	
	@Column(name = "IDTAREA")
	private Long idTarea;
	
	@Column(name = "TAREA")
	private String nombreTarea;//Descripcion de la tarea
	
	@Column(name = "TIPOTRAMITE")
	private String descripcionEntidad;//tipo de tramite
	
	@Column(name = "CODIGOTIPOTRAMITE")
	private String codigoTipoTramite;
	
	@Column(name = "RESPONSABLE")
	private String gestor;//Usuario responsable
	
	@Column(name = "FECHAINICIO")
	private Date fechaInicio;
	
	@Column(name = "FECHAFIN")
	private Date fechaVenc;//Fecha fin
	
	@Column(name = "PLAZOVENCIMIENTO")
	private Long diasVencidaNumber;//Plazo de vencimiento
	
	@Column(name = "PRIORIDAD")
	private Long semaforo;//prioridad
	
	@Column(name = "IDACTIVO")
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
