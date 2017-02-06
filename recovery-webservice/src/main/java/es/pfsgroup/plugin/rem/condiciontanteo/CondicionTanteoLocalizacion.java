package es.pfsgroup.plugin.rem.condiciontanteo;

import es.pfsgroup.plugin.rem.model.Activo;

public class CondicionTanteoLocalizacion implements CondicionTanteoApi {
	//TODO: Localizados en los municipios de la tabla: CMU_CONFIG_MUNICIPIOS
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return true;
	}
}