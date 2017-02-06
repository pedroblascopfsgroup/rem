package es.pfsgroup.plugin.rem.condiciontanteo;

import es.pfsgroup.plugin.rem.model.Activo;

public class CondicionTanteoFechaTitulo implements CondicionTanteoApi {
	//TODO: Fecha título o fecha auto adjudicación >08-04-2008
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return true;
	}
}
