package es.pfsgroup.framework.paradise.gestorEntidad.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;


public interface GestorEntidadHistoricoDao extends AbstractDao<GestorEntidadHistorico, Long> {

	public List<GestorEntidadHistorico> getListGestorActivoOrderedByEntidad(GestorEntidadDto dto);
	public List<GestorEntidadHistorico> getListOrderedByEntidad(GestorEntidadDto dto);

	public void actualizarFechaHasta(Long idEntidad, Long idTipoGestor, String tipoEntidad);

}
