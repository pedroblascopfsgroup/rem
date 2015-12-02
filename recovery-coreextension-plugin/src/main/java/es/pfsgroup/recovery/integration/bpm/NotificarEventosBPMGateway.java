package es.pfsgroup.recovery.integration.bpm;

import org.springframework.integration.annotation.Gateway;
import org.springframework.integration.annotation.Header;

import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.integration.TypePayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;

public interface NotificarEventosBPMGateway {

	@Gateway
    void inicioTarea(TareaExterna tareaExterna
    		, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
    		);

	@Gateway
    void notificaTarea(TareaNotificacion tareaNotificacion
    		, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
    		);
	
	@Gateway
    void finTarea(TareaExterna tareaExterna
    		, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			, @Header(ProcedimientoPayload.JBPM_TRANSICION) String transicion
			);
    		

	@Gateway
	void cancelacionTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void paralizarTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void activarTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void prorrogaTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
			, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad);
	
	@Gateway
	void finBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			, @Header(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN) String tarGuidOrigen
			, @Header(ProcedimientoPayload.JBPM_TRANSICION) String transicion);

	@Gateway
	void activarBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(MEJRecurso recurso
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(Subasta subasta
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(Acuerdo acuerdo
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(ActuacionesRealizadasAcuerdo actuacionRealizada
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(ActuacionesAExplorarAcuerdo actuacionAExplorar 
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(TerminoAcuerdo terminoAcuerdo 
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(TerminoContrato terminoContrato 
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(TerminoBien terminoBien
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
			);

	@Gateway
	void enviar(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String type
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
    );

	@Gateway
	void finalizaAsunto(MEJFinalizarAsuntoDto finAsunto
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipoFinAsunto
			, @Header(TypePayload.HEADER_MSG_ENTIDAD) String dbSchema);

}
