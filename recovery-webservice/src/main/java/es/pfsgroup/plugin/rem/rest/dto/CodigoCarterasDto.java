package es.pfsgroup.plugin.rem.rest.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

public class CodigoCarterasDto{

    private StringDataType codCartera;

    public StringDataType getCodCartera() {
        return codCartera;
    }

    public void setCodCartera(StringDataType codCartera) {
        this.codCartera = codCartera;
    }

}
