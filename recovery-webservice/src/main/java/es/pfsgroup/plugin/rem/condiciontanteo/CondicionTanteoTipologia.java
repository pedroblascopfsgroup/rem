package es.pfsgroup.plugin.rem.condiciontanteo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.model.Activo;

@Service("condicionTanteoTipologia")
public class CondicionTanteoTipologia implements CondicionTanteoApi {
	//TODO: Tipologia = Vivienda
	
	protected static final Log logger = LogFactory.getLog(CondicionTanteoTipologia.class);
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return false;
	}
}