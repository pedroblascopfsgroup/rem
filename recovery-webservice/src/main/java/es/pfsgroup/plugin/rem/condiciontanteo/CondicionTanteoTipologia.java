package es.pfsgroup.plugin.rem.condiciontanteo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;

@Service("condicionTanteoTipologia")
public class CondicionTanteoTipologia implements CondicionTanteoApi {
	
	protected static final Log logger = LogFactory.getLog(CondicionTanteoTipologia.class);
	
	/**
	 * Comprueba que el tipo de activo sea Vivienda
	 */
	@Override
	public Boolean checkCondicion(Activo activo){
		
		if(!Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo()))
			return true;
		
		return false;
	}
}