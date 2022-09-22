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
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdenda;

@Component
public class UpdaterServiceAprobacionOfertaAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAprobacionOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_APROBACION_OFERTA = "T018_AprobacionOferta";
	private static final String COMBO_CLIENTE_ACEPTA = "comboAprobadoApi";
	private static final String COMBO_TIPO_ADENDA = "tipoAdenda";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean clienteAcepta = false;
		boolean subrogacionDacion = tramiteAlquilerNoComercialApi.esSubrogacionCompraVenta(tareaExternaActual);
		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
		boolean subrogacionHipotecaria = tramiteAlquilerNoComercialApi.esSubrogacionHipoteca(tareaExternaActual);
		boolean esAlquilerSocial = tramiteAlquilerNoComercialApi.esAlquilerSocial(tareaExternaActual);
		boolean tieneAdenda = false;
 		DDEstadoExpedienteBc estadoExpBC = null;
 		DDEstadosExpedienteComercial estadoExpComercial = null;
 		DDTipoAdenda tipoAdenda = null;
 		
		for(TareaExternaValor valor :  valores){
			if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) { 
					clienteAcepta = true;
				}
			}else if(COMBO_TIPO_ADENDA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				tipoAdenda = genericDao.get(DDTipoAdenda.class, filtro);
				if(!DDTipoAdenda.CODIGO_NO_APLICA_ADENDA.equals(valor.getValor())) {
					tieneAdenda = true;
				}
			}
		}
		
		if(esAlquilerSocial || novacionRenovacion) {
			if(clienteAcepta) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_BORRADOR_ACEPTADO);
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_GESTION_ADECUCIONES_CERTIFICACIONES_CLIENTE);
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
		}else if(subrogacionDacion) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_CONTRATO_FIRMADO);
			estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
		}else if(subrogacionHipotecaria) {
			if(tieneAdenda) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_ADENDA_NECESARIA);
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", DDEstadoExpedienteBc.CODIGO_C4C_CONTRATO_FIRMADO);
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
		}
		
		oferta.setTipoAdenda(tipoAdenda);
		expedienteComercial.setEstadoBc(estadoExpBC);
		expedienteComercial.setEstado(estadoExpComercial);
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		genericDao.save(Oferta.class, oferta);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_APROBACION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
