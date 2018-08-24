package es.pfsgroup.plugin.rem.api;

import java.sql.Date;
import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.TareaActivo;


public interface TareaActivoApi {
    
	    public TareaActivo get(Long id);
	    
	    public TareaActivo getByIdTareaExterna(Long idTareaExterna);

		public void generarAutoprorroga(DtoSolicitarProrroga dto)  throws BusinessOperationException;

		public void saltoDesdeTareaExterna(Long idTareaExterna, String tareaDestino);
		
//		public void saltoDesdeTramite(Long idTamite, String tareaDestino);
		
		public List<TareaActivo> getTareasActivoByIdTramite(Long idTramite);
		
		public Long getTareasPendientes(Usuario usuario);
		
		public Long getAlertasPendientes(Usuario usuario);
		
		public Long getAvisosPendientes(Usuario usuario);
		
		public void saltoCierreEconomico(Long idTareaExterna);
		
		public void saltoResolucionExpediente(Long idTareaExterna);
		
		public void saltoFin(Long idTareaExterna);

		@Deprecated
		public void saltoPBC(Long idTareaExterna);

		public void saltoInstruccionesReserva(Long idTareaExterna);

		public void saltoRespuestaBankiaAnulacionDevolucion(Long idTareaExterna);
		
		public void saltoRespuestaBankiaDevolucion(Long idTareaExterna);
		
		public void saltoPendienteDevolucion(Long idTareaExterna);
		
		/**
		 * Guarda los datos de la resolución en la TEV_TAREA_EXTERNA_VALOR dado el id de la tarea externa, la fecha de la resolución y el código de la resolución del diccionario DDEstadoResolucion
		 * @param idTareaExterna
		 * @param fecha
		 * @param resolucion
		 */
		public void guardarDatosResolucion(Long idTareaExterna, Date fecha, String resolucion);

		void saltoTarea(Long idProcesBpm, String tareaDestino);

    }