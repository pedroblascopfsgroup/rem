
package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder;

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
    "subCarteraItems"
})
public class EditModelosFacturacionSubcarterasItem {

    @JsonProperty("subCarteraItems")
    private List<SubCarteraItem> subCarteraItems = new ArrayList<SubCarteraItem>();
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("subCarteraItems")
    public List<SubCarteraItem> getSubCarteraItems() {
        return subCarteraItems;
    }

    @JsonProperty("subCarteraItems")
    public void setSubCarteraItems(List<SubCarteraItem> subCarteraItems) {
        this.subCarteraItems = subCarteraItems;
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
