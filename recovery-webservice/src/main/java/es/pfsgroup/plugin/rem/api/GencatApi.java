package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;

public interface GencatApi {

	/**
	 * Devuelve la información de GENCAT de una comunicacion de un activo.
	 * 
	 * @param id del activo
	 * @return DtoGencat
	 */
	public DtoGencat getDetalleGencatByIdActivo(Long idActivo);
	
	/**
	 * Devuelve las ofertas de la comunicación de un activo.
	 * 
	 * @param id del activo
	 * @return DtoOfertasAsociadasActivo
	 */
	public List<DtoOfertasAsociadasActivo> getOfertasAsociadasByIdActivo(Long idActivo);
	
	/**
	 * Devuelve las reclamaciones de la comunicación de un activo.
	 * 
	 * @param id del activo
	 * @return DtoReclamacionActivo
	 */
	public List<DtoReclamacionActivo> getReclamacionesByIdActivo(Long idActivo);
	
	/**
	 * Obtiene los documentos de GENCAT subidos de un activo
	 * 
	 * @param id del activo
	 * @return DtoAdjunto
	 */
	public List<DtoAdjunto> getAdjuntosActivo(Long id) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException;
	
	/**
	 * Devuelve el historico de comunicaciones de un activo
	 * 
	 * @param id del activo
	 * @return DtoHistoricoComunicacionGencat
	 */
	public List<DtoHistoricoComunicacionGencat> getHistoricoComunicacionesByIdActivo(Long idActivo);
	
	/**
	 * Devuelve la información de GENCAT de una comunicacion del historico.
	 * 
	 * @param id de la comunicacion
	 * @return DtoGencat
	 */
	public DtoGencat getDetalleHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico);
	
}
