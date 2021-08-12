package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;

@Component
public class UpdaterServiceComunAutorizacionBankia implements
		UpdaterService {

	private static final String FECHA_AMPLIACION = "fecha";
	private static final String COMBO_AMPLIACION = "comboAmpliacion";
	private static final String CODIGO_T004_AUTORIZACION_BANKIA = "T004_AutorizacionBankia";
	private static final String CODIGO_T002_AUTORIZACION_BANKIA = "T002_AutorizacionBankia";
	private static final String CODIGO_T003_AUTORIZACION_BANKIA = "T003_AutorizacionBankia";
	
	@Autowired
	ActivoManager activoApi;

	@Autowired
	TrabajoApi trabajoApi;
	
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
		
		Date fechaIncremento = new Date();
		String valorComboIncremento = DDSiNo.NO;
		
		// Recupera los valores de la tarea
		for (TareaExternaValor valor : valores) {

			// Fecha ampliación presupuesto
			if (FECHA_AMPLIACION.equals(valor.getNombre())) {
				try {
					if(!Checks.esNulo(valor.getValor()))
						fechaIncremento = ft.parse(valor.getValor());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			// Ampliacion presupuesto
			if (COMBO_AMPLIACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				valorComboIncremento = valor.getValor();
			}
		}
		
		// TEniendo los datos de la tarea
		// Evalua si es necesario hacer un incremento de presupuesto
		if(DDSiNo.SI.equals(valorComboIncremento)){
			try{
			
				if(trabajoApi.checkSuperaPresupuestoActivo(tramite.getTrabajo())){
					// Crea un nuevo incremento
					IncrementoPresupuesto nuevoIncremento = new IncrementoPresupuesto();
					nuevoIncremento.setPresupuestoActivo(presupuesto);
					nuevoIncremento.setTrabajo(tramite.getTrabajo());
					
					// Actualiza la fecha de incremento
					if(!Checks.esNulo(fechaIncremento)){
						nuevoIncremento.setFechaAprobacion(fechaIncremento);
					}
					// Establece valores del incremento, viendo el exceso de presupuesto
					Float importeExcesoPresupuesto = trabajoApi.getExcesoPresupuestoActivo(tramite.getTrabajo());
					nuevoIncremento.setImporteIncremento(importeExcesoPresupuesto);
					
					genericDao.save(IncrementoPresupuesto.class, nuevoIncremento);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos que ejecutan este guardado adicional
		return new String[] {CODIGO_T004_AUTORIZACION_BANKIA, CODIGO_T002_AUTORIZACION_BANKIA, 
				CODIGO_T003_AUTORIZACION_BANKIA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
