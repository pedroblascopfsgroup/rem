package es.pfsgroup.plugin.rem.updaterstate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Service("updaterStateManager")
public class UpdaterStateManager implements UpdaterStateApi{

	public static final String CODIGO_CHECKING_INFORMACION = "T001_CheckingInformacion";
	public static final String CODIGO_CHECKING_ADMISION = "T001_CheckingDocumentacionAdmision";
	public static final String CODIGO_CHECKING_GESTION = "T001_CheckingDocumentacionGestion";
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaApi;
	
	@Override
	public Boolean getStateAdmision(Activo activo) {
		return activo.getAdmision();
	}

	@Override
	public Boolean getStateGestion(Activo activo) {
		return activo.getGestion();
	}

	@Override
	public void updaterStates(Activo activo) {
		this.updaterStateAdmision(activo);
		this.updaterStateGestion(activo);
	}
	
	private void updaterStateAdmision(Activo activo){
		//En caso de que esté 'OK' no se modifica el estado.
		if(!this.getStateAdmision(activo)){
			TareaExterna tareaExternaDocAdmision = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingDocumentacionAdmision");
			if(!Checks.esNulo(tareaExternaDocAdmision)){
				TareaActivo tareaDocAdmision = (TareaActivo) tareaExternaDocAdmision.getTareaPadre();
			
				TareaExterna tareaExternaInfo = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingInformacion");
				TareaActivo tareaInfo = (TareaActivo) tareaExternaInfo.getTareaPadre();
		
				Boolean tareasAdmision = (!Checks.esNulo(tareaDocAdmision.getFechaFin()) && !Checks.esNulo(tareaInfo.getFechaFin()));
				Boolean fechasAdmision = (!Checks.esNulo(activo.getTitulo()) && !Checks.esNulo(activo.getTitulo().getFechaInscripcionReg()) && !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion()) && !Checks.esNulo(activo.getFechaRevisionCarga()));
				activo.setAdmision(tareasAdmision && fechasAdmision);
			}
		}
	}
	
	private void updaterStateGestion(Activo activo){
		//En caso de que esté 'OK' no se modifica el estado.
		if(!this.getStateGestion(activo)){
			TareaExterna tareaExternaDocGestion = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingDocumentacionGestion");
			if(!Checks.esNulo(tareaExternaDocGestion)){
				TareaActivo tareaDocGestion = (TareaActivo) tareaExternaDocGestion.getTareaPadre();
			
				activo.setGestion(!Checks.esNulo(tareaDocGestion.getFechaFin()));
			}
		}
	}

}
