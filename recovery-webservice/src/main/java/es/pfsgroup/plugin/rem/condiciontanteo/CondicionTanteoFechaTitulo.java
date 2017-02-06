package es.pfsgroup.plugin.rem.condiciontanteo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.model.Activo;

@Service("condicionTanteoFechaTitulo")
public class CondicionTanteoFechaTitulo implements CondicionTanteoApi {
	//TODO: Fecha título o fecha auto adjudicación >08-04-2008

	protected static final Log logger = LogFactory.getLog(CondicionTanteoFechaTitulo.class);
	
	@Override
	public Boolean checkCondicion(Activo activo){
		return false;
	}
}
