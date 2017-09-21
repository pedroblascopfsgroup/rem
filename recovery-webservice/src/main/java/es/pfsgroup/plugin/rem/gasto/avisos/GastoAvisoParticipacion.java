package es.pfsgroup.plugin.rem.gasto.avisos;

import java.math.BigDecimal;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;


@Service("gastoAvisoParticipacion")
public class GastoAvisoParticipacion implements GastoAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoAvisoParticipacion.class);
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	

	@Override
	public DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();	
		BigDecimal participacionTotal= new BigDecimal("0.00");
		BigDecimal participacionCien= new BigDecimal("100.00");
				
		if(!Checks.esNulo(gasto)){
			
			List<VBusquedaGastoActivo> activosGasto= gastoProveedorApi.getListActivosGastos(gasto.getId());
			if(activosGasto.size()>0) {
				for(VBusquedaGastoActivo ag: activosGasto){
					if(!Checks.esNulo(ag.getParticipacion())) {
						String participacion = ag.getParticipacion().toString();
						participacion = participacion.replace(',', '.');
						participacionTotal = participacionTotal.add(new BigDecimal(participacion));
					}
				}
				
				if(!participacionCien.equals(participacionTotal)){
					dtoAviso.setDescripcion("% participación de activos incorrecto");
					dtoAviso.setId(String.valueOf(gasto.getId()));	
				}
			}
			
		}
		
		return dtoAviso;
		
	}
	
}