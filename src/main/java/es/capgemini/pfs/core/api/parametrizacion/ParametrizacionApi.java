package es.capgemini.pfs.core.api.parametrizacion;

import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ParametrizacionApi {

	@BusinessOperationDefinition(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE)
    public Parametrizacion buscarParametroPorNombre(String nombre);
}
