package es.pfsgroup.plugin.recovery.config.zonas;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.config.PluginConfigBusinessOperations;
import es.pfsgroup.plugin.recovery.config.zonas.dao.ADMZonaDao;
import es.pfsgroup.plugin.recovery.config.zonas.dto.ADMDtoZona;


@Service("ADMZonaManager")
public class ADMZonaManager {

	@Autowired
	private ADMZonaDao zonaDao;
	

	/**
	 * Devuelve todas las zonas.
	 * @return
	 */
	@BusinessOperation(PluginConfigBusinessOperations.ZONA_MGR_GET_LIST)
	public List<DDZona> buscaZonas() {
		return zonaDao.getList();
	}

	@BusinessOperation("ADMZonaManager.guardaZona")
	@Transactional(readOnly = false)
	public void guardaZona(ADMDtoZona dto) {
		// TODO Eliminar este método
		DDZona z = new DDZona();
		z.setCodigo(dto.getCodigo());
		z.setCentro(dto.getCentro());
		z.setDescripcion(dto.getDescripcion());
		z.setDescripcionLarga(dto.getDescripcionLarga());
		// z.setZonaPadre(zonaPadre)(dto.getZonaPadre());
		// z.setNivel(dto.getNivel());
		// z.setOficina(dto.getOficina());
		zonaDao.save(z);

	}
	
	/**
	 * Devuelve una zona por su ID
	 * @param idZona ID de la zona
	 * @return DDZona
	 */
	@BusinessOperation(PluginConfigBusinessOperations.ZONA_MGR_GET)
	public DDZona getZona(Long idZona){
		return zonaDao.get(idZona);
	}
	
	/**
	 * Devuelve las zonas de un determinado nivel
	 * @param idNivel ID Nivel
	 * @return DDZona
	 */
	@BusinessOperation(PluginConfigBusinessOperations.ZONA_MGR_GET_LIST_BY_NIVEL)
	public List<DDZona> buscarZonasPorNivel(Long idNivel){
		return zonaDao.getByNivel(idNivel);
	}
	
	

}
