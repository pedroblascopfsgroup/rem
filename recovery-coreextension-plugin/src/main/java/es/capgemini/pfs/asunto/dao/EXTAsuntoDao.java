package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

public interface EXTAsuntoDao extends AbstractDao<Asunto, Long>{

	Page buscarAsuntosPaginated(Usuario usuarioLogado, EXTDtoBusquedaAsunto dto);
	
	Integer buscarAsuntosPaginatedDinamicoCount(Usuario usuarioLogado, EXTDtoBusquedaAsunto dto, String paramsDinamicos);
	
	Page buscarAsuntosPaginatedDinamico(Usuario usuarioLogado, EXTDtoBusquedaAsunto dto, String paramsDinamicos);
	
	Long crearAsunto(GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador, String nombreAsunto, Expediente expediente,
            String observaciones);
	
	Long crearAsuntoConEstado(GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador,
			String nombreAsunto, Expediente expediente, String observaciones, String codigoEstadoAsunto, DDTiposAsunto tipoAsunto);
	
	 /**
     * Modifica un Asunto.
     * @param idAsunto el id del asunto a modificar
     * @param gestorDespacho el gestor nuevo.
     * @param supervisor el supervisor nuevo.
     * @param nombreAsunto el nuevo nombre del Asunto.
     * @param observaciones las obeservaciones.
     * @return el id del asunto.
     */
    Long modificarAsunto(Long idAsunto, GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador, String nombreAsunto,
            String observaciones);
	
	/**
     * Busca de entre todos los asuntos si existe otro con el mismo nombre
     * @param nombreAsunto
     * @param idAsuntoOriginal Si es un asunto ya existente se comprueba que el nombre seleccionado sea de otro asunto y no del original
     * @return
     */
    Boolean isNombreAsuntoDuplicado(String nombreAsunto, Long idAsuntoOriginal);

	/**
	 * Devuelve las tareas pendientes por asunto.
	 * 
	 * @param asuId
	 * @return
	 */
	List<DtoReportAnotacionAgenda> getListaTareasPendientes(Long asuId);
	
	/**
     * Devuelve los tipos de fondo "dd_tfo_tipo_fondo" de los contratos de los procedimientos de un asunto
     * @param idAsunto
     * @return
     */
	List<DDTipoFondo> esTitulizada(Long idAsunto);

	/**
         * Indica sobre el Asunto si el proceso de envio a cierre de deuda man/auto ha generado errores de validaci�n
        * @param idAsunto
        * @return
        */        
	String getMsgErrorEnvioCDD(Long idAsunto);
	
	/**
         * Indica sobre el Asunto si el proceso de envio a cierre de deuda man/auto ha generado errores en NUSE
        * @param idAsunto
        * @return
        */        
	String getMsgErrorEnvioCDDNuse(Long idAsunto);
        
	/**
         * Indica sobre el Asunto el error CDD para mostrar en la cabecera: Validacion / NUSE
        * @param idAsunto
        * @return
        */        
	String getMsgErrorEnvioCDDCabecera(Long idAsunto);
}
