package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class TramiteAlquilerNoComercialRenovaciones extends TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {

	private final Log logger = LogFactory.getLog(TramiteAlquilerNoComercialRenovaciones.class);
	
	@Override
	public boolean cumpleCondiciones(ActivoTramite tramite){
		boolean resultado = false;
		Set<String> tareasActivas = tramite.getTareasExternasActivasCodigo(); 
		List<String> tareasNoEditableList = this.devolverTareasNoModificarFianza();
		List<String> tareasActivasList = new ArrayList<String>(); 
		tareasActivasList.addAll(tareasActivas);
		
		if(CollectionUtils.containsAny(tareasActivasList, tareasNoEditableList)) {
			resultado = true;
		}
		
		return resultado;
	}
	
	private List<String> devolverTareasNoModificarFianza(){
		List<String> listaTareas = new ArrayList<String>();	
		listaTareas.add(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_AGENDAR_FIRMA);
		listaTareas.add(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_RESPUESTA_REAGENDACION_BC);
		listaTareas.add(TareaProcedimientoConstants.TramiteAlquilerNoCmT018.CODIGO_FIRMA);
		
		return listaTareas;
	}
	
	@Override
	public boolean permiteClaseCondicion() {
		return true;
	}
}
