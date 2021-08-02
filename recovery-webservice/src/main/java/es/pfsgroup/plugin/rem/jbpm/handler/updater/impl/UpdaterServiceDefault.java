package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServiceDefault implements UpdaterService {
	

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{DEFAULT_SERVICE_BEAN_KEY};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
