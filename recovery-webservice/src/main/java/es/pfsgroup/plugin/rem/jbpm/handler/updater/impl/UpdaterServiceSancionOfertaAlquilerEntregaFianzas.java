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
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSancionOfertaAlquilerEntregaFianzas implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerEntregaFianzas.class);
    	
	private static final String COMBO_FIANZA = "comboFianza";
	

	private static final String CODIGO_T015_ENTREGA_FIANZAS = "T015_EntregaFianzas";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean fianzaAbonada = false;
		String estadoBC;
		String estadoHaya;
 		
 		for(TareaExternaValor valor :  valores){
			
			if(COMBO_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fianzaAbonada = DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor());
			}
		}
 		
 		if (fianzaAbonada) {
 			estadoBC = DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO;
 			estadoHaya = DDEstadosExpedienteComercial.PTE_FIRMA;
		} else {
			if(funcionesTramitesApi.seHaReagendado2VecesOMas(tareaExternaActual)) {
				estadoBC = DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_CONTRATO_POR_BC;
				estadoHaya = DDEstadosExpedienteComercial.PTE_RESPUESTA_BC;
			}else {
				estadoBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
				estadoHaya = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
			}
		}
 		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoHaya)));
 		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
 		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);	
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ENTREGA_FIANZAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
}
