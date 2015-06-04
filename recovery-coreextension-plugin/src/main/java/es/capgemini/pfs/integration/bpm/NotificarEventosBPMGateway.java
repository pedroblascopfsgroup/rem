package es.capgemini.pfs.integration.bpm;

import org.springframework.integration.annotation.Gateway;
import org.springframework.integration.annotation.Header;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.TypePayload;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface NotificarEventosBPMGateway {

	@Gateway
    void inicioTarea(TareaExterna tareaExterna
    		, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);
    
	@Gateway
    void finTarea(TareaExterna tareaExterna
    		, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
			, @Header(AsuntoPayload.JBPM_TRANSICION) String transicion);
    		

	@Gateway
	void cancelacionTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void paralizarTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void activarTarea(TareaExterna tareaExterna
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void finBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
			, @Header(AsuntoPayload.JBPM_TAR_GUID_ORIGEN) String tarGuidOrigen
			, @Header(AsuntoPayload.JBPM_TRANSICION) String transicion);

	@Gateway
	void finalizarBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void paralizarBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void activarBPM(Procedimiento procedimiento
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void notificarPropuestaAcuerdo(EXTAcuerdo acuerdo
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void notificarCierreAcuerdo(EXTAcuerdo acuerdo
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void notificarRechazarAcuerdo(EXTAcuerdo acuerdo
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo);

	@Gateway
	void send(MEJRecurso recurso,
			@Header(TypePayload.HEADER_MSG_TYPE) String type);
	
}
