package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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

@Component
public class UpdaterServiceComunAutorizacionPropietario implements
		UpdaterService {

	private static final String FECHA_AMPLIACION = "fecha";
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
	public void saveValues(ActivoTramite tramite,
			List<TareaExternaValor> valores) {

		Activo activo = tramite.getActivo();
		Long idIncremento = activoApi.getUltimoPresupuesto(activo.getId());
		Filter filterIncremento = genericDao.createFilter(FilterType.EQUALS,"id", idIncremento);
		PresupuestoActivo presupuesto = genericDao.get(PresupuestoActivo.class,filterIncremento);

		IncrementoPresupuesto nuevoIncremento = new IncrementoPresupuesto();
		nuevoIncremento.setPresupuestoActivo(presupuesto);
		nuevoIncremento.setTrabajo(tramite.getTrabajo());

		for (TareaExternaValor valor : valores) {

			// Fecha ampliación presupuesto
			if (FECHA_AMPLIACION.equals(valor.getNombre())) {
				try {
					if(!Checks.esNulo(valor.getValor()))
						nuevoIncremento.setFechaAprobacion(ft.parse(valor.getValor()));
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
		genericDao.save(IncrementoPresupuesto.class, nuevoIncremento);

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
