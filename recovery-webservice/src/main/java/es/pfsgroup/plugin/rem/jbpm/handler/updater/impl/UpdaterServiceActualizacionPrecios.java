package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceActualizacionPrecios implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	private static final String CODIGO_T010_ANALISIS_PETICION_CARGA = "T010_AnalisisPeticionCargaList";
	private static final String CODIGO_T012_ANALISIS_PETICION_ACTUALIZACION_ESTADO = "T012_AnalisisPeticionActualizacionEstado";
	private static final String COMBO_ACEPTAR = "comboAceptacion";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, 
			List<TareaExternaValor> valores) {

		Trabajo trabajo = tramite.getTrabajo();

		for (TareaExternaValor valor : valores) {

			if (COMBO_ACEPTAR.equals(valor.getNombre())) {
				// Por defecto el trabajo pasará a 'Precios actualizados'y en
				// caso de que se deniegue a rechazado.
				Filter filter = genericDao.createFilter(FilterType.EQUALS,
						"codigo", DDEstadoTrabajo.ESTADO_FINALIZADO);

				if (valor.getValor().equals(DDSiNo.NO)) {
					filter = genericDao.createFilter(FilterType.EQUALS,
							"codigo", DDEstadoTrabajo.ESTADO_RECHAZADO);
					trabajo.setFechaRechazo(new Date());
				}
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class,
						filter);
				trabajo.setEstado(estado);
			}

			if (MOTIVO_DENEGACION.equals(valor.getNombre())
					&& !Checks.esNulo(valor.getValor())) {
				// Sólo podrá introducirlo cuando el combo de tramitar es NO
				trabajo.setMotivoRechazo(valor.getValor());
			}

		}
		genericDao.save(Trabajo.class, trabajo);

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[] { CODIGO_T010_ANALISIS_PETICION_CARGA, CODIGO_T012_ANALISIS_PETICION_ACTUALIZACION_ESTADO };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
