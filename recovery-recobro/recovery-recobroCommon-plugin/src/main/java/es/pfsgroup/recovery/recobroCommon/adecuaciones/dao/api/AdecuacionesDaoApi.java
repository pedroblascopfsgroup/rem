package es.pfsgroup.recovery.recobroCommon.adecuaciones.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.model.Adecuaciones;

/**
 * Interfaz de métodos para el DAO de las Adecuaciones
 * @author dgg
 *
 */
public interface AdecuacionesDaoApi  extends AbstractDao<Adecuaciones, Long>  {

	Page getListadoAdecuaciones(AdecuacionesDto dto);

	Adecuaciones getAdecuacionById(Long id);

	List<Adecuaciones> getListadoAdecuaciones(Long expId);

	
}
