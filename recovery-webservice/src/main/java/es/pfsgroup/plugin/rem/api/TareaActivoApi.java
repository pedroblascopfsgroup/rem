package es.pfsgroup.plugin.rem.api;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;


public interface TareaActivoApi {
    
	    public TareaActivo get(Long id);
	    
	    public TareaActivo getByIdTareaExterna(Long idTareaExterna);

		public void generarAutoprorroga(DtoSolicitarProrroga dto)  throws BusinessOperationException;

		public void saltoDesdeTareaExterna(Long idTareaExterna, String tareaDestino);
		
//		public void saltoDesdeTramite(Long idTamite, String tareaDestino);
		
		public List<TareaActivo> getTareasActivoByIdTramite(Long idTramite);
		
		public List<TareaActivo> getTareasActivo(Long idActivo, String codigoTipoTramite);
		
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

		/**
		 * Este método obtiene la tarea de activo con el ID de tarea más alto y por el id del trámite que se le pasa por parámetro.
		 *
		 * @param idTramite: Id del trámite.
		 * @return Devuelve una entidad de tipo TareaActivo.
		 */
		TareaActivo getUltimaTareaActivoByIdTramite(Long idTramite);

		public String getValorFechaSeguroRentaPorIdActivo(Long idActivo);

		public void saltoFinAlquileres(Long id);
		
		public void saltoResolucionExpedienteApple(Long idTareaExterna);

		boolean getSiTareaHaSidoCompletada(Long idTramite, String nombreTarea);
		
		/**
		 * Este método obtiene la tarea de activo mediante la oferta actual (creado para obtener la tarea de las ofertas dependientes de una principal).
		 *
		 * @param Oferta actual
		 * @return TareaActivo de la tarea dependiente.
		 */
		public TareaActivo tareaOfertaDependiente(Oferta oferta);
		
		/**
		 * Este método convierte un mapa de valores de una tarea a otro mapa de una tarea de un oferta dependiente de una principal.
		 *
		 * @param valores
		 * @param tarea
		 * @param oferta
		 * @return Map<String,String[]> nuevo mapa
		 */
		public Map<String,String[]> valoresTareaDependiente(Map<String, String[]> valores, TareaActivo tarea, Oferta oferta);

		/**
		 * Este método valida las tareas de las ofertas dependientes
		 *
		 * @param tareaExterna
		 * @param oferta
		 * @param valores
		 * @return boolean
		 */
		public String validarTareaDependientes(TareaExterna tareaExterna, Oferta oferta, Map<String, Map<String,String>> valores) throws Exception;

        Boolean deleteTareaActivoOnCascade(TareaActivo tarea);
        
        public void terminarTarea(TareaExterna tareaExterna, Usuario usuarioLogado);

		boolean getSiTareaCompletada(Long idTramite, String nombreTarea);

    }