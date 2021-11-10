package es.pfsgroup.plugin.rem.rest.dto;

import net.sf.json.JSONObject;

import java.io.Serializable;
import java.util.List;

public class AccionesCaixaDtoData implements Serializable {

    private List<JSONObject> dto;

    private String idAccion;

    public List<JSONObject> getDto() {
        return dto;
    }

    public void setDto(List<JSONObject> dto) {
        this.dto = dto;
    }

    public String getIdAccion() {
        return idAccion;
    }

    public void setIdAccion(String idAccion) {
        this.idAccion = idAccion;
    }
}
