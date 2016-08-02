package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoValorDiccionario;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;

public interface DICDiccionarioModeloDao {

	boolean existeCodigoConBorrado(DICDtoValorDiccionario dto,String nombreTabla);
	
	void updateLineaDic(DICDtoValorDiccionario dto,String nombreTabla);
}
