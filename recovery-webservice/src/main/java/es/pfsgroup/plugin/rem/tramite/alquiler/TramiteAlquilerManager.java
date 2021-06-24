package es.pfsgroup.plugin.rem.tramite.alquiler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Service("tramiteAlquilerManager")
public class TramiteAlquilerManager implements TramiteAlquilerApi {
	
	private static final String T015_VerificarScoring = "T015_VerificarScoring";
	private static final String T015_ElevarASancion = "T015_ElevarASancion";
	private static final String T015_ScoringBC = "T015_ScoringBC";
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired ActivoTramiteApi activoTramiteApi;
	
	@Override
	public boolean haPasadoScoring(Long idTramite) {
		boolean haPasadoScoring = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_VerificarScoring.equals(tareaProcedimiento.getCodigo())) {
				haPasadoScoring = true;
			}
		}

		return haPasadoScoring;
	}
	
	@Override
	public boolean esDespuesElevar(Long idTramite) {
		boolean despuesDeElevar = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_ElevarASancion.equals(tareaProcedimiento.getCodigo())) {
				despuesDeElevar = true;
			}
		}

		return despuesDeElevar;
	}
	
	@Override
	public boolean haPasadoScoringBC(Long idTramite) {
		boolean haPasadoScoringBC = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_ScoringBC.equals(tareaProcedimiento.getCodigo())) {
				haPasadoScoringBC = true;
			}
		}

		return haPasadoScoringBC;
	}
	
}