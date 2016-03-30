package es.pfsgroup.procedimientos.subasta;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
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
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

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
	 * Si la deuda de las operaciones relacionadas es mayor a un millon
	 */
	@Test
	public void testDeterminarTipoSubastaConDeudaMayorDeUnMillon(){
		
				
		DDEstadoContrato estadoContrato = new DDEstadoContrato();
		estadoContrato.setCodigo(DDEstadoContrato.ESTADO_CONTRATO_ACTIVO);	
		
		Movimiento movimiento = new Movimiento();
		movimiento.setDeudaIrregular(1000000.23F);
		movimiento.setPosVivaNoVencida(2000.34F);
		
		List<Movimiento> movimientos = new ArrayList<Movimiento>();
		movimientos.add(movimiento);
		
		Contrato contrato = new Contrato();		
		contrato.setEstadoContrato(estadoContrato);			
		contrato.setMovimientos(movimientos);		
				
		NMBContratoBien contratoBien = new NMBContratoBien();
		contratoBien.setContrato(contrato);
		
		List<NMBContratoBien> contratosBien = new ArrayList<NMBContratoBien>();
		contratosBien.add(contratoBien);
		
		NMBBien bien  = new NMBBien();
		bien.setContratos(contratosBien);
				
		List<Bien> listadoBienes = new ArrayList<Bien>();
		listadoBienes.add(bien);
				
		LoteSubasta lote = new LoteSubasta();
		lote.setBienes(listadoBienes);

		List<LoteSubasta> loteSubasta = new ArrayList<LoteSubasta>();
		loteSubasta.add(lote);

		Subasta subastaToTest = newSubastaToTest();	
		subastaToTest.setLotesSubasta(loteSubasta);
		
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

		List<LoteSubasta> loteSubasta = new ArrayList<LoteSubasta>();

		Subasta subasta = new Subasta();
		subasta.setTipoSubasta(tipoDelegada);
		subasta.setAsunto(asuntoSubasta);
		subasta.setCargasAnteriores("0");
		subasta.setLotesSubasta(loteSubasta);
		
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
