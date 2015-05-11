package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.*;
import es.pfsgroup.commons.utils.dao.abm.impl.GenericABMDaoImpl.FilterImpl;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVDiccionarioManager;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVPlantillaOperacionDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVPlantillaOperacion;
import es.pfsgroup.recovery.api.UsuarioApi;

@RunWith(MockitoJUnitRunner.class)
public class MSVDiccionarioManagerTest extends SampleBaseTestCase{
	
	//definier el objeto sobre el que vamos a hacer el test
	@InjectMocks 
	private MSVDiccionarioManager diccionarioManager;
	
	@Mock
	private ApiProxyFactory mockProyFactory;
	
	@Mock
	private UsuarioApi mockUsuarioApi;
	
	@Mock
	private MSVDDOperacionMasivaDao mockOperacionDao;
	
	@Mock
	private MSVPlantillaOperacionDao mockPlantillaDao;
	
	@Mock
	GenericABMDao mockGenericDao;

	@Test
	public void testDameListaOperacionesDeUsuario() {

		List<MSVDDOperacionMasiva> list=new ArrayList<MSVDDOperacionMasiva>();		
		Usuario usuario = new Usuario();
		
		when(mockProyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioApi);
		when(mockUsuarioApi.getUsuarioLogado()).thenReturn(usuario);
		when(mockOperacionDao.dameListaOperacionesDeUsuario(usuario)).thenReturn(list);
		
		
		@SuppressWarnings("rawtypes")
		List result=diccionarioManager.dameListaOperacionesDeUsuario();
		
		assertEquals(result, list);
	}
	
	@Test
	public void testDameListaPlantillasUsuario() {
		//fail("Not yet implemented");
		List<MSVPlantillaOperacion> list=new ArrayList<MSVPlantillaOperacion>();
		
		Usuario usuario = new Usuario();
		
		when(mockProyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioApi);
		when(mockUsuarioApi.getUsuarioLogado()).thenReturn(usuario);
		when(mockPlantillaDao.dameListaPlantillasUsuario(usuario) ).thenReturn(list);
		
		
		@SuppressWarnings("rawtypes")
		List result=diccionarioManager.dameListaPlantillasUsuario();
		
		assertEquals(result, list);
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testDameValoresDiccionario() {


		@SuppressWarnings("rawtypes")
		Class clazz = MSVDDTipoJuicio.class;
		@SuppressWarnings("rawtypes")
		List lista = new ArrayList();
		lista.add(new String());
		Filter filtro =  new FilterImpl(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"descripcion");
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)).thenReturn(filtro);
		when(mockGenericDao.getListOrdered(clazz,order,filtro)).thenReturn(lista);
		@SuppressWarnings("rawtypes")
		List result = diccionarioManager.dameValoresDiccionario(clazz);
		
		assertNotNull(result);

	}

}
