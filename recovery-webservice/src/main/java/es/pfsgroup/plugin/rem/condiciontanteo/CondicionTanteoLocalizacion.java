package es.pfsgroup.plugin.rem.condiciontanteo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ConfiguracionMunicipios;

@Service("condicionTanteoLocalizacion")
public class CondicionTanteoLocalizacion implements CondicionTanteoApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	protected static final Log logger = LogFactory.getLog(CondicionTanteoLocalizacion.class);
	
	/**
	 * Comprueba si el activo pertenece a la tabla CMU_CONFIG_MUNICIPIOS
	 */
	@Override
	public Boolean checkCondicion(Activo activo){
		
		if(!Checks.esNulo(activo.getLocalidad())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "localidad.id", activo.getLocalidad().getId());
			ConfiguracionMunicipios configMunicipio = genericDao.get(ConfiguracionMunicipios.class, filtro);
			
			if(!Checks.esNulo(configMunicipio))
				return true;
		}
		
		return false;
	}
}