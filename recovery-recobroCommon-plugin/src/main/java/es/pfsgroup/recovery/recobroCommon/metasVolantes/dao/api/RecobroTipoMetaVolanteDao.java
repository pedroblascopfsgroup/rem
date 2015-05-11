package es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroDDTipoMetaVolante;

/**
 * 
 * Interfaz de acceso a base de datos para la clase RecobroDDTipoMetaVolante
 * @author vanesa
 *
 */
public interface RecobroTipoMetaVolanteDao extends AbstractDao<RecobroDDTipoMetaVolante, Long>{

	
	/**
	 * Método que devuelve todas las metas volantes dadas de alta en el diccionario excepto las borradas
	 * @return lista de obtejos RecobroDDTipoMetaVolante
	 */
	List getMetasVolantes();
}
