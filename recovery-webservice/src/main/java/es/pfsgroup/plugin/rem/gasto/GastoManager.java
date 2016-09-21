package es.pfsgroup.plugin.rem.gasto;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.GastosProveedor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaTitularAdicionalDto;

@Service("gastoManager")
public class GastoManager extends BusinessOperationOverrider<OfertaApi> implements  GastoApi {
	
	
	protected static final Log logger = LogFactory.getLog(GastoManager.class);
	
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao;

	@Override
	public String managerName() {
		return "gastoManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	
	
	
	@Override
	public GastosProveedor getGastoById(Long id){		
		GastosProveedor gastoProveedor = null;
		
		try{
			
			gastoProveedor = gastoDao.get(id);
		
		} catch(Exception ex) {
			ex.printStackTrace();			
		}
		
		return gastoProveedor;
	}
	
	
	
	
	
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		return gastoDao.getListGastos(dtoGastosFilter);
	}
	
	
}
