package es.pfsgroup.plugin.recovery.mejoras.gestorDespacho;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dao.MEJGestorDespachoDao;
import es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dto.MEJDtoComboGestores;

@Component
public class MEJGestorDespachoManager {
	
	@Autowired
	MEJGestorDespachoDao gestorDespachoDao;

	
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_GESTOR_BY_DESC_Y_DESPACHO)
	Page buscaGestoresDescripcYDespacho(MEJDtoComboGestores dto){
		return gestorDespachoDao.findByDescyDesp(dto);
	}
	
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PAGINA_GESTOR)
	public int buscarPaginaPorId(MEJDtoComboGestores dto){
		int pagina=0;
		int i=0;
		//for (GestorDespacho d : gestorDespachoDao.getList()){
		for (GestorDespacho d : gestorDespachoDao.findByDescyDespComboPaginado(dto)){
			if (d.getId().compareTo(dto.getCodigo())==0){
				pagina = i;
				break;
			}
			i += 1;
		}
		return pagina;
	}

}
