package es.pfsgroup.plugin.rem.test.gasto.avisos.gastoavisoalertas;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.gasto.avisos.GastoAvisoAlertas;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorAvisos;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosAvisoGasto;

@RunWith(MockitoJUnitRunner.class)
public class GetAvisoTest {

	private static final int TWO = 2;

	@InjectMocks
	private GastoAvisoAlertas avisador;

	@Mock
	private UtilDiccionarioApi diccionarioApi;

	@Before
	public void before() {
		Dictionary mot01 = mock(Dictionary.class);
		when(mot01.getDescripcion()).thenReturn("correspondeComprador");
		
		Dictionary mot02 = mock(Dictionary.class);
		when(mot02.getDescripcion()).thenReturn("ibiExento");
		
		when(diccionarioApi.dameValorDiccionarioByCod(DDMotivosAvisoGasto.class, "01")).thenReturn(mot01);
		when(diccionarioApi.dameValorDiccionarioByCod(DDMotivosAvisoGasto.class, "02")).thenReturn(mot02);
	}
	
	@After
	public void after() {
		reset(diccionarioApi);
	}
	
	@Test
	public void devuelveAlertasGasto() {
		GastoProveedorAvisos aviso = new GastoProveedorAvisos();
		// aquí tenemos que saber que el código 01 se corresponde con el campo correspondeComprador
		aviso.setCorrespondeComprador(true);
		// aquí tenemos que saber que el código 02 se corresponde con el campo ibiExento
		aviso.setIbiExento(true);
		
		List<GastoProveedorAvisos> avisos = new ArrayList<GastoProveedorAvisos>();
		avisos.add(aviso);
		
		GastoProveedor gasto = new GastoProveedor();
		gasto.setGastoProveedorAvisos(avisos);
		
		
		DtoAviso dto = avisador.getAviso(gasto, null); // el usuario logado nos la debe trufar
		
		assertNotNull("No se han devuelto avisos", dto.getDescripciones());
		assertEquals("No se han devuelto los avisos esperados", TWO, dto.getDescripciones().size());
		
		assertTrue("No se ha encontrado el valor esperado", dto.getDescripciones().contains("correspondeComprador"));
		assertTrue("No se ha encontrado el valor esperado", dto.getDescripciones().contains("ibiExento"));
	}

}
