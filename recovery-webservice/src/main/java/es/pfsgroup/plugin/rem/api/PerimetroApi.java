package es.pfsgroup.plugin.rem.api;

import java.util.List;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;

public interface PerimetroApi {
	
	/**
	 * Devuelve el perimetro del ID de un activo dado
	 * @param idActivo
	 * @return PerimetroActivo
	 */
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo);
	
	/**
	 * Guarda un nuevo registro de PerimetroActivo
	 * @param perimetroActivo
	 * @return
	 */
	public Boolean save(PerimetroActivo perimetroActivo);
	
	/**
	 * Actualiza un registro existente de PerimetroActivo
	 * @param perimetroActivo
	 * @return
	 */
	public Boolean update(PerimetroActivo perimetroActivo);


}
