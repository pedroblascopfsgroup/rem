package es.pfsgroup.recovery.ext.impl.contrato.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;

public interface EXTInfoAdicionalContratoDao extends AbstractDao<EXTInfoAdicionalContrato, Long>{

	public static final String BO_GET_LISTADO_EXTINFOADICIONALCONTRATO_BY_CNTID = "es.pfsgroup.recovery.ext.impl.contrato.dao.getListadoEXTInfoAdicionalContratoByCNTID";
	public static final String BO_GET_EXTINFOADICIONALCONTRATO_BY_ID = "es.pfsgroup.recovery.ext.impl.contrato.dao.getCEXTInfoAdicionalContratoByID";
	public static final String BO_GET_ESTADO_BLOQUEO_BY_CNTID = "es.pfsgroup.recovery.ext.impl.contrato.dao.getEstadoBloqueoByCNTID";

	/**
	 * Obtiene un listado de EXTInfoAdicionalContrato por el ID de contrato.
	 * 
	 * @param idContrato : el id de contrato.
	 * @return devuelve un objeto List<EXTInfoAdicionalContrato> relleno con la
	 * 			informacion de un contrato.
	 */
	@BusinessOperationDefinition(BO_GET_LISTADO_EXTINFOADICIONALCONTRATO_BY_CNTID)
	List<EXTInfoAdicionalContrato> getListadoEXTInfoAdicionalContratoByCNTID(Long idContrato);
	
	/**
	 * Obtiene un EXTInfoAdicionalContrato por su ID.
	 * 
	 * @param id : el id del EXTInfoAdicionalContrato.
	 * @return devuelve un objeto EXTInfoAdicionalContrato relleno con su informacion.
	 */
	@BusinessOperationDefinition(BO_GET_EXTINFOADICIONALCONTRATO_BY_ID)
	EXTInfoAdicionalContrato getEXTInfoAdicionalContratoByID(Long id);
	
	/**
	 * Obtiene el estado de bloqueo de un EXTInfoAdicionalContrato por el contrato ID.
	 * 
	 * @param id : el id del contrato.
	 * @return un String con la descripcion del bloqueo.
	 */
	@BusinessOperationDefinition(BO_GET_ESTADO_BLOQUEO_BY_CNTID)
	String getEstadoBloqueoByCNTID(Long idContrato);
}
