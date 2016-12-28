package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


@Service("gastoAvisoProveedorPagosRetenidos")
public class GastoAvisoProveedorPagosRetenidos implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoProveedorPagosRetenidos.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		if(!Checks.esNulo(gasto.getProveedor().getRetener()) && BooleanUtils.toBoolean(gasto.getProveedor().getRetener())) {
			dtoAviso.setDescripcion("Pago retenido a nivel de proveedor");
			dtoAviso.setId(String.valueOf(gasto.getId()));	
			
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}