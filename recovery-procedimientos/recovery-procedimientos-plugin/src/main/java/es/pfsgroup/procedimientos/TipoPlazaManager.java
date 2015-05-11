package es.pfsgroup.procedimientos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.procedimientos.PluginProcedimientosConstantsComponents;
import es.pfsgroup.procedimientos.dao.TipoPlazaDao;
import es.pfsgroup.procedimientos.dto.DtoQuery;

@Component(PluginProcedimientosConstantsComponents.MGR_TIPO_PLAZA)
public class TipoPlazaManager {

	@Autowired
	private TipoPlazaDao tipoPlazaDao;
	
	/**
	 * Busca plazas que contengan la subcaden especificada en la descripción. No
	 * distingue mayúsculas de minúsculas
	 * 
	 * @param dto DTO con la búsqueda. Soporta paginación
	 * @return Devuelve los resultados paginados
	 */
	@BusinessOperation(PluginProcedimientosConstantsBO.FIND_TIPO_PLAZA_BY_DESC)
	public Page buscarPorDescripcion(DtoQuery dto){
		return tipoPlazaDao.buscarPorDescripcion(dto);
	}
	
	/**
	 * Busca la pagina donde se encuentra la plaza siendo cada pagina de 10  
	 * 
	 * @param codigo de la plaza
	 * @return Devuelve la pagina a en la que se encuentra la plaza recivida
	 */
	@BusinessOperation(PluginProcedimientosConstantsBO.FIND_PAGINA_PLAZA_BY_COD)
	public int buscarPorDescripcion(String codigo){
		int pagina = 0;
		int i = 0;
		for (TipoPlaza p : tipoPlazaDao.getListOrderedByDescripcion()){
			if (p.getCodigo().compareTo(codigo)==0) {
				pagina = i;
				break;				
			}
			i += 1;
		}	
		return pagina;
	}	
}
