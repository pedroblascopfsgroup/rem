package es.pfsgroup.plugin.rem.jbpm;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface ValidateJbpmApi {

	public String definicionOfertaT013(TareaExterna tareaExterna) ;

	public String respuestaOfertanteT013(TareaExterna tareaExterna);

	public String ratificacionComiteT013(TareaExterna tareaExterna);
	
	public String resolucionComiteT013(TareaExterna tareaExterna);
	
}
