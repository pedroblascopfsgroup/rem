
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
@JsonPropertyOrder({
    "idAgencia",
    "NomAgencia",
    "coeficiente"
})
public class SubCarAgenItem {

    @JsonProperty("idAgencia")
    private Long idAgencia;
    @JsonProperty("NomAgencia")
    private String nomAgencia;
    @JsonProperty("coeficiente")
    private Integer coeficiente;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("idAgencia")
    public Long getIdAgencia() {
        return idAgencia;
    }

    @JsonProperty("idAgencia")
    public void setIdAgencia(Long idAgencia) {
        this.idAgencia = idAgencia;
    }

    @JsonProperty("NomAgencia")
    public String getNomAgencia() {
        return nomAgencia;
    }

    @JsonProperty("NomAgencia")
    public void setNomAgencia(String nomAgencia) {
        this.nomAgencia = nomAgencia;
    }

    @JsonProperty("coeficiente")
    public Integer getCoeficiente() {
        return coeficiente;
    }

    @JsonProperty("coeficiente")
    public void setCoeficiente(Integer coeficiente) {
        this.coeficiente = coeficiente;
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
