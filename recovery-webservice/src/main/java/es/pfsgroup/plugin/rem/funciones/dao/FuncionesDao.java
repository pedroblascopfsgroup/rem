package es.pfsgroup.plugin.rem.funciones.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

public interface FuncionesDao extends AbstractDao<Funcion, Long> {

	List<DtoFunciones> getFunciones(DtoFunciones funciones);

	boolean userHasFunction(String username, String descripcion);
	
}
