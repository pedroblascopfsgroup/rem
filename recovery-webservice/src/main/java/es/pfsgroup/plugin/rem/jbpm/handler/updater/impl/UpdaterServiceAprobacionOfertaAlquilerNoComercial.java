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
public class UpdaterServiceAprobacionOfertaAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAprobacionOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_APROBACION_OFERTA = "T018_AprobacionOferta";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		String estadoBc = null;
		
//		for(TareaExternaValor valor :  valores){
			//Falta poner que el alquiler sea de un tipo predeterminado tambien
//			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
//				if(DDSiNo.NO.equals(valor.getValor())) { 
//					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
//					expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoBc)));
//					genericDao.save(ExpedienteComercial.class, expedienteComercial);
//				}
//			}
//
//		}
			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_APROBACION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
