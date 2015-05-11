
package es.pfsgroup.recovery.recobroCommon.facturacion.serder;

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
    "id",
    "tabla",
    "campo",
    "valor"
})
public class ConceptosItem {

    @JsonProperty("id")
    private Long id;
    @JsonProperty("tabla")
    private String tabla;
    @JsonProperty("campo")
    private String campo;
    @JsonProperty("valor")
    private Float valor;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("id")
    public Long getId() {
        return id;
    }

    @JsonProperty("id")
    public void setId(Long id) {
        this.id = id;
    }

    @JsonProperty("tabla")
    public String getTabla() {
        return tabla;
    }

    @JsonProperty("tabla")
    public void setTabla(String tabla) {
        this.tabla = tabla;
    }

    @JsonProperty("campo")
    public String getCampo() {
        return campo;
    }

    @JsonProperty("campo")
    public void setCampo(String campo) {
        this.campo = campo;
    }

    @JsonProperty("valor")
    public Float getValor() {
        return valor;
    }

    @JsonProperty("valor")
    public void setValor(Float valor) {
        this.valor = valor;
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
