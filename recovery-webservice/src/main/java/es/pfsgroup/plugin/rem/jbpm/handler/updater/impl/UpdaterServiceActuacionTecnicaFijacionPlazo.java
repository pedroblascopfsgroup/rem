package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class UpdaterServiceActuacionTecnicaFijacionPlazo implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
	private static final String CODIGO_T004_FIJACION_PLAZO = "T004_FijacionPlazo";	
	
	private static final String FECHA_TOPE = "fechaTope";
	private static final String FECHA_CONCRETA = "fechaConcreta";
	private static final String HORA_CONCRETA = "horaConcreta";
	
	SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm");
	SimpleDateFormat formatoFechaHora = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		String fechaConcreta = null;
		
		for(TareaExternaValor valor :  valores){

			if(FECHA_TOPE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Se ha indicado una fecha tope para la realización de la tarea
				Date fechaTope = null;
				try {
					fechaTope = formatoFecha.parse(valor.getValor());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				trabajo.setFechaTope(fechaTope);
				trabajo.setFechaCompromisoEjecucion(fechaTope);
				trabajo.setFechaHoraConcreta(null); //Seteamos a null el otro campo por si ha cambiado el modo de asignación de fecha de concreta a tope.
			}
			if(FECHA_CONCRETA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Se ha indicado una fecha concreta junto con la hora
				 fechaConcreta = valor.getValor();

			}
			if(HORA_CONCRETA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				Date fechaHoraConcreta = null;
				try {
					fechaHoraConcreta = formatoFechaHora.parse(fechaConcreta+" "+valor.getValor());
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
								

					trabajo.setFechaHoraConcreta(fechaHoraConcreta);
					trabajo.setFechaCompromisoEjecucion(fechaHoraConcreta);
					trabajo.setFechaTope(null); //Análogo al caso anterior
			}
			
		}
		
		genericDao.save(Trabajo.class, trabajo);
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_FIJACION_PLAZO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
