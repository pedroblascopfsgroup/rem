package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceComunAutorizacionPropietario implements
		UpdaterService {

	private static final String FECHA_AMPLIACION = "fecha";
	private static final String COMBO_AMPLIACION = "comboAmpliacion";
	private static final String IMPORTE_AMPLIACION = "numIncremento";
	private static final String CODIGO_T002_AUTORIZACION_PROPIETARIO = "T002_AutorizacionPropietario";
	private static final String CODIGO_T003_AUTORIZACION_PROPIETARIO = "T003_AutorizacionPropietario";
	private static final String CODIGO_T004_AUTORIZACION_PROPIETARIO = "T004_AutorizacionPropietario";
	private static final String CODIGO_T005_AUTORIZACION_PROPIETARIO = "T005_AutorizacionPropietario";
	private static final String CODIGO_T006_AUTORIZACION_PROPIETARIO = "T006_AutorizacionPropietario";
	
	@Autowired
	ActivoManager activoApi;

	@Autowired
	private GenericABMDao genericDao;

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, 
			List<TareaExternaValor> valores) {

		Activo activo = tramite.getActivo();
		Long idIncremento = activoApi.getPresupuestoActual(activo.getId());
		Filter filterIncremento = genericDao.createFilter(FilterType.EQUALS,"id", idIncremento);
		PresupuestoActivo presupuesto = genericDao.get(PresupuestoActivo.class,filterIncremento);
		Trabajo trabajo = tramite.getTrabajo();

		IncrementoPresupuesto nuevoIncremento = new IncrementoPresupuesto();
		nuevoIncremento.setPresupuestoActivo(presupuesto);
		nuevoIncremento.setTrabajo(tramite.getTrabajo());

		Boolean propietarioAcepta = Boolean.TRUE;

		for (TareaExternaValor valor : valores) {
			
			//el propietario no acepta
			if(COMBO_AMPLIACION.equals(valor.getNombre())){
				if(valor.getValor() != null && valor.getValor().equals(DDSiNo.NO)){
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_RECHAZADO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					genericDao.save(Trabajo.class, trabajo);

					propietarioAcepta = Boolean.FALSE;
				}
			}

			// Fecha ampliación presupuesto
			if (FECHA_AMPLIACION.equals(valor.getNombre())) {
				try {
					if(!Checks.esNulo(valor.getValor()))
						nuevoIncremento.setFechaAprobacion(ft.parse(valor.getValor()));
						trabajo.setFechaAutorizacionPropietario(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if (IMPORTE_AMPLIACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(!Checks.esNulo(valor.getValor())){
					nuevoIncremento.setImporteIncremento(valor.getValor());
				}
			}

		}

		if (propietarioAcepta) {
			genericDao.save(IncrementoPresupuesto.class, nuevoIncremento);	
		}
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos que ejecutan este guardado adicional
		return new String[] {CODIGO_T002_AUTORIZACION_PROPIETARIO, CODIGO_T003_AUTORIZACION_PROPIETARIO,
							 CODIGO_T005_AUTORIZACION_PROPIETARIO, CODIGO_T006_AUTORIZACION_PROPIETARIO,
							 CODIGO_T004_AUTORIZACION_PROPIETARIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
