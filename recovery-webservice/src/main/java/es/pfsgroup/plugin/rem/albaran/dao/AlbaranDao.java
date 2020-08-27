package es.pfsgroup.plugin.rem.albaran.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

public interface AlbaranDao extends AbstractDao<Albaran, Long>{
	
	public Page getAlbaranes(DtoAlbaranFiltro dto);
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran();
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura();
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo();
	
	public Page getPrefacturas(DtoDetalleAlbaran numAlbaran);
	
	public Page getTrabajos(DtoDetallePrefactura dto);
		
}
