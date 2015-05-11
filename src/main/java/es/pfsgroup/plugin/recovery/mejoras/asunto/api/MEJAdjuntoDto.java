package es.pfsgroup.plugin.recovery.mejoras.asunto.api;

import es.capgemini.pfs.asunto.model.AdjuntoAsunto;

public interface MEJAdjuntoDto {
	
	public String getUserIni();
	
	public String getTipoConsulta();
	
	public Boolean getPuedeBorrar();
	
	public AdjuntoAsunto getAdjunto();
	
	public String getTipoDocumento();

}
