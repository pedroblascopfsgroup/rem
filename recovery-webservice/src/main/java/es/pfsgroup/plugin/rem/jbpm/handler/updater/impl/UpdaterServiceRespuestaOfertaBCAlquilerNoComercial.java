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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceRespuestaOfertaBCAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRespuestaOfertaBCAlquilerNoComercial.class);
    
    private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T018_RESPUESTA_OFERTA_BC = "T018_RespuestaOfertaBC";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean realizaOfertaAlquiler = false;
		boolean estadoBcModificado = false;
		boolean estadoModificado = false;
 		DDEstadoExpedienteBc estadoExpBC = null;
 		DDEstadosExpedienteComercial estadoExpComercial = null;

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					realizaOfertaAlquiler = true;
				}
			}

		}
		
		if (realizaOfertaAlquiler) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "120");
			estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//			Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//			estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
		} else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "600");
			estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//			Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//			estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
		}
		
		expedienteComercial.setEstadoBc(estadoExpBC);
		estadoBcModificado = true;
		expedienteComercial.setEstado(estadoExpComercial);
		estadoModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_RESPUESTA_OFERTA_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
