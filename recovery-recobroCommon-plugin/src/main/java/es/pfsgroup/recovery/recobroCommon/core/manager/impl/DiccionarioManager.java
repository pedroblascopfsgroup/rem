package es.pfsgroup.recovery.recobroCommon.core.manager.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;

@Service
@Transactional(readOnly=false)
public class DiccionarioManager implements DiccionarioApi{

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
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", valor);
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

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_DAME_LOCALIDADES_POR_PROVINCIA)
	public List<Localidad> getLocalidadesByProvincia(Long idProvincia) {
		List<Localidad> localidades = new ArrayList<Localidad>();
		if (!Checks.esNulo(idProvincia)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "provincia.id", idProvincia);
			Order order = new Order(OrderType.ASC,"descripcion");
			localidades = genericDao.getListOrdered(Localidad.class,order, filtro);
			
		}
		
		return localidades;
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_GET_LOCALIDAD_BY_CODIGO)
	public Localidad getLocalidadByCodigo(String codigo) {
		if (!Checks.esNulo(codigo)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			return genericDao.get(Localidad.class, filtro);
		} else {
			return null;
		}
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_GET_PROVINCIA_BY_CODIGO)
	public DDProvincia getProvinciaByCodigo(String codigo) {
		if (!Checks.esNulo(codigo)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			return genericDao.get(DDProvincia.class, filtro);
		} else {
			return null;
		}
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_GET_TIPO_VIA_BY_CODIGO)
	public DDTipoVia getTipoViaByCodigo(String codigo) {
		if (!Checks.esNulo(codigo)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			return genericDao.get(DDTipoVia.class, filtro);
		} else {
			return null;
		}
	}

	/**
	 * {@inheritDoc} 
	 */
	@Override
	@BusinessOperation(BO_GET_PAIS_BY_CODIGO)
	public DDPais getPaisByCodigo(String codigo) {
		if (!Checks.esNulo(codigo)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			return genericDao.get(DDPais.class, filtro);
		} else {
			return null;
		}
	}
	
	@Override
	@BusinessOperation(BO_GET_DD_RULE_DEFINITION)
	public List<RuleDefinition> getReglas(){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "name");
		List<RuleDefinition> lista = genericDao.getListOrdered(RuleDefinition.class, order, filtro);

		return lista;
	}

	@Override
	@BusinessOperation(BO_GET_DD_SI_NO)
	public List<DDSiNo> getDDsino() {
		return genericDao.getList(DDSiNo.class);	
	}

	

}
