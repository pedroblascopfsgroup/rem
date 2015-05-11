package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
"arrayItems"
})
public class JSONAnalisisContratos {

	@JsonProperty("arrayItems")
	private List<JSONAnalisisContrato> arrayItems = new ArrayList<JSONAnalisisContrato>();
	private Map<String, Object> additionalProperties = new HashMap<String, Object>();

	@JsonProperty("arrayItems")
	public List<JSONAnalisisContrato> getArrayItems() {
	return arrayItems;
	}

	@JsonProperty("arrayItems")
	public void setArrayItems(List<JSONAnalisisContrato> arrayItems) {
	this.arrayItems = arrayItems;
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
