package es.capgemini.pfs.procedimientoDerivado;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procedimientoDerivado.dao.ProcedimientoDerivadoDao;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;

/**
 * Creado el Thu Jan 15 12:48:24 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Service
public class ProcedimientoDerivadoManager {
    @Autowired
    private ProcedimientoDerivadoDao procedimientoDerivadoDao;

    /**
     * get list.
     * @return pd
     */
    @BusinessOperation(ExternaBusinessOperation.BO_PRC_DERIVADO_MGR_GET_LIST)
    public List<ProcedimientoDerivado> getList() {
        return procedimientoDerivadoDao.getList();
    }

    /**
     * get.
     * @param id id
     * @return pd
     */
    @BusinessOperation(ExternaBusinessOperation.BO_PRC_DERIVADO_MGR_GET)
    public ProcedimientoDerivado get(Long id) {
        return procedimientoDerivadoDao.get(id);
    }

    /**
     * createOrUpdate.
     * @param dtoProcedimientoDerivado dto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_PRC_DERIVADO_MGR_CREATE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void createOrUpdate(DtoProcedimientoDerivado dtoProcedimientoDerivado) {
        //TODO :implementar metodo
    }
    
    /**
     * Devuelve un ProcedimientoDerivado a partir del identificador único GUID
     * 
     * @param guid
     * @return
     */
	public ProcedimientoDerivado getProcedimientoDerivadoByGuid(String guid) {
		return procedimientoDerivadoDao.getByGuid(guid);
	}
}
