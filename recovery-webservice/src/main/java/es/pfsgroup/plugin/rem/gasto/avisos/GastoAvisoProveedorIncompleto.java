package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Service("gastoAvisoProveedorIncompleto")
public class GastoAvisoProveedorIncompleto implements GastoAvisadorApi {

	protected static final Log logger = LogFactory.getLog(GastoAvisoProveedorIncompleto.class);
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
		boolean isProveedorIncompleto = false;
		
		isProveedorIncompleto = gastoProveedorApi.isProveedorIncompleto(gasto.getId());

		if(isProveedorIncompleto) {
			dtoAviso.setDescripcion("Proveedor Incompleto");
			dtoAviso.setId(String.valueOf(gasto.getId()));	
		}
		return dtoAviso;
	}
}
