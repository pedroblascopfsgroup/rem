package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


@Service("gastoAvisoSinActivos")
public class GastoAvisoSinActivos implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoSinActivos.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();		
		
		if(gasto.getGastoLineaDetalleList() != null && !gasto.getGastoLineaDetalleList().isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gasto.getGastoLineaDetalleList()) {
				if(gastoLineaDetalle.getGastoLineaEntidadList().isEmpty() && !gastoLineaDetalle.esAutorizadoSinActivos()) {
					dtoAviso.setDescripcion("Tiene líneas sin elementos");
					dtoAviso.setId(String.valueOf(gasto.getId()));	
					break;
				}
			}
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}