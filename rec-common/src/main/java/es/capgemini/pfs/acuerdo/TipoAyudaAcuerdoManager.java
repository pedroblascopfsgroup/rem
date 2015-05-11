package es.capgemini.pfs.acuerdo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.DDTipoAyudaAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoAyudaAcuerdo;
import es.capgemini.pfs.comun.ComunBusinessOperation;

/**
 * Creado el Thu May 28 16:43:14 CEST 2009.
 * @author: Lisandro Medrano
 */
@Service
@Transactional
public class TipoAyudaAcuerdoManager {

	@Autowired
	Executor executor;
	
	@Autowired
    private DDTipoAyudaAcuerdoDao dDTipoAyudaAcuerdoDao;

    /**
     * Recupera la lista de tipos de acuerdo.
     * @return lista
     */
    @BusinessOperation
    public List<DDTipoAyudaAcuerdo> getList() {
        return dDTipoAyudaAcuerdoDao.getList();
    }

    /**
     * Recupera un tipo de acuerdo.
     * @param id Long
     * @return DDTipoAyudaAcuerdo
     */
    @BusinessOperation
    public DDTipoAyudaAcuerdo get(Long id) {
        return dDTipoAyudaAcuerdoDao.get(id);
    }

    /**
     * Recupera un tipo de acuerdo por codigo.
     * @param codigo String
     * @return DDTipoAyudaAcuerdo
     */
    @BusinessOperation
    public Object getByCodigo(String codigo) {
        return executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDTipoAyudaAcuerdo.class, codigo);
    }

}
