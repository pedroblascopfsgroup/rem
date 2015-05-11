package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Generated;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("org.jsonschema2pojo")
@JsonPropertyOrder({
"id","asuId","contratoId","contrato","tipoContrato",
"ejecucionIniciada","revisadoA","propuestaEjecucion",
"iniciarEjecucion","revisadoB","solicitarSolvencia",
"fechaSolicitarSolvencia","fechaRecepcion","resultado",
"decisionB","revisadoC","decisionC",
"fechaProximaRevision","decisionRevision"
})
public class JSONAnalisisContrato {
	
	@JsonProperty("id")
	private String id;
	@JsonProperty("asuId")
	private String asuId;
	@JsonProperty("contratoId")
	private String contratoId;
	@JsonProperty("contrato")
	private String contrato;
	@JsonProperty("tipoContrato")
	private String tipoContrato;
	@JsonProperty("ejecucionIniciada")
	private String ejecucionIniciada;
	@JsonProperty("revisadoA")
	private String revisadoA;
	@JsonProperty("propuestaEjecucion")
	private String propuestaEjecucion;
	@JsonProperty("iniciarEjecucion")
	private String iniciarEjecucion;
	@JsonProperty("revisadoB")
	private String revisadoB;
	@JsonProperty("solicitarSolvencia")
	private String solicitarSolvencia;
	@JsonProperty("fechaSolicitarSolvencia")
	private String fechaSolicitarSolvencia;
	@JsonProperty("fechaRecepcion")
	private String fechaRecepcion;
	@JsonProperty("resultado")
	private String resultado;
	@JsonProperty("decisionB")
	private String decisionB;
	@JsonProperty("revisadoC")
	private String revisadoC;
	@JsonProperty("decisionC")
	private String decisionC;
	@JsonProperty("fechaProximaRevision")
	private String fechaProximaRevision;
	@JsonProperty("decisionRevision")
	private String decisionRevision;
	
	private Map<String, Object> additionalProperties = new HashMap<String, Object>();

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getContratoId() {
		return contratoId;
	}

	public void setContratoId(String contratoId) {
		this.contratoId = contratoId;
	}

	public String getAsuId() {
		return asuId;
	}

	public void setAsuId(String asuId) {
		this.asuId = asuId;
	}

	public String getContrato() {
		return contrato;
	}

	public void setContrato(String contrato) {
		this.contrato = contrato;
	}

	public String getTipoContrato() {
		return tipoContrato;
	}

	public void setTipoContrato(String tipoContrato) {
		this.tipoContrato = tipoContrato;
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

	public String getIniciarEjecucion() {
		return iniciarEjecucion;
	}

	public void setIniciarEjecucion(String iniciarEjecucion) {
		this.iniciarEjecucion = iniciarEjecucion;
	}

	public String getRevisadoB() {
		return revisadoB;
	}

	public void setRevisadoB(String revisadoB) {
		this.revisadoB = revisadoB;
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

	@JsonAnyGetter
	public Map<String, Object> getAdditionalProperties() {
		return additionalProperties;
	}

	@JsonAnySetter
	public void setAdditionalProperties(Map<String, Object> additionalProperties) {
		this.additionalProperties = additionalProperties;
	}
	
}
