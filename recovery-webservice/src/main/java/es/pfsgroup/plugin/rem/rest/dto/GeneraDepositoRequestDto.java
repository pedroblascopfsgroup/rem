package es.pfsgroup.plugin.rem.rest.dto;

import es.pfsgroup.plugin.rem.model.GeneraDepositoDto;

import java.util.List;

public class GeneraDepositoRequestDto extends RequestDto {

    private List<GeneraDepositoDto> data;

    public List<GeneraDepositoDto> getData() {
        return data;
    }

    public void setData(List<GeneraDepositoDto> data) {
        this.data = data;
    }
}
