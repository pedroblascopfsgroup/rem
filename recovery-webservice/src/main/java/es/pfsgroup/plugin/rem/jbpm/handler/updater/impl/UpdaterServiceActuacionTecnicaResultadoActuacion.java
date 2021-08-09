


package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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
public class UpdaterServiceActuacionTecnicaResultadoActuacion implements UpdaterService {
	
	private static final String FECHA_FINALIZACION = "fechaFinalizacion";
	private static final String CODIGO_T004_RESULTADO_TARIFICADA = "T004_ResultadoTarificada";
	private static final String CODIGO_T004_RESULTADO_NOTARIFICADA = "T004_ResultadoNoTarificada";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	private GenericABMDao genericDao;
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor : valores){
			
			//Fecha Finalización
			if(FECHA_FINALIZACION.equals(valor.getNombre()))
			{	if(!Checks.esNulo(valor.getValor())){	
					try {
						trabajo.setFechaEjecucionReal(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				// Con fecha finalización: Trabajo -> Estado -> FINALIZADO PENDIENTE VALIDACION
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION);
				DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estadoTrabajo);
				
			}
		}
		genericDao.save(Trabajo.class, trabajo);
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_RESULTADO_TARIFICADA,CODIGO_T004_RESULTADO_NOTARIFICADA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

    
}
