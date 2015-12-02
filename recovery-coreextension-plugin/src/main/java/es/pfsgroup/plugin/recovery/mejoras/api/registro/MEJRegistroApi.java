package es.pfsgroup.plugin.recovery.mejoras.api.registro;

import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;

public interface MEJRegistroApi {
	
	public static final String MEJ_BO_REG_GUARDA_TRAZA_EVENTO = "plugin.mejoras.registro.guardatTrazaEvento";
	public static final String MEJ_BO_REG_GUARDA_TRAZA_EVENTO_PARAM = "plugin.mejoras.registro.guardatTrazaEventoParam";
	public static final String MEJ_BO_REG_BUSCA_TRAZA_EVENTO = "plugin.mejoras.registro.buscaTrazasEvento";
	public static final String MEJ_BO_REG_GETTRAZA = "plugin.mejoras.registro.getTraza";
	public static final String MEJ_BO_GETMAPA_REGISTRO = "plugin.mejoras.registro.getMapa";
	
	
	/**
	 * Registra el env�o de un correo electr�nico
	 * @param dto
	 */
	@BusinessOperationDefinition(MEJ_BO_REG_GUARDA_TRAZA_EVENTO)
	void guardatTrazaEvento(MEJTrazaDto dto);
	
	@BusinessOperationDefinition(MEJ_BO_REG_GUARDA_TRAZA_EVENTO_PARAM)
	void guardatTrazaEventoParam(long idUsuario, long idUg, String codUg, String tipoEvento, Map<String, Object> infoEvento);

	@BusinessOperationDefinition(MEJ_BO_REG_BUSCA_TRAZA_EVENTO)
	List<? extends MEJRegistroInfo> buscaTrazasEvento(MEJTrazaDto dto);
	
	/**
	 * 
	 * @param id
	 * @return devuelve la traza que tiene ese id
	 */
	@BusinessOperationDefinition(MEJ_BO_REG_GETTRAZA)
	MEJRegistroInfo get(Long id);
	
	/**
	 * mapea los valores almacenados en el registro para poder acceder a ellos
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(MEJ_BO_GETMAPA_REGISTRO)
	Map<String, String> getMapaRegistro(Long id);

}
