
package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder;

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
    "idSubcarteraFacturacion",
    "campo",
    "valor"
})
public class SubCarteraItem {

    @JsonProperty("idSubcarteraFacturacion")
    private Long idSubcarteraFacturacion;
    @JsonProperty("campo")
    private String campo;
    @JsonProperty("valor")
    private Long valor;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("idSubcarteraFacturacion")
    public Long getIdSubcarteraFacturacion() {
        return idSubcarteraFacturacion;
    }

    @JsonProperty("idSubcarteraFacturacion")
    public void setIdSubcarteraFacturacion(Long idSubcarteraFacturacion) {
        this.idSubcarteraFacturacion = idSubcarteraFacturacion;
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
    public Long getValor() {
        return valor;
    }

    @JsonProperty("valor")
    public void setValor(Long valor) {
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
