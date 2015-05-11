package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;

/**
 * Clase que transfiere información desde la vista hacia el modelo.
 * 
 * @author Óscar
 * 
 */
public class AnalisisContratosWebDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9134708106783759401L;

	private Long id;
	private Long asuId;
	private Long contratoId;
	private Boolean revisadoA;
	private Boolean ejecucionIniciada;
	private Boolean propuestaEjecucion;
	private Boolean iniciarEjecucion;
	private Boolean revisadoB;
	private DDSiNo solicitarSolvencia;
	private Date fechaSolicitarSolvencia;
	private Date fechaRecepcion;
	private DDFavorable resultado;
	private Boolean decisionB;
	private Boolean revisadoC;
	private DDSiNo decisionC;
	private Date fechaProximaRevision;
	private DDSiNo decisionRevision;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getAsuId() {
		return asuId;
	}

	public void setAsuId(Long asuId) {
		this.asuId = asuId;
	}

	public Long getContratoId() {
		return contratoId;
	}

	public void setContratoId(Long contratoId) {
		this.contratoId = contratoId;
	}

	public Boolean getEjecucionIniciada() {
		return ejecucionIniciada;
	}

	public void setEjecucionIniciada(Boolean ejecucionIniciada) {
		this.ejecucionIniciada = ejecucionIniciada;
	}

	public Boolean getRevisadoA() {
		return revisadoA;
	}

	public void setRevisadoA(Boolean revisadoA) {
		this.revisadoA = revisadoA;
	}

	public Boolean getPropuestaEjecucion() {
		return propuestaEjecucion;
	}

	public void setPropuestaEjecucion(Boolean propuestaEjecucion) {
		this.propuestaEjecucion = propuestaEjecucion;
	}

	public Boolean getRevisadoB() {
		return revisadoB;
	}

	public void setRevisadoB(Boolean revisadoB) {
		this.revisadoB = revisadoB;
	}
	
	public Boolean getIniciarEjecucion() {
		return iniciarEjecucion;
	}

	public void setIniciarEjecucion(Boolean iniciarEjecucion) {
		this.iniciarEjecucion = iniciarEjecucion;
	}

	public DDSiNo getSolicitarSolvencia() {
		return solicitarSolvencia;
	}

	public void setSolicitarSolvencia(DDSiNo solicitarSolvencia) {
		this.solicitarSolvencia = solicitarSolvencia;
	}

	public Date getFechaSolicitarSolvencia() {
		return fechaSolicitarSolvencia;
	}

	public void setFechaSolicitarSolvencia(Date fechaSolicitarSolvencia) {
		this.fechaSolicitarSolvencia = fechaSolicitarSolvencia;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public DDFavorable getResultado() {
		return resultado;
	}

	public void setResultado(DDFavorable resultado) {
		this.resultado = resultado;
	}

	public Boolean getDecisionB() {
		return decisionB;
	}

	public void setDecisionB(Boolean decisionB) {
		this.decisionB = decisionB;
	}

	public Boolean getRevisadoC() {
		return revisadoC;
	}

	public void setRevisadoC(Boolean revisadoC) {
		this.revisadoC = revisadoC;
	}

	public DDSiNo getDecisionC() {
		return decisionC;
	}

	public void setDecisionC(DDSiNo decisionC) {
		this.decisionC = decisionC;
	}

	public Date getFechaProximaRevision() {
		return fechaProximaRevision;
	}

	public void setFechaProximaRevision(Date fechaProximaRevision) {
		this.fechaProximaRevision = fechaProximaRevision;
	}

	public DDSiNo getDecisionRevision() {
		return decisionRevision;
	}

	public void setDecisionRevision(DDSiNo decisionRevision) {
		this.decisionRevision = decisionRevision;
	}

}