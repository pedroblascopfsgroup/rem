package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


@Service("gastoAvisoPagosRetenidos")
public class GastoAvisoPagosRetenidos implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoPagosRetenidos.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		boolean pagoRetenido = false;
		
						
		if(!Checks.esNulo(gasto.getGastoGestion()) && !Checks.esNulo(gasto.getGastoGestion().getFechaRetencionPago())) {
			pagoRetenido = true;
		}			
		
		
		if(pagoRetenido) {
			dtoAviso.setDescripcion("Pago retenido a nivel de gasto");
			dtoAviso.setId(String.valueOf(gasto.getId()));	
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}