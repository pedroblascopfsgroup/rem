package es.pfsgroup.plugin.recovery.mejoras.evento.model;

import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

public class MEJEvento extends Evento{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6884136703447144655L;
	private Long idTraza;

	
	public MEJEvento(TareaNotificacion tarea, int tipoEvento,Long idTraza) {
        setTarea(tarea);
        setTipoEvento(tipoEvento);
        setIdTraza(idTraza);
    }
	public void setIdTraza(Long idTraza) {
		this.idTraza = idTraza;
	}

	public Long getIdTraza() {
		return idTraza;
	}

}
