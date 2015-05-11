
package es.pfsgroup.recovery.recobroCommon.esquema.serder.recobroSubCarAgencias;

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
    "subCarAgenItems"
})
public class RecobroSubcarteraAgenciasGrid {

    @JsonProperty("subCarAgenItems")
    private List<SubCarAgenItem> subCarAgenItems = new ArrayList<SubCarAgenItem>();
    
    @JsonProperty("subCarRankingItems")
    private List<SubCarRankingItem> subCarRankingItems = new ArrayList<SubCarRankingItem>();
    
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();
    
    @JsonProperty("subCarAgenItems")
    public List<SubCarAgenItem> getSubCarAgenItems() {
        return subCarAgenItems;
    }

    @JsonProperty("subCarAgenItems")
    public void setSubCarAgenItems(List<SubCarAgenItem> subCarAgenItems) {
        this.subCarAgenItems = subCarAgenItems;
    }

    @JsonProperty("subCarRankingItems")
    public List<SubCarRankingItem> getSubCarRankingItems() {
    return subCarRankingItems;
    }

    @JsonProperty("subCarRankingItems")
    public void setSubCarRankingItems(List<SubCarRankingItem> subCarRankingItems) {
    this.subCarRankingItems = subCarRankingItems;
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
