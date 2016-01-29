package es.pfsgroup.recovery.cajamar.serviciosonline;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;

public interface SolicitarTasacionWSApi {
	
	public boolean altaSolicitud(NMBBien bien, List<NMBPersonasBien> personasBien, List<NMBContratoBien> contratosBien, Long cuenta, String personaContacto, Long telefono, String observaciones);
	
	public Map<String, String> getMapaTIMN();
}
