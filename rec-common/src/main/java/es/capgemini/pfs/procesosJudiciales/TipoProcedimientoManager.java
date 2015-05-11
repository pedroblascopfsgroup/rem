package es.capgemini.pfs.procesosJudiciales;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

@Service
public class TipoProcedimientoManager {

    @Autowired
    private TipoProcedimientoDao tipoProcedimientoDao;

    /**
     * Devuelve un listado de los procedimientos actuales
     * @return tp
     */
    @BusinessOperation
    public List<TipoProcedimiento> getTipoProcedimientos() {
        return tipoProcedimientoDao.getList();
    }

    /**
     * Devuelve un listado de los procedimientos actuales
     * @return tp
     */
    @BusinessOperation
    public List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoActuacion) {
        return tipoProcedimientoDao.getTipoProcedimientosPorTipoActuacion(codigoActuacion);
    }

    /**
     * Recupera el tipo procedimiento que concuerda con el código que se le pasa como parámetro
     * @param codigoTipoProcedimiento
     * @return
     */
    public TipoProcedimiento getByCodigo(String codigoTipoProcedimiento) {
        return tipoProcedimientoDao.getByCodigo(codigoTipoProcedimiento);
    }

}
