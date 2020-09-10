package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


@Service("gastoAvisoSinLineas")
public class GastoAvisoSinLineas implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoSinLineas.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();		
		
		if(gasto.getGastoLineaDetalleList() == null || gasto.getGastoLineaDetalleList().isEmpty()) {	
			dtoAviso.setDescripcion("El gasto no tiene ninguna línea de detalle");
			dtoAviso.setId(String.valueOf(gasto.getId()));	
		}

		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}