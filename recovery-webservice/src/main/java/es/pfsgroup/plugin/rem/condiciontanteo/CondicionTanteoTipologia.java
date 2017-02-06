package es.pfsgroup.plugin.rem.condiciontanteo;

import es.pfsgroup.plugin.rem.model.Activo;

public class CondicionTanteoTipologia implements CondicionTanteoApi {
	//TODO: Tipologia = Vivienda
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return true;
	}
}
