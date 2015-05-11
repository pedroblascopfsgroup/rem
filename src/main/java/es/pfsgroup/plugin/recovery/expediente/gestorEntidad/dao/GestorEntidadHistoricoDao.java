package es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.model.GestorEntidadHistorico;

public interface GestorEntidadHistoricoDao extends AbstractDao<GestorEntidadHistorico, Long> {

	public List<GestorEntidadHistorico> getListOrderedByEntidad(GestorEntidadDto dto);

	public void actualizarFechaHasta(Long idEntidad, Long idTipoGestor, String tipoEntidad);

}
