package es.capgemini.pfs.contrato.dao;

import java.util.List;

import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * AdjuntosContrato.
 * @author pamuller
 *
 */

public interface AdjuntoContratoDao extends AbstractDao<AdjuntoContrato, Long> {

	public List<AdjuntoContrato> getAdjuntoContratoByIdDocumento(List<Integer> idsDocumento);
}
