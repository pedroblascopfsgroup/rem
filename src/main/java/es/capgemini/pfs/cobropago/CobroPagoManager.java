package es.capgemini.pfs.cobropago;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.dao.CobroPagoDao;
import es.capgemini.pfs.cobropago.dao.DDSubtipoCobroPagoDao;
import es.capgemini.pfs.cobropago.dto.DtoCobroPago;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.externa.ExternaBusinessOperation;

/**
 * Manager para CobroPago.
 * @author: Lisandro Medrano
 */
@Service
public class CobroPagoManager {
    @Autowired
    private CobroPagoDao cobroPagoDao;

    @Autowired
    private DDSubtipoCobroPagoDao subtipoCobroPagoDao;
    @Autowired
    private AsuntoDao asuntoDao;

    @Autowired
    private ProcedimientoDao procedimientoDao;

    /**
     * Recupera una lista de CobroPago.
     * @return lista de CobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_LIST)
    public List<CobroPago> getList() {
        return cobroPagoDao.getList();
    }

    /**
     * Recupera una lista de CobroPago por Id.
     * @param id long
     * @return lista de CobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_LIST_BY_ASUNTO_ID)
    public List<CobroPago> getListbyAsuntoId(Long id) {

        return cobroPagoDao.getByIdAsunto(id);
    }

    /**
     * Crea una instancia de CobroPago para el id de asunto indicado.
     * @param idAsunto Long
     * @return CobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_INSTANCE)
    public CobroPago getInstance(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        CobroPago cobroPago = new CobroPago();
        cobroPago.setAsunto(asunto);
        cobroPago.setAuditoria(Auditoria.getNewInstance());
        return cobroPago;
    }

    /**
     * @param id Long
     * @return CobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET)
    public CobroPago get(Long id) {
        return cobroPagoDao.get(id);
    }

    /**
     * @param dtoCobroPago DtoCobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_CREATE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void createOrUpdate(DtoCobroPago dtoCobroPago) {
        CobroPago cobroPago = dtoCobroPago.getCobroPago();
        Procedimiento proc = procedimientoDao.get(dtoCobroPago.getProcedimiento());
        cobroPago.setProcedimiento(proc);
        cobroPagoDao.saveOrUpdate(cobroPago);
    }

    /**
     * @param codigo String
     * @return Lista de DDSubtipoCobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_SUBTIPOS_COBROS_PAGOS_BY_TIPO)
    public List<DDSubtipoCobroPago> getSubtiposCobroPagoByTipo(String codigo) {
        return subtipoCobroPagoDao.getByTipo(codigo);
    }

    /**
     * @param idAsunto long
     * @return lista de procedimientos
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_PROCEDIMIENTOS_POR_ASUNTO)
    public List<Procedimiento> getProcedimientosPorAsunto(Long idAsunto) {
        return procedimientoDao.getProcedimientosAsunto(idAsunto);
    }

    /**
     * @param id CobroPago
     */
    @BusinessOperation(ExternaBusinessOperation.BO_COBRO_PAGO_MGR_DELETE)
    @Transactional(readOnly = false)
    public void delete(Long id) {
        cobroPagoDao.deleteById(id);
    }
}
