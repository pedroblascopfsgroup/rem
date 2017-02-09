package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;

public interface GestorExpedienteComercialApi {

	public static final String CODIGO_GESTOR_COMERCIAL_RETAIL = "GCOMRET";
	public static final String CODIGO_GESTOR_COMERCIAL_SINGULAR = "GCOMSIN";
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE = "GCBO";
	public static final String CODIGO_GESTOR_FORMALIZACION = "GFORM";
	public static final String CODIGO_GESTORIA_FORMALIZACION = "GIAFORM";
	
	public static final String CODIGO_SUPERVISOR_COMERCIAL_RETAIL = "SCOMRET";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_SINGULAR = "SCOMSIN";
	public static final String CODIGO_SUPERVISOR_FORMALIZACION = "SFORM";
	
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
}
