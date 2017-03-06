package es.pfsgroup.plugin.rem.api;

import java.sql.SQLException;

import org.springframework.dao.InvalidDataAccessResourceUsageException;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.validate.validator.DtoPublicacionValidaciones;


public interface ActivoEstadoPublicacionApi {

	/**
	 * Método que obtiene el estado de publicación actual de un activo.
	 * @param idActivo
	 * @return DtoCambioEstadoPublicacion
	 */
	public DtoCambioEstadoPublicacion getState(Long idActivo);
	
	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña
	 * datos de la publicación, aplicando TODAS las validaciones para publicar
	 * @param dtoCambioEstadoPublicacion: DTO con la información obtenida.
	 * @throws SQLException 
	 */
	public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) throws SQLException, JsonViewerException;

	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña
	 * datos de la publicación, permitiendo configurar las validaciones necesarias para publicar
	 * @param dtoCambioEstadoPublicacion
	 * @param validacionesPublicacion
	 * @return
	 * @throws SQLException
	 */
	public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoPublicacionValidaciones validacionesPublicacion) throws SQLException, JsonViewerException;
	/**
	 * Método que obtiene el estado de publicación por el ID del activo, así como su motivo y las observaciones si tuviese.
	 * 
	 * @param id: ID del activo a filtrar.
	 * @return Devuelve el estado de publicación en el que se encuentra el activo.
	 */
	public DtoCambioEstadoPublicacion getHistoricoEstadoPublicacionByActivo(Long id);

	/**
	 * Metodo que evalua el mensaje de retorno con las excepciones del procedure ACTIVO_PUBLICACION_AUTO,
	 * lanzadas por llamar al metodo publicacionChangeState 
	 * @param e
	 * @return
	 */
	public String getMensajeExceptionProcedure(InvalidDataAccessResourceUsageException e);
	
	/**
	 * Cambia al NUEVO ESTADO DE PUBLICACION y REGISTRA EN EL HISTORICO DE PUBLICACION
	 * @param activo
	 * @param motivo
	 * @param filtro
	 * @param estadoPublicacionActual
	 * @param isPublicacionForzada
	 * @param isPublicacionOrdinaria
	 * @return
	 * @throws JsonViewerException 
	 * @throws SQLException 
	 */
	public boolean cambiarEstadoPublicacionAndRegistrarHistorico(Activo activo, String motivo, Filter filtro, DDEstadoPublicacion estadoPublicacionActual,
			Boolean isPublicacionForzada, Boolean isPublicacionOrdinaria) throws SQLException, JsonViewerException;
}
