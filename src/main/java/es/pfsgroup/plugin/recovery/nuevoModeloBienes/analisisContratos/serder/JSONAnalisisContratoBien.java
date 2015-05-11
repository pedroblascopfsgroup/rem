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
@JsonPropertyOrder({"id","ancId","bienId","codigo","origen","tipo","solicitarNoAfeccion","fechaSolicitarNoAfeccion","fechaResolucion","resolucion"})
public class JSONAnalisisContratoBien {

	@JsonProperty("id")
	private String id;
	@JsonProperty("ancId")
	private String ancId;
	@JsonProperty("bienId")
	private String bienId;
	@JsonProperty("codigo")
	private String codigo;
	@JsonProperty("origen")
	private String origen;
	@JsonProperty("tipo")
	private String tipo;
	@JsonProperty("solicitarNoAfeccion")
	private String solicitarNoAfeccion;
	@JsonProperty("fechaSolicitarNoAfeccion")
	private String fechaSolicitarNoAfeccion;
	@JsonProperty("fechaResolucion")
	private String fechaResolucion;
	@JsonProperty("resolucion")
	private String resolucion;
	
	private Map<String, Object> additionalProperties = new HashMap<String, Object>();

	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBienId() {
		return bienId;
	}
	public void setBienId(String bienId) {
		this.bienId = bienId;
	}
	public String getAncId() {
		return ancId;
	}
	public void setAncId(String ancId) {
		this.ancId = ancId;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getSolicitarNoAfeccion() {
		return solicitarNoAfeccion;
	}
	public void setSolicitarNoAfeccion(String solicitarNoAfeccion) {
		this.solicitarNoAfeccion = solicitarNoAfeccion;
	}
	public String getFechaSolicitarNoAfeccion() {
		return fechaSolicitarNoAfeccion;
	}
	public void setFechaSolicitarNoAfeccion(String fechaSolicitarNoAfeccion) {
		this.fechaSolicitarNoAfeccion = fechaSolicitarNoAfeccion;
	}
	public String getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(String fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public String getResolucion() {
		return resolucion;
	}
	public void setResolucion(String resolucion) {
		this.resolucion = resolucion;
	}

	@JsonAnyGetter
	public Map<String, Object> getAdditionalProperties() {
		return this.additionalProperties;
	}

	@JsonAnySetter
	public void setAdditionalProperties(Map<String, Object> additionalProperties) {
		this.additionalProperties = additionalProperties;
	}
	
}
