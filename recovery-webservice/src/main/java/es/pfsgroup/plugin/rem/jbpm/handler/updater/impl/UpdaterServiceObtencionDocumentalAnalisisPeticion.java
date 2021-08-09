package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceObtencionDocumentalAnalisisPeticion implements UpdaterService {

	private static final String CODIGO_T008_ANALISIS_PETICION = "T008_AnalisisPeticion";
	private static final String COMBO_TRAMITAR = "comboTramitar";
	private static final String MOTIVO_DENEGAR = "motivoDenegar";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Trabajo trabajo = tramite.getTrabajo();

		boolean tramitar = true;
		String motivoDenegado = null;
		
		for (TareaExternaValor valor : valores) {
			if (COMBO_TRAMITAR.equals(valor.getNombre())) {
				tramitar = DDSiNo.SI.equals(valor.getValor());
			}

			if (MOTIVO_DENEGAR.equals(valor.getNombre())) {
				motivoDenegado = valor.getValor();
			}
		}

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo",
				tramitar ? DDEstadoTrabajo.ESTADO_EN_TRAMITE : DDEstadoTrabajo.ESTADO_RECHAZADO);

		DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
		trabajo.setEstado(estado);

		if (!tramitar) {
			trabajo.setMotivoRechazo(motivoDenegado != null ? motivoDenegado : "Motivo desconocido");
		}

		genericDao.save(Trabajo.class, trabajo);
		
		if(activoDao.isActivoMatriz(trabajo.getActivo().getId())){
			ActivoTrabajo actTrabajo = genericDao.get(ActivoTrabajo.class,genericDao.createFilter(FilterType.EQUALS,"trabajo.id", trabajo.getId()));
			activoApi.actualizarOfertasTrabajosVivos(actTrabajo.getActivo());
		}
		else {
			activoApi.actualizarOfertasTrabajosVivos(trabajo.getActivo());
		}

	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T008_ANALISIS_PETICION };
	}

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
