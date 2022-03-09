package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;

public interface LlamadaPBCApi {

	 public void callPBC(ExpedienteComercial eco, TareaActivo tarea);
}
