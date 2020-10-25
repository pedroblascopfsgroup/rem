package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.Activo;
import org.springframework.ui.ModelMap;

public interface RecoveryComunicacionApi {

    void datosCliente(Activo activo, ModelMap model);

}
