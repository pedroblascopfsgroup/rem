package es.pfsgroup.plugin.recovery.config.funciones;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.config.funciones.dao.ADMFuncionDao;
import es.pfsgroup.plugin.recovery.config.funciones.dto.ADMDtoBuscarFunciones;

@Service("ADMFuncionManager")
public class ADMFuncionManager {
	
	@Autowired
	private ADMFuncionDao funcionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	
	public ADMFuncionManager() {
		super();
	}

	public ADMFuncionManager(ADMFuncionDao funcionDao) {
		super();
		this.funcionDao = funcionDao;
	}

	/**
	 * Devuelve todas las funciones
	 * @return
	 */
	@BusinessOperation("ADMFuncionManager.buscaFunciones")
	public Page buscaFunciones(ADMDtoBuscarFunciones dto){
		return funcionDao.findAll(dto);
	}

	@BusinessOperation("ADMFuncionManager.getList")
	public List<Funcion> getList() {
		return funcionDao.getList();
	}
	
	@BusinessOperation("plugin.config.web.funciones.buttons.left")
	List<DynamicElement> getButtonConfiguracionDespachoExternoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.config.web.funciones.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.config.web.funciones.buttons.right")
	List<DynamicElement> getButtonsConfiguracionDespachoExternoRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.config.web.funciones.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
}
