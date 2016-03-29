package es.pfsgroup.procedimientos.subasta;

import static org.mockito.Mockito.*;
import static org.junit.Assert.assertEquals;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDGestionAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@RunWith(MockitoJUnitRunner.class)
public class SubastaCalculoManagerTest {

	@Mock
	private UtilDiccionarioApi mockUtilDiccionarioApi;

	@Mock
	private GenericABMDao genericDao;

	@InjectMocks
	private SubastaCalculoManager subastaCalculoManager;

	/**
	 * Generic Id
	 */
	private static final Long ID_RANDOM = RandomUtils.nextLong();

	@Before
	public void initialize() {
		// Mock methods
		mockDameValorDiccionarioByCod(DDTipoSubasta.NDE);
	}

	@Test
	public void testDeterminarTipoSubastaConSubastaTipoNoDelegada() {
		// Subasta to test
		DDTipoSubasta tipoNoDelegada = new DDTipoSubasta();
		tipoNoDelegada.setCodigo(DDTipoSubasta.NDE);

		Subasta subastaNoDelegada = new Subasta();
		subastaNoDelegada.setTipoSubasta(tipoNoDelegada);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaNoDelegada);

		// verify never call update
		verify(genericDao, never()).update(eq(Subasta.class), any(Subasta.class));
	}

	@Test
	public void testDeterminarTipoSubastaConSubastaQueNoCumpleCondicionesParaTipoNoDelegada() {
		Subasta subastaToTest = newSubastaToTest();

		// Method to test
		// subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		// verify never call update
		verify(genericDao, never()).update(eq(Subasta.class), any(Subasta.class));
	}

	/**
	 * Si la gestión del asunto donde está la subasta es Haya
	 */
	@Test
	public void testDeterminarTipoSubastaSiSubastaTieneAsuntoGestionHaya() {
		Subasta subastaToTest = newSubastaToTest();

		DDGestionAsunto gestionAsuntoHAYA = new DDGestionAsunto(); 
		gestionAsuntoHAYA.setCodigo(DDGestionAsunto.HAYA);

		EXTAsunto asuntoSubasta = new EXTAsunto();
		asuntoSubasta.setGestionAsunto(gestionAsuntoHAYA);

		subastaToTest.setAsunto(asuntoSubasta);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		comprobarSiLaSubastaHaSidoModificadaANoDelegada();
	}

	/**
	 * Si el asunto donde está la subasta es un concurso.
	 */
	@Test
	public void testDeterminarTipoSubastaSiSubastaTieneAsuntoConcurso() {
		Subasta subastaToTest = newSubastaToTest();

		DDTiposAsunto tipoAsuntoConcursal = new DDTiposAsunto();
		tipoAsuntoConcursal.setCodigo(DDTiposAsunto.CONCURSAL);

		EXTAsunto asuntoSubasta = new EXTAsunto();
		asuntoSubasta.setTipoAsunto(tipoAsuntoConcursal);

		subastaToTest.setAsunto(asuntoSubasta);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		comprobarSiLaSubastaHaSidoModificadaANoDelegada();
	}

	/**
	 * Si existe algún bien en la subasta que tenga cargas anteriores.
	 */
	@Test
	public void testDeterminarTipoSubastaSiSubastaTieneCargasAnteriores() {
		Subasta subastaToTest = newSubastaToTest();
		subastaToTest.setCargasAnteriores("1000");

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		comprobarSiLaSubastaHaSidoModificadaANoDelegada();
	}

	/**
	 * provee una subasta de tipo por defecto (delegada) que no cumple ninguna condicion para que se cambie el tipo a no delegada.
	 * 
	 * @return
	 */
	private Subasta newSubastaToTest() {
		// Asunto
		DDGestionAsunto gestionAsuntoRandom = new DDGestionAsunto(); 
		gestionAsuntoRandom.setCodigo("Random");

		DDTiposAsunto tipoAsunto = new DDTiposAsunto();
		tipoAsunto.setCodigo("Random");

		EXTAsunto asuntoSubasta = new EXTAsunto();
		asuntoSubasta.setGestionAsunto(gestionAsuntoRandom);
		asuntoSubasta.setTipoAsunto(tipoAsunto);

		// Lotes
		//LoteSubasta lotesSubasta = new lotesSubasta 
				
		// Subasta
		DDTipoSubasta tipoDelegada = new DDTipoSubasta();
		// Por defecto todas las subastas son de tipo delegada
		tipoDelegada.setCodigo(DDTipoSubasta.DEL);

		Subasta subasta = new Subasta();
		subasta.setTipoSubasta(tipoDelegada);
		subasta.setAsunto(asuntoSubasta);
		subasta.setCargasAnteriores("0");
		
		return subasta;
	}

	/**
	 * Realiza un mock para el metodo dameValorDiccionarioByCod de mockUtilDiccionarioApi
	 * @param codigo de estado
	 */
	private void mockDameValorDiccionarioByCod(String codigoEstado) {
		DDTipoSubasta tipoSubasta = new DDTipoSubasta();
		tipoSubasta.setCodigo(codigoEstado);

		when(mockUtilDiccionarioApi.dameValorDiccionarioByCod(DDTipoSubasta.class, codigoEstado)).thenReturn(tipoSubasta);
	}

	/**
	 * Metodo que comprueba si la subasta ha sido actualizada con el tipo no delegada
	 */
	private void comprobarSiLaSubastaHaSidoModificadaANoDelegada() {
		// Capture the result
		ArgumentCaptor<Subasta> capturador = ArgumentCaptor.forClass(Subasta.class);
		verify(genericDao).update(eq(Subasta.class), capturador.capture());

		// Check the result
		Subasta subastaActualizada = capturador.getValue();

		assertEquals(DDTipoSubasta.NDE, subastaActualizada.getTipoSubasta().getCodigo());
	}
}
