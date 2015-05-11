package es.capgemini.pfs.parametrizacion;

import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;

@Component
public class EXTParametrizacionManager extends BusinessOperationOverrider<ParametrizacionApi> implements ParametrizacionApi{

	@Override
	public String managerName() {
		return "parametrizacionManager";
	}

	 /**
     * Busca el parametro que corresponda al nombre indicado.
     * Lanza error de parametrizacion si no existe o hay mas de un parámetro.
     * @param nombre string
     * @return Parametrizacion
     */
	@Override
	@BusinessOperation(overrides=ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE)
	public Parametrizacion buscarParametroPorNombre(String nombre) {
		return parent().buscarParametroPorNombre(nombre);
	}

}
