package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSancionOfertaAlquilerNegociacionClausulasAlquiler implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerNegociacionClausulasAlquiler.class);
    	
	private static final String COMBO_ACEPTA = "comboAcepta";
	
	private static final String CODIGO_T015_NEGOCIACION_CLAUSULAS_ALQUILER = "T015_NegociacionClausulasAlquiler";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean aprueba = false;
		String estadoBc = null;
		String estadoHaya = null;
		
		for(TareaExternaValor valor :  valores) {
			
			if(COMBO_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				aprueba = DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor());
			}
		}
		
		if(aprueba) {
			estadoBc =  DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
			estadoHaya = DDEstadosExpedienteComercial.PTE_TRASLADAR_OFERTA_AL_CLIENTE;
		}else {
			estadoBc = DDEstadoExpedienteBc.CODIGO_CLAUSULADO_NO_COMERCIABLE;
			estadoHaya = DDEstadosExpedienteComercial.PTE_CLAUSULAS_CLIENTE;
		}
		
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoHaya)));

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_NEGOCIACION_CLAUSULAS_ALQUILER};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
}
