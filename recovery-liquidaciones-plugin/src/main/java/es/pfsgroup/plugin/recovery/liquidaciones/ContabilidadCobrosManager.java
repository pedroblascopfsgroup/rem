package es.pfsgroup.plugin.recovery.liquidaciones;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.ContabilidadCobrosDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;


/**
 * Servicio para los documentos de precontencioso.
 * @author amompo
 */
@Service
public class ContabilidadCobrosManager implements ContabilidadCobrosApi {
	
	@Autowired ContabilidadCobrosDao contabilidadCobrosDao;

	@Override
	public void saveContabilidadCobro(DtoContabilidadCobros dto) {
		ContabilidadCobros cnt = new ContabilidadCobros();
		/**Seteamos los valores de los campos**/
		
		contabilidadCobrosDao.save(cnt);
	}

	@Override
	public void deleteContabilidadCobro(Long idContabilidadCobro) {
		contabilidadCobrosDao.deleteById(idContabilidadCobro);
	}

   
	
}
