package es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias;

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
@JsonPropertyOrder({ "id", "posicion", "porcentaje" })
public class SubCarRankingItem {

	@JsonProperty("id")
	private Float id;
	@JsonProperty("posicion")
	private Integer posicion;
	@JsonProperty("porcentaje")
	private Integer porcentaje;
	private Map<String, Object> additionalProperties = new HashMap<String, Object>();

	@JsonProperty("id")
	public Float getId() {
		return id;
	}

	@JsonProperty("id")
	public void setId(Float id) {
		this.id = id;
	}

	@JsonProperty("posicion")
	public Integer getPosicion() {
		return posicion;
	}

	@JsonProperty("posicion")
	public void setPosicion(Integer posicion) {
		this.posicion = posicion;
	}

	@JsonProperty("porcentaje")
	public Integer getPorcentaje() {
		return porcentaje;
	}

	@JsonProperty("porcentaje")
	public void setPorcentaje(Integer porcentaje) {
		this.porcentaje = porcentaje;
	}

	@JsonAnyGetter
	public Map<String, Object> getAdditionalProperties() {
		return this.additionalProperties;
	}

	@JsonAnySetter
	public void setAdditionalProperty(String name, Object value) {
		this.additionalProperties.put(name, value);
	}

}
