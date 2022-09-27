package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;

@Component
public class UpdaterServiceAgendarFirmaAdendaNoComercial implements UpdaterService {
	
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarFirmaAdendaNoComercial.class);
    

	private static final String CODIGO_T018_AGENDAR_FIRMA_ADENDA = "T018_AgendarFirmaAdenda";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDAR_FIRMA_ADENDA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
