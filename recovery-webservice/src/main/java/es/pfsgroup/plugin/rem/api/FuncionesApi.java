package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

public interface FuncionesApi {

	List<DtoFunciones> getFunciones(DtoFunciones funciones);
	
}
