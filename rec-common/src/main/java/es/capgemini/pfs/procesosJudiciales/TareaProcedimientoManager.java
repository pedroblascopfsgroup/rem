package es.capgemini.pfs.procesosJudiciales;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.TareaProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

/**
 * PONER JAVADOC FO.
 * @author fo
 *
 */
@Service
public class TareaProcedimientoManager {
    @Autowired
    private TareaProcedimientoDao tareaProcedimientoDao;

    /**
     * PONER JAVADOC FO.
     * @param codigo codigo
     * @return tp
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET_BY_COD_TIPO_PROC)
    public List<TareaProcedimiento> getByCodigoTipoProcedimiento(String codigo) {
        return tareaProcedimientoDao.getByTipoProcedimiento(codigo);
    }

    /**
     * PONER JAVADOC FO.
     * @param idTipoProcedimiento id
     * @param codigoTarea codigo
     * @return tp
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET_BY_COD_TAREA_TIPO_PROC)
    public TareaProcedimiento getByCodigoTareaIdTipoProcedimiento(Long idTipoProcedimiento, String codigoTarea) {
        return tareaProcedimientoDao.getByCodigoTareaIdTipoProcedimiento(idTipoProcedimiento, codigoTarea);
    }

    @BusinessOperation(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET)
    public TareaProcedimiento get(Long id){
    	return tareaProcedimientoDao.get(id);
    }
}
