package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que transfiere información desde la vista hacia el modelo.
 * 
 * @author Óscar
 * 
 */
public class AnalisisContratosDto extends WebDto {


	/**
	 * 
	 */
	private static final long serialVersionUID = 6529955449472484365L;
	private String id;
	private String asuId;
	private String contratoId;
	private String revisadoA;
	private String ejecucionIniciada;
	private String propuestaEjecucion;
	private String iniciarEjecucion;
	private String revisadoB;
	private String solicitarSolvencia;
	private String fechaSolicitarSolvencia;
	private String fechaRecepcion;
	private String resultado;
	private String decisionB;
	private String revisadoC;
	private String decisionC;
	private String fechaProximaRevision;
	private String decisionRevision;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAsuId() {
		return asuId;
	}

	public void setAsuId(String asuId) {
		this.asuId = asuId;
	}

	public String getContratoId() {
		return contratoId;
	}

	public void setContratoId(String contratoId) {
		this.contratoId = contratoId;
	}

	public String getEjecucionIniciada() {
		return ejecucionIniciada;
	}

	public void setEjecucionIniciada(String ejecucionIniciada) {
		this.ejecucionIniciada = ejecucionIniciada;
	}

	public String getRevisadoA() {
		return revisadoA;
	}

	public void setRevisadoA(String revisadoA) {
		this.revisadoA = revisadoA;
	}

	public String getPropuestaEjecucion() {
		return propuestaEjecucion;
	}

	public void setPropuestaEjecucion(String propuestaEjecucion) {
		this.propuestaEjecucion = propuestaEjecucion;
	}

	public String getRevisadoB() {
		return revisadoB;
	}

	public void setRevisadoB(String revisadoB) {
		this.revisadoB = revisadoB;
	}
	
	public String getIniciarEjecucion() {
		return iniciarEjecucion;
	}

	public void setIniciarEjecucion(String iniciarEjecucion) {
		this.iniciarEjecucion = iniciarEjecucion;
	}

	public String getSolicitarSolvencia() {
		return solicitarSolvencia;
	}

	public void setSolicitarSolvencia(String solicitarSolvencia) {
		this.solicitarSolvencia = solicitarSolvencia;
	}

	public String getFechaSolicitarSolvencia() {
		return fechaSolicitarSolvencia;
	}

	public void setFechaSolicitarSolvencia(String fechaSolicitarSolvencia) {
		this.fechaSolicitarSolvencia = fechaSolicitarSolvencia;
	}

	public String getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(String fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	public String getDecisionB() {
		return decisionB;
	}

	public void setDecisionB(String decisionB) {
		this.decisionB = decisionB;
	}

	public String getRevisadoC() {
		return revisadoC;
	}

	public void setRevisadoC(String revisadoC) {
		this.revisadoC = revisadoC;
	}

	public String getDecisionC() {
		return decisionC;
	}

	public void setDecisionC(String decisionC) {
		this.decisionC = decisionC;
	}

	public String getFechaProximaRevision() {
		return fechaProximaRevision;
	}

	public void setFechaProximaRevision(String fechaProximaRevision) {
		this.fechaProximaRevision = fechaProximaRevision;
	}

	public String getDecisionRevision() {
		return decisionRevision;
	}

	public void setDecisionRevision(String decisionRevision) {
		this.decisionRevision = decisionRevision;
	}

}