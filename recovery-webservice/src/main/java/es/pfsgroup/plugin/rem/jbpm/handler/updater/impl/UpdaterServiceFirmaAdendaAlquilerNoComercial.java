package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
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
import es.pfsgroup.plugin.rem.model.HistoricoFirmaAdenda;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;

@Component
public class UpdaterServiceFirmaAdendaAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaAdendaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_FIRMA_ADENDA = "T018_FirmaAdenda";
	private static final String COMBO_ACEPTA_FIRMA = "comboResultado";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DDEstadoExpedienteBc estadoExpBC = null;
		
		Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta", oferta);
		List<HistoricoFirmaAdenda> historicosFirmasAdendas = genericDao.getList(HistoricoFirmaAdenda.class, filtroOferta);
		HistoricoFirmaAdenda historicoFirmaAdenda = new HistoricoFirmaAdenda();
		
		for(TareaExternaValor valor :  valores){
			if(COMBO_ACEPTA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) { 
					historicoFirmaAdenda.setFirmadoAdenda(1);
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_CONTRATO_FIRMADO);
					estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
				}else {
					historicoFirmaAdenda.setFirmadoAdenda(0);
					if(historicosFirmasAdendas != null && !historicosFirmasAdendas.isEmpty()) {
						if(historicosFirmasAdendas.size() > 2) {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_IMPOSIBILIDAD_FIRMA);
							estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
						}
					}
				}
			}
		}
		
		historicoFirmaAdenda.setFechaAdenda(new Date());
		historicoFirmaAdenda.setOferta(oferta);
		expedienteComercial.setEstadoBc(estadoExpBC);
				
		if(historicoFirmaAdenda != null) {
			genericDao.save(HistoricoFirmaAdenda.class, historicoFirmaAdenda);
		}
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_FIRMA_ADENDA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
