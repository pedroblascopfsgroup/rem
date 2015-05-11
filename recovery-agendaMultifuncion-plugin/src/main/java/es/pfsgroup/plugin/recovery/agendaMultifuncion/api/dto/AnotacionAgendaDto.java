package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

import java.util.HashMap;
import java.util.Map;

import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;

public class AnotacionAgendaDto {

	
	private EXTTareaNotificacion tarea;
	
	private MEJRegistroInfo traza;

	private Map<String, String> detalle;
	
	
	public AnotacionAgendaDto(EXTTareaNotificacion tarea,
			MEJRegistroInfo traza) {
		super();
		this.tarea = tarea;
		this.traza = traza;
	}

	public EXTTareaNotificacion getTarea(){
		return this.tarea;
	}
	
	public MEJRegistroInfo getTraza(){
		return this.traza;
	}
	
	public Map<String, String> getDetalleTraza(){
		if (this.detalle == null){
			inicializaDetalle();
		}
		return this.detalle;
		
	}

	private void inicializaDetalle() {
		if ((traza == null) || Checks.estaVacio(traza.getInfoRegistro())){
			return;
		}
		
		this.detalle = new HashMap<String, String>();
		
		for (ClaveValor cv : traza.getInfoRegistro()){
			this.detalle.put(cv.getClave(), cv.getValor());
		}
	}

}
