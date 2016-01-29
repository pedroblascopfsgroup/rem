package es.pfsgroup.plugin.recovery.liquidaciones;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPago;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDModalidadCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

@Component("plugin.liquidaciones.cobroPagoManager")
public class LIQCobroPagoManager {

	@Autowired
	Executor executor;
	
	@Autowired
	GenericABMDao genericDao;

	@Autowired
	LIQCobroPagoDao cobroPagoDao;

    /**
     * Recupera una lista de CobroPago por Id.
     * @param id long
     * @return lista de CobroPago
     */
    @BusinessOperation(overrides = ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_LIST_BY_ASUNTO_ID)
    public List<LIQCobroPago> getListbyAsuntoId(Long id) {
    	List<LIQCobroPago> lista = cobroPagoDao.getByIdAsunto(id); 
        return lista;
    }
    
	/**
	 * Crea una instancia de CobroPago para el id de asunto indicado.
	 * 
	 * @param idAsunto
	 *            Long
	 * @return CobroPago
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET_INSTANCE)
	public LIQCobroPago getInstance(Long idAsunto) {
		EventFactory.onMethodStart(this.getClass());
		
		Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		LIQCobroPago cobroPago = new LIQCobroPago();
		cobroPago.setAsunto(asunto);
		cobroPago.setAuditoria(Auditoria.getNewInstance());
		
		EventFactory.onMethodStop(this.getClass());
		return cobroPago;
	}

	/**
	 * @param dtoCobroPago
	 *            DtoCobroPago
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_COBRO_PAGO_MGR_CREATE_OR_UPDATE)
	@Transactional(readOnly = false)
	public void createOrUpdate(LIQDtoCobroPago dtoCobroPago) {
		Assertions.assertNotNull(dtoCobroPago,
				"plugin.liquidaciones.liqcobropagomanager.dto.null");
		Assertions.assertNotNull(dtoCobroPago.getProcedimiento(),
				"Debe seleccionar una actuaci�n");
		LIQCobroPago cobroPago = dtoCobroPago.getLiqCobroPago();
		Procedimiento proc = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				dtoCobroPago.getProcedimiento());
		cobroPago.setProcedimiento(proc);
		if (!Checks.esNulo(cobroPago.getSubTipo()) && cobroPago.getSubTipo().getCodigo().equalsIgnoreCase("EC")) {
			if (Checks.esNulo(dtoCobroPago.getContrato())){
				throw new BusinessOperationException("plugin.liquidaciones.liqcobropagomanager.idcontrato.null");
			}
			Contrato cnt = (Contrato) executor.execute(
					PrimariaBusinessOperation.BO_CNT_MGR_GET, dtoCobroPago
							.getContrato());
			Assertions.assertNotNull(cnt, "plugin.liquidaciones.error.contrato.null");
			cobroPago.setContrato(cnt);
		}
		String origenCobro = dtoCobroPago.getOrigenCobro();
		
		if(origenCobro != null){
			DDOrigenCobro ddOrigenCobro = genericDao.get(DDOrigenCobro.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", origenCobro));
			Assertions.assertNotNull(ddOrigenCobro, "Origen de cobro no v�lido");
			cobroPago.setOrigenCobro(ddOrigenCobro);
		}
		
		String modalidadCobro = dtoCobroPago.getModalidadCobro();
		if(modalidadCobro != null){
			DDModalidadCobro ddModalidadCobro = genericDao.get(DDModalidadCobro.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", modalidadCobro));
			Assertions.assertNotNull(ddModalidadCobro, "Modalidad de cobro no v�lido");
			cobroPago.setModalidadCobro(ddModalidadCobro);
		}
		cobroPagoDao.saveOrUpdate(cobroPago);
	}

	/**
	 * @param id
	 *            Long
	 * @return CobroPago
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_COBRO_PAGO_MGR_GET)
	public LIQCobroPago get(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return cobroPagoDao.get(id);
	}
}
