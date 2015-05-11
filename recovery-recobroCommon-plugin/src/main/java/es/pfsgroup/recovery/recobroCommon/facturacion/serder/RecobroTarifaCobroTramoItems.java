
package es.pfsgroup.recovery.recobroCommon.facturacion.serder;

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
    "conceptosItems"
})
public class RecobroTarifaCobroTramoItems {

    @JsonProperty("conceptosItems")
    private List<ConceptosItem> conceptosItems = new ArrayList<ConceptosItem>();
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("conceptosItems")
    public List<ConceptosItem> getConceptosItems() {
        return conceptosItems;
    }

    @JsonProperty("conceptosItems")
    public void setConceptosItems(List<ConceptosItem> conceptosItems) {
        this.conceptosItems = conceptosItems;
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
