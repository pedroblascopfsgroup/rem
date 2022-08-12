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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;

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
	private static final String COMBO_CLIENTE_ACEPTA = "comboClienteAcepBorr";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean clienteAceptaBorrador = false;
		boolean estadoBcModificado = false;
		boolean estadoModificado = false;
		boolean subrogacionDacion = tramiteAlquilerNoComercialApi.esSubrogacionCompraVenta(tareaExternaActual);
		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
 		DDEstadoExpedienteBc estadoExpBC = null;
 		DDEstadosExpedienteComercial estadoExpComercial = null;
 		
		for(TareaExternaValor valor :  valores){
			if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) { 
					clienteAceptaBorrador = true;
				}
			}
		}
		
		if (clienteAceptaBorrador) {
			if (subrogacionDacion) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "770");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_COMUNICAR_SUBROGACION);
				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			} else if (novacionRenovacion) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "730");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
		} else {
			if (subrogacionDacion) {
//				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "770");
//				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			} else if (novacionRenovacion) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "750");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
		}
		
		expedienteComercial.setEstadoBc(estadoExpBC);
		estadoBcModificado = true;
		expedienteComercial.setEstado(estadoExpComercial);
		estadoModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_APROBACION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
