package es.pfsgroup.plugin.recovery.mejoras.despachoExterno.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

public interface MEJDespachoExternoDao extends AbstractDao<DespachoExterno, Long> {

	 public List<DespachoExterno> buscarDespachosPorTipoZona(String zonas, String tipoDespacho);
}
