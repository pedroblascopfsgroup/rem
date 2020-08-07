package es.pfsgroup.plugin.rem.albaran.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

public interface AlbaranDao extends AbstractDao<Albaran, Long>{
	
	public DtoPage getAlbaranes(DtoAlbaranFiltro dto);
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran();
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura();
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo();
	
}
