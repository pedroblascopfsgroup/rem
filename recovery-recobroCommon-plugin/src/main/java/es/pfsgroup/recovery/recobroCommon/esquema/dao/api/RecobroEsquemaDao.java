package es.pfsgroup.recovery.recobroCommon.esquema.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

/**
 * Interfaz de acceso a base de datos para la clase RecobroEsquema
 * @author diana
 *
 */
public interface RecobroEsquemaDao extends AbstractDao<RecobroEsquema, Long>{
	
	/**
	 * Método que devuelve una página que contiene una lista de objetos RecobroEsquema
	 * Esta lista contendrá la lista de esquemas que cumplan los criterios de búsqueda
	 * Si no hay ningún criterio de búsqueda se devolverán todas los esquemas dados de 
	 * alta en la base de datos que no estén borrados (borrado=0)
	 * @param dto
	 * @return
	 */
	Page buscarRecobroEsquema(RecobroEsquemaDto dto);

	/**
	 * Método que devuelve la última versión del esquema recibido
	 * @param id dle esquema a buscar su ultima version
	 * @return última versión del esquema recibido
	 */
	RecobroEsquema getUltimaVersionDelEsquema(Long idEsquema);

	List<RecobroEsquema> getEsquemasBloqueados();
}
