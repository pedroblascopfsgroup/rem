package es.pfsgroup.plugin.recovery.coreextension.test.coreextensionController;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.users.domain.Usuario;

/**
 * Tests del m�todo {@link es.pfsgroup.plugin.recovery.coreextension.coreextensionController#getListUsuariosData(org.springframework.ui.ModelMap, Long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListUsuariosDataTest extends AbstractCoreextensionControllerTest {

	@Override
	public void childBefore() {

	}

	@Override
	public void childAfter() {

	}
	
	/**
	 * Test general.
	 */
	@Test
	public void testGetListTipoDespachoData(){
		
		List<Usuario> listaUsuarios = new ArrayList<Usuario>();
		Long idTipoDespacho = RandomUtils.nextLong();
		
		when(mockCoreextensionApi.getListUsuariosData(idTipoDespacho)).thenReturn(listaUsuarios);
		
		String resultado = coreextensionController.getListUsuariosData(modelMap, idTipoDespacho, false);
		
		assertEquals(modelMap.get("listadoUsuarios"),listaUsuarios);
		assertEquals(resultado,"plugin/coreextension/asunto/tipoUsuarioJSON");
		
	}

}
