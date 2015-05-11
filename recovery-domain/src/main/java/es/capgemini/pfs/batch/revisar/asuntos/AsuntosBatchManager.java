package es.capgemini.pfs.batch.revisar.asuntos;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.batch.revisar.asuntos.dao.AsuntosBatchDao;

/**
 * Manager de Asuntos.
 * @author jbosnjak
 *
 */
@Service
public class AsuntosBatchManager {

	@Autowired
	private AsuntosBatchDao asuntosDao;


	/**
	 * Busca los contratos de un asunto.
	 * @return contratos
	 */
	@BusinessOperation
	public List<Map<String, Object>> obtenerContratosAsunto(){
		return asuntosDao.obtenerAsuntosActivos();
	}

}
