package es.pfsgroup.recovery.core.test.manager.impl;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.dao.abm.impl.GenericABMDaoImpl.FilterImpl;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.recobroCommon.core.manager.impl.DiccionarioManager;

@RunWith(MockitoJUnitRunner.class)
public class DiccionarioManagerTest {
	
	@InjectMocks
	private DiccionarioManager diccionarioManager;
	
	@Mock
	private GenericABMDao mockGenericDao;
	
	
	@Test
	public void testDameValoresDiccionario() {


		Class clazz = DDTipoVia.class;
		List lista = new ArrayList();
		lista.add(new String());
		Filter filtro =  new FilterImpl(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"descripcion");
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)).thenReturn(filtro);
		when(mockGenericDao.getListOrdered(clazz,order,filtro)).thenReturn(lista);
		
		List result = diccionarioManager.dameValoresDiccionario(clazz);
		
		assertNotNull(result);

	}

}
