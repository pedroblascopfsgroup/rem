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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;

@Component
public class UpdaterServiceComunicarSubrogacionAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceComunicarSubrogacionAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String COMBO_COM_SUBROGACION = "comboComSubrogacion";
	private static final String CODIGO_T018_COMUNICAR_SUBROGACION = "T018_ComunicarSubrogacion";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean tituloObtenido = false;
		boolean comunicarSubrogacion = false;
		boolean estadoBcModificado = false;
		boolean estadoModificado = false;
 		DDEstadoExpedienteBc estadoExpBC = null;
 		DDEstadosExpedienteComercial estadoExpComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					tituloObtenido = true;
				}
			}
			if(COMBO_COM_SUBROGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					comunicarSubrogacion = true;
				}
			}
		}
		
		if (tituloObtenido && comunicarSubrogacion) {
			if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(oferta.getSubtipoOfertaAlquiler().getCodigo())) {
				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_FIRMA);
				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			} else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_EJECUCION.equals(oferta.getSubtipoOfertaAlquiler().getCodigo())) {
//				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "730");
//				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
		} else {
			if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_DACION.equals(oferta.getSubtipoOfertaAlquiler().getCodigo())) {
//				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "770");
//				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
//				Filter filtroEstadoExpComer = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_COMUNICAR_SUBROGACION);
//				estadoExpComercial = genericDao.get(DDEstadosExpedienteComercial.class,filtroEstadoExpComer);
			} else if (DDSubtipoOfertaAlquiler.CODIGO_SUBROGACION_EJECUCION.equals(oferta.getSubtipoOfertaAlquiler().getCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA);
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
				genericDao.save(ExpedienteComercial.class, expedienteComercial);
			}
		}

		expedienteComercial.setEstadoBc(estadoExpBC);
		estadoBcModificado = true;
		expedienteComercial.setEstado(estadoExpComercial);
		estadoModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_COMUNICAR_SUBROGACION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
