package es.pfsgroup.plugin.proyecto.cajamar.manager;

import java.util.List;

import org.springframework.stereotype.Service;

import es.capgemini.pfs.asunto.ProcedimientoManagerImpl;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.Procedimiento;

@Service
public class ProcedimientoManagerCajamar extends ProcedimientoManagerImpl {

	private static final String TA_PROCEDIMIENTO_REMOTO = "TR_REM";

	@Override
	public List<DDTipoActuacion> getTiposActuacion(Procedimiento prc) {
		List<DDTipoActuacion> listado = super.getTiposActuacion(prc);

		if (prc!=null && prc.getProcessBPM()!=null) {
			for (DDTipoActuacion tipoActuacion : listado) {
				if (tipoActuacion.getCodigo().equals(TA_PROCEDIMIENTO_REMOTO)) {
					listado.remove(tipoActuacion);
					break;
				}
			}
		}
		return listado;
	}
	
}
