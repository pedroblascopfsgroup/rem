package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoBusquedaUsuario;

public class BusquedaUsuariosTest extends AbstractADMUsuarioDaoTest {

	@Test
	public void testBusquedaUsuario_noEntidad_fallo() throws Exception {

		ADMDtoBusquedaUsuario dto = new ADMDtoBusquedaUsuario();

		try {
			Page result = dao.findUsuarios(dto);
			fail ("Se debería haber lanzado una excepción");
		} catch (BusinessOperationException e) {

		}

	}
	
	@Test
	public void testSinCriteriosDeBusqueda_todosLosResultado() throws Exception {
		
		ADMDtoBusquedaUsuario dto = setupPage(new ADMDtoBusquedaUsuario());
		dto.setIdEntidad(1L);
		
		cargaDatos();
		
		Page result = dao.findUsuarios(dto);
		
		assertEquals(5, result.getResults().size());
	}
	
	@Test
	public void testBuscarPorUsername_noDistingueMayusculas() throws Exception {
		
		ADMDtoBusquedaUsuario dto = setupPage(new ADMDtoBusquedaUsuario());
		dto.setIdEntidad(1L);
		dto.setUsername("test2");
		
		cargaDatos();
		
		Page result = dao.findUsuarios(dto);
		
		assertEquals(1, result.getResults().size());
		assertEquals((Long)2L, ((Usuario)result.getResults().get(0)).getId()); 
	}
	
	
	
	@Test
	public void testBuscarUsuariosNoExternos() throws Exception {
		
		ADMDtoBusquedaUsuario dto = setupPage(new ADMDtoBusquedaUsuario());
		dto.setIdEntidad(1L);
		dto.setUsuarioExterno(false);
		
		cargaDatos();
		
		Page result = dao.findUsuarios(dto);
		
		assertEquals(1, result.getResults().size());
	}
	
	@Test
	public void testOrdenarLaBusqueda() throws Exception {
		
		ADMDtoBusquedaUsuario dto = setupPage(new ADMDtoBusquedaUsuario());
		dto.setIdEntidad(1L);
		
		cargaDatos();
		
		Page result = dao.findUsuarios(dto);
		int totalUnordered = result.getResults().size();
		
		dto.setDir("ASC");
		dto.setSort("apellido1");
		result = dao.findUsuarios(dto);
		
		assertEquals(totalUnordered, result.getResults().size());
		
		dto.setSort("nombre");
		result = dao.findUsuarios(dto);
		dto.setSort("apellido1");
		result = dao.findUsuarios(dto);
		dto.setSort("apellido2");
		result = dao.findUsuarios(dto);
		dto.setSort("email");
		result = dao.findUsuarios(dto);
		dto.setSort("usuarioExterno");
		result = dao.findUsuarios(dto);
	}
}
