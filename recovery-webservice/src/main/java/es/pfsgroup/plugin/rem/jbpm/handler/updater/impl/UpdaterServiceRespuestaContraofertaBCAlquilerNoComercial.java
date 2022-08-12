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
public class UpdaterServiceRespuestaContraofertaBCAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRespuestaContraofertaBCAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T018_RESPUESTA_CONTRAOFERTA_BC = "T018_RespuestaContraofertaBC";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean contraOfertaBc = false;
		boolean estadoBcModificado = false;
		boolean estadoModificado = false;
		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
		boolean alquilerSocial = tramiteAlquilerNoComercialApi.esAlquilerSocial(tareaExternaActual);
 		DDEstadoExpedienteBc estadoExpBC = null;
 		DDEstadosExpedienteComercial estadoExpComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					contraOfertaBc = true;
				}
			}

		}
		
		if (contraOfertaBc) {
			if (novacionRenovacion) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "730");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			} else if (alquilerSocial) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "360");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			}
		} else {
			if (novacionRenovacion) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "600");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			} else if (alquilerSocial) {
//				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "600");
//				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
//				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			}
		}

		expedienteComercial.setEstadoBc(estadoExpBC);
		estadoBcModificado = true;
		expedienteComercial.setEstado(estadoExpComercial);
		estadoModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_RESPUESTA_CONTRAOFERTA_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
