package es.pfsgroup.plugin.rem.gasto.avisos;

import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;


@Service("gastoAvisoActivoPagosRetenidos")
public class GastoAvisoActivoPagosRetenidos implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoActivoPagosRetenidos.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		boolean pagoRetenido = false;
		
		if(!Checks.estaVacio(gasto.getGastoProveedorActivos())) {
			
			for (GastoProveedorActivo gastoActivo: gasto.getGastoProveedorActivos()) {
				Activo activo = gastoActivo.getActivo(); 
				List<ActivoIntegrado> integraciones = activo.getIntegraciones();
				
				for(ActivoIntegrado integracion: integraciones) {
					
					if(gasto.getProveedor().equals(integracion.getProveedor())) {
						
						if(!Checks.esNulo(integracion.getRetenerPago()) && BooleanUtils.toBoolean(integracion.getRetenerPago())) {
							pagoRetenido = true;
						}
					}
				}
			}
			
		}
		
		if(pagoRetenido) {
			dtoAviso.setDescripcion("Pago retenido a nivel de activo");
			dtoAviso.setId(String.valueOf(gasto.getId()));	
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}