package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface GestorExpedienteComercialApi {

	public static final String CODIGO_GESTOR_COMERCIAL = "GCOM";
	public static final String CODIGO_GESTOR_COMERCIAL_RETAIL = "GCOMRET";
	public static final String CODIGO_GESTOR_COMERCIAL_SINGULAR = "GCOMSIN";
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE = "GCBO";
	public static final String CODIGO_GESTOR_FORMALIZACION = "GFORM";
	public static final String CODIGO_GESTORIA_FORMALIZACION = "GIAFORM";
	public static final String CODIGO_GESTORIA_ADMISION = "GTOADM";
	
	public static final String CODIGO_SUPERVISOR_COMERCIAL_RETAIL = "SCOMRET";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_SINGULAR = "SCOMSIN";
	public static final String CODIGO_SUPERVISOR_FORMALIZACION = "SFORM";
	public static final String CODIGO_SUPERVISOR_COMERCIAL = "SCOM";
	
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "HAYAGBOINM";
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO = "HAYAGBOFIN";
	public static final String CODIGO_GESTOR_RESERVA_CAJAMAR = "GESRES";
	public static final String CODIGO_GESTOR_MINUTA_CAJAMAR = "GESMIN";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "HAYASBOINM";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO = "HAYASBOFIN";
	public static final String CODIGO_SUPERVISOR_RESERVA_CAJAMAR = "SUPRES";
	public static final String CODIGO_SUPERVISOR_MINUTA_CAJAMAR = "SUPMIN";
	public static final String CODIGO_GESTOR_CONTROLLER = "GCONT";
	public static final String CODIGO_GESTOR_CIERRE_VENTA = "GCV";
	
	/**
	 * Guarda el gestor en el expediente, y si se sustituye por otro, lo guarda en el histórico.
	 * @param dto
	 * @return
	 */
	public Boolean insertarGestorAdicionalExpedienteComercial(GestorEntidadDto dto);
	
	/**
	 * Devuelve los gestores asociados al expediente comercial
	 * @param dto
	 * @return
	 */
	List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto);
	
	/**
	 * Devuelve en un array los tipos de gestor del expediente comercial
	 * @return
	 */
	public String[] getCodigosTipoGestorExpedienteComercial();
	
	/**
	 * Actualiza las tareas del tramite de un expediente comercial
	 * @param idTrabajo
	 */
	public void actualizarTareas(Long idTrabajo);
	
	/**
	 * Devuelve el gestor del expediente comercial según el codigo del tipoGestor pasado por parámetro
	 * @param expediente
	 * @param tipo
	 * @return
	 */
	public Usuario getGestorByExpedienteComercialYTipo(ExpedienteComercial expediente, String tipo);
	
	/**
	 * Devuelve en un array los tipos de gestor del expediente comercial de alquiler
	 * @return
	 */
	public String[] getCodigosTipoGestorExpedienteComercialAlquiler();
}
