package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.TrabajoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;


@Service("trabajoGastoPrefactura")
public class TrabajoGastoPrefactura implements TrabajoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(TrabajoGastoPrefactura.class);
	
	@Override
	public DtoAviso getAviso(Trabajo trabajo, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();
		String mensaje = null;
		
		if(!Checks.esNulo(trabajo.getGastoTrabajo())) {
			GastoProveedor gasto = trabajo.getGastoTrabajo().getGastoLineaDetalle().getGastoProveedor();
			if (!Checks.esNulo(gasto)) {
				if (!DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo())) {
					mensaje = "Trabajo en gasto";
				}
			}
			if (!Checks.esNulo(trabajo.getPrefacturaTrabajo()) && !Checks.esNulo(trabajo.getPrefacturaTrabajo().getPrefactura()) 
					&& DDEstEstadoPrefactura.CODIGO_VALIDA.equals(trabajo.getPrefacturaTrabajo().getPrefactura().getEstadoPrefactura().getCodigo())) {
				if (mensaje != null) {
					mensaje += " y en prefactura validada";
				} else {
					mensaje = "Trabajo en prefactura validada";
				}
			}		
		}
		if (mensaje != null ) {
			dtoAviso.setDescripcion(mensaje);
			dtoAviso.setId(String.valueOf(trabajo.getId()));
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}