package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServiceAprobacionAlquilerSocialAlquilerNoComercial implements UpdaterService {
	
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAprobacionAlquilerSocialAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_APROBACION_ALQUILER_SOCIAL = "T018_AprobacionAlquilerSocial";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {


			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_APROBACION_ALQUILER_SOCIAL};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
