package es.pfsgroup.plugin.rem.funciones;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.funciones.dao.FuncionesDao;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

@Service("funcionesManager")
public class FuncionesManager extends BusinessOperationOverrider<FuncionesApi> implements FuncionesApi {
	
	@Autowired
	private FuncionesDao funcionesDao;
	
	@Override
	public String managerName() {
		return "funcionesManager";
	}

	@Override
	public List<DtoFunciones> getFunciones(DtoFunciones funciones) {
		return funcionesDao.getFunciones(funciones);
	}

}
