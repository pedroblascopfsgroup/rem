package es.pfsgroup.plugin.rem.gasto.avisos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;


@Service("gastoAvisoEstado")
public class GastoAvisoEstado implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoEstado.class);
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();		
						
		if(!Checks.esNulo(gasto.getEstadoGasto()) && 
				(DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo())
				 || DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo())
				 || DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())
				 || DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())
				 || DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()))) 
		{

			dtoAviso.setDescripcion(gasto.getEstadoGasto().getDescripcion());
			dtoAviso.setId(String.valueOf(gasto.getId()));	
		}
		
		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}