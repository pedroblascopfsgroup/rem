package es.pfsgroup.procedimientos.web;

import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PROTareaExternaManagerApi {

	@BusinessOperationDefinition("recovery.plugin.procedimientos.guardarTareaExterna")
	public void guardarTareaExternaValor(TareaExternaValor tev,EXTTareaExterna tex, EXTTareaNotificacion tar);
}
