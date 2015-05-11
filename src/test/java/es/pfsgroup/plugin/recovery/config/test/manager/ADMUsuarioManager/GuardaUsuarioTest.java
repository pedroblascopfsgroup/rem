package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;

public class GuardaUsuarioTest extends AbstractADMUsuarioManagerTest {
	
	
	@Test
	public void testNuevoUsuarioExterno() throws Exception {
		// TODO: terminar de implementar este test
		/*
		throw new BusinessOperationException("implementar este test");
		
		ADMDtoUsuario dto = TestData.newTestObject(
				ADMDtoUsuario.class, new FieldCriteria("id", null),
				new FieldCriteria("username","nuevo"),
				new FieldCriteria("password", "nuevo"),
				new FieldCriteria("usuarioExterno", true));
		List<GestorDespacho> gd = getTestData(GestorDespacho.class);
		
		Usuario mockUsuario = Mockito.mock (Usuario.class);
		Usuairo mockUsuarioLogado = Mockito.mock(Usuario.class);
		Entidad entidad = TestData.newTestObject(Entidad.class, new ColumnCriteria("ID", 1L));
		
		Mockito.when(usuarioDao.createNewUsuario()).thenReturn(mockUsuario);
		Mockito.when(usuarioDao.getLastId()).thenReturn(1L);
		Mockito.when(usuarioManager.getUsuarioLogado()).thenReturn(mockUsuarioLogado);
		Mockito.when(mockUsuarioLogado.getEntidad()).thenReturn(entidad);
		Mockito.when(gestorDespachoDao.getList()).thenReturn(gd);
		
		admUsuarioManager.guardaUsuario(dto);
		
		Mockito.verify(usuarioDao).saveOrUpdate(mockUsuario);	
		
		Mockito.verify(mockUsuario).setId(2L);
		Mockito.verify(mockUsuario).setUsuarioExterno(true);
		
		*/	
		
	}
	
	@Test
	public void testActualizaUsuario() throws Exception {
		// TODO: Terminar de implementar este test
		//throw new BusinessOperationException("implementar este test");
	}
	
	@Test
	public void testActualizaUsuario_OtraEntidad() throws Exception {
		//TODO: Terminar de implementar este test
		// throw new BusinessOperationException("implementar este test");
	}

}
