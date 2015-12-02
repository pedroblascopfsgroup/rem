package es.pfsgroup.plugin.recovery.coreextension.utils;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
@Transactional(readOnly=false)
public class UtilDiccionarioManager implements UtilDiccionarioApi{

	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_DAME_VALORES_DICCIONARIO)
	public List dameValoresDiccionario(Class clase) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"descripcion");
		List lista = genericDao.getListOrdered(clase, order, filtro);
		//List lista = genericDao.getList(clazz, filtro);
		return lista;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_DAME_VALOR_DICCIONARIO)
	public Object dameValorDiccionario(Class clase, Long valor) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", valor);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Object obj = genericDao.get(clase, f1, f2);
		//List lista = genericDao.getList(clazz, filtro);
		return obj;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_DAME_VALOR_DICCIONARIO_BY_COD)
	public Object dameValorDiccionarioByCod(Class clase, String valor) {
		if (Checks.esNulo(valor)) {
			return null;
		}
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", valor);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Object obj = genericDao.get(clase, f1, f2);
		//List lista = genericDao.getList(clazz, filtro);
		return obj;
	}
	
	@Override
	@BusinessOperation(BO_DAME_VALOR_DICCIONARIO_BY_DES)
	public Object dameValorDiccionarioByDes(Class clase, String valor) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "descripcion", valor);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Object obj = genericDao.get(clase, f1, f2);
		//List lista = genericDao.getList(clazz, filtro);
		return obj;
	}
	

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_DAME_TODOS_VALORES_DICCIONARIO)
	public List dameValoresDiccionarioSinBorrado(Class clase) {
		Order order = new Order(OrderType.ASC,"descripcion");
		List lista = genericDao.getListOrdered(clase, order);
		//List lista = genericDao.getList(clazz, filtro);
		return lista;
	}


}
