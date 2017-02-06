package es.pfsgroup.plugin.rem.condiciontanteo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.model.Activo;

@Service("condicionTanteoLocalizacion")
public class CondicionTanteoLocalizacion implements CondicionTanteoApi {
	//TODO: Localizados en los municipios de la tabla: CMU_CONFIG_MUNICIPIOS
	
	protected static final Log logger = LogFactory.getLog(CondicionTanteoLocalizacion.class);
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return false;
	}
}