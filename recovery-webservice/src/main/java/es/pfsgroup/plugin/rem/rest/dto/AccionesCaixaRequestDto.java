package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class AccionesCaixaRequestDto extends RequestDto {

    private List<AccionesCaixaDtoData> data;

    public List<AccionesCaixaDtoData> getData() {
        return data;
    }

    public void setData(List<AccionesCaixaDtoData> data) {
        this.data = data;
    }
}
