package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "VTAR_ASU_VS_USU", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@IdClass(VTARAsuntoVsUsuarioID.class)
public class VTARAsuntoVsUsuario implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5901752049239192596L;


	@Id
	@Column(name = "DD_TGE_ID")
	private Long tipoGestor;

	@Id
	@Column(name = "ASU_ID")
	private Long asunto;

	@Id
	@Column(name = "USU_id")
	private Long usuario;


	@Column(name = "DES_ID")
	private Long despachoExterno;
	/*
	@Column(name = "GAS_ID")
	private GestorDespacho gestor;


	@Column(name = "DD_EST_ID")
	private DDEstadoItinerario estadoItinerario;

	@Column(name = "ASU_PROCESS_BPM")
	private Long processBpm;

	@Column(name = "ASU_FECHA_EST_ID")
	private Date fechaEstado;

	@Column(name = "ASU_NOMBRE")
	private String nombre;

	@Column(name = "ASU_FECHA_RECEP_DOC")
	private Date fechaRecepDoc;

	@Column(name = "EXP_ID")
	private Expediente expediente;

	@Column(name = "ASU_OBSERVACION")
	private String observacion;

	@Column(name = "DD_EAS_ID")
	private DDEstadoAsunto estadoAsunto;

	@Column(name = "ASU_ASU_ID")
	private Asunto asuntoOrigen;

	@Column(name = "SUP_ID")
	private GestorDespacho supervisor;

	@Column(name = "SUP_COM_ID")
	private Usuario supervisorComite;

	@Column(name = "COM_ID")
	private Comite comite;

	@Column(name = "DCO_ID")
	private DecisionComite decisionComite;

*/
	public Long getDespachoExterno() {
		return despachoExterno;
	}

	public void setDespachoExterno(Long despachoExterno) {
		this.despachoExterno = despachoExterno;
	}

	public Long getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(Long tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public Long getAsunto() {
		return asunto;
	}

	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}

	

	public Long getUsuario() {
		return usuario;
	}

	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}

/*	public GestorDespacho getGestor() {
		return gestor;
	}

	public void setGestor(GestorDespacho gestor) {
		this.gestor = gestor;
	}
	public DDEstadoItinerario getEstadoItinerario() {
		return estadoItinerario;
	}

	public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
		this.estadoItinerario = estadoItinerario;
	}

	public Long getProcessBpm() {
		return processBpm;
	}

	public void setProcessBpm(Long processBpm) {
		this.processBpm = processBpm;
	}

	public Date getFechaEstado() {
		return fechaEstado;
	}

	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Date getFechaRecepDoc() {
		return fechaRecepDoc;
	}

	public void setFechaRecepDoc(Date fechaRecepDoc) {
		this.fechaRecepDoc = fechaRecepDoc;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public DDEstadoAsunto getEstadoAsunto() {
		return estadoAsunto;
	}

	public void setEstadoAsunto(DDEstadoAsunto estadoAsunto) {
		this.estadoAsunto = estadoAsunto;
	}

	public Asunto getAsuntoOrigen() {
		return asuntoOrigen;
	}

	public void setAsuntoOrigen(Asunto asuntoOrigen) {
		this.asuntoOrigen = asuntoOrigen;
	}

	public GestorDespacho getSupervisor() {
		return supervisor;
	}

	public void setSupervisor(GestorDespacho supervisor) {
		this.supervisor = supervisor;
	}

	public Usuario getSupervisorComite() {
		return supervisorComite;
	}

	public void setSupervisorComite(Usuario supervisorComite) {
		this.supervisorComite = supervisorComite;
	}

	public Comite getComite() {
		return comite;
	}

	public void setComite(Comite comite) {
		this.comite = comite;
	}

	public DecisionComite getDecisionComite() {
		return decisionComite;
	}

	public void setDecisionComite(DecisionComite decisionComite) {
		this.decisionComite = decisionComite;
	}*/

}
