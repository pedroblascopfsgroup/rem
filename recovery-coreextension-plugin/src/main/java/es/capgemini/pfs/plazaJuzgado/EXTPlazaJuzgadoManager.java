package es.capgemini.pfs.plazaJuzgado;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.plazaJuzgado.dao.EXTTipoPlazaDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;

@Component
public class EXTPlazaJuzgadoManager implements PlazaJuzgadoApi{

	@Autowired
	EXTTipoPlazaDao tipoPlazaDao;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Override
	@BusinessOperation(BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_ID_PLAZA)
	public List<TipoJuzgado> buscaJuzgadosPorIdPlaza(Long id) {
		Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "plaza.id", id);
		//List<TipoJuzgado> listaJuzgados = genericDao.getList(TipoJuzgado.class, filtroJuzgado);
		Order order = new Order(OrderType.ASC,"descripcion");
		List<TipoJuzgado> listaJuzgados = genericDao.getListOrdered(TipoJuzgado.class, order, filtroJuzgado);
		return listaJuzgados;
	}

	@Override
	@BusinessOperation(BO_CORE_PLAZAJUZGADO_FIND_JUZGADO_BY_PLAZA)
	public List<TipoJuzgado> buscaJuzgadosPorPlaza(String codigo) {
		Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "plaza.codigo", codigo);
		//List<TipoJuzgado> listaJuzgados = genericDao.getList(TipoJuzgado.class, filtroJuzgado);
		Order order = new Order(OrderType.ASC,"descripcion");
		List<TipoJuzgado> listaJuzgados = genericDao.getListOrdered(TipoJuzgado.class, order, filtroJuzgado);
		return listaJuzgados;
	}

	@Override
	@BusinessOperation(BO_CORE_PLAZAJUZGADO_FIND_PLAZA_BY_COD)
	public int buscarPorCodigo(String codigo) {
		int pagina = 0;
		int i = 0;
		for (TipoPlaza p : tipoPlazaDao.getList()){
			if (p.getCodigo().compareTo(codigo)==0) {
				pagina = i;
				break;				
			}
			i += 1;
		}	
		return pagina;
	}

	@Override
	@BusinessOperation(BO_CORE_PLAZAJUZGADO_TIPO_PLAZA_BY_DESC)
	public Page buscarPorDescripcion(BuscaPlazaPaginadoDtoInfo dto) {
		return tipoPlazaDao.buscarPorDescripcion(dto);
	}

	@Override
	@BusinessOperation(BO_CORE_PLAZAJUZGADO_LISTA_PLAZAS)
	public List<TipoPlaza> listaPlazas() {
		//return genericDao.getList(TipoPlaza.class);
		Order order = new Order(OrderType.ASC,"descripcion");
		return genericDao.getListOrdered(TipoPlaza.class, order);
	}

}
