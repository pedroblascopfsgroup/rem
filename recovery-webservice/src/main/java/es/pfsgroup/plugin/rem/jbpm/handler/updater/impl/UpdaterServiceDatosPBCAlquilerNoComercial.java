package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceDatosPBCAlquilerNoComercial implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	private static final String CODIGO_T018_DATOSPBC = "T018_DatosPBC";
	private static final String COMBO_RESULTADO = "comboResultado";

	protected static final Log logger = LogFactory.getLog(UpdaterServiceDatosPBCAlquilerNoComercial.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		String comboResultado = null;
		String respuestaComprador = null;
	
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			for(TareaExternaValor valor :  valores){
				if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					comboResultado = valor.getValor();
				}
				
			}

			if(!Checks.esNulo(comboResultado)) {
				Boolean acepta = DDSinSiNo.cambioStringtoBooleano(comboResultado);
				String estadoCodigo = null;
				String estadoBcCodigo = null;
				if(acepta) {
					estadoCodigo = DDEstadosExpedienteComercial.PTE_PBC;
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_PTE_CALCULO_RIESGO;
				}else {
					estadoCodigo = DDEstadosExpedienteComercial.ANULADO;
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				}
				
				if(estadoBcCodigo != null) {
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBcCodigo));
					expediente.setEstadoBc(estadoBc);
				}
				
				if(estadoCodigo != null) {
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoCodigo));
					expediente.setEstado(estado);
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}

		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T018_DATOSPBC };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
