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
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;

@Component
public class UpdaterServiceCalculoRiesgoAlquilerNoComercial implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	private static final String CODIGO_T018_CALCULO_RIESGO = "T018_CalculoRiesgo";
	private static final String COMBO_RIESGO = "comboRiesgo";

	protected static final Log logger = LogFactory.getLog(UpdaterServiceCalculoRiesgoAlquilerNoComercial.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		String comboResultado = null;
		String respuestaComprador = null;
	
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			for(TareaExternaValor valor :  valores){
				if(COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					comboResultado = valor.getValor();
				}
				
			}

			if(!Checks.esNulo(comboResultado)) {
				String estadoCodigo = null;
				String estadoBcCodigo = null;
				estadoCodigo = DDEstadosExpedienteComercial.PTE_PBC;
				if(DDRiesgoOperacion.CODIGO_ROP_NO_APLICA.equals(comboResultado)) {
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
				}else{
					estadoBcCodigo = DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER;
				}
				
				if(estadoBcCodigo != null) {
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBcCodigo));
					expediente.setEstadoBc(estadoBc);
					estadoBcModificado = true;
				}
				
				if(estadoCodigo != null) {
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoCodigo));
					expediente.setEstado(estado);
				}
				
				DDRiesgoOperacion riesgo = genericDao.get(DDRiesgoOperacion.class, genericDao.createFilter(FilterType.EQUALS,"codigo", comboResultado));
				if(riesgo != null) {
					expediente.getOferta().getOfertaCaixa().setRiesgoOperacion(riesgo);
				}
				
				genericDao.save(ExpedienteComercial.class, expediente);
				
				if(estadoBcModificado) {
					ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpedienteAndRespuestaComprador(expediente, respuestaComprador));
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T018_CALCULO_RIESGO };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
