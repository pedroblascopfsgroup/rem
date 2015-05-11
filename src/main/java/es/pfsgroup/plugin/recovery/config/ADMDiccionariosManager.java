package es.pfsgroup.plugin.recovery.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.recovery.config.dao.ADMDDSiNoDao;

@Service("ADMDiccionariosManager")
public class ADMDiccionariosManager {
	
	@Autowired
	private ADMDDSiNoDao ddSiNoDao;
	
	/**
	 * Nos devuelve los valores del diccionario de datos DDSiNo
	 * @return
	 */
	@BusinessOperation("ADMDiccionariosManager.getSiNo")
	public List<DDSiNo> getSiNo(){
		return ddSiNoDao.getList();
	}
}
