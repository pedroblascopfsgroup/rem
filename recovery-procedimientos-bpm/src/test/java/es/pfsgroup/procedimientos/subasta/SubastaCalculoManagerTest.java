package es.pfsgroup.procedimientos.subasta;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
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
		DDTiposAsunto tipoAsuntoConcursal = new DDTiposAsunto();
		tipoAsuntoConcursal.setCodigo(DDTiposAsunto.CONCURSAL);

		EXTAsunto asuntoSubasta = new EXTAsunto();
		asuntoSubasta.setTipoAsunto(tipoAsuntoConcursal);

		Subasta subastaToTest = newSubastaToTest();
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
		float deudaIrregular = 1000000.23F;
		float posVivaNoVencida = 2000.34F;
		String estadoActivo = DDEstadoContrato.ESTADO_CONTRATO_ACTIVO;

		Subasta subastaToTest = newSubastaToTestDeudaMayor1Millon(deudaIrregular, posVivaNoVencida, estadoActivo);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		comprobarSiLaSubastaHaSidoModificadaANoDelegada();
	}

	/**
	 * Si la deuda de las operaciones relacionadas es mayor a un millon y el estado es no recibido
	 * 
	 * Resultado esperado:
	 * 
	 * 	Que el tipo subasta no sea modificado 
	 */
	@Test
	public void testDeterminarTipoSubastaConDeudaMayorDeUnMillonYEstadoNoRecibido(){
		float deudaIrregular = 1000000.23F;
		float posVivaNoVencida = 2000.34F;
		String estadoNoRecibido = DDEstadoContrato.ESTADO_CONTRATO_NORECIBIDO;

		Subasta subastaToTest = newSubastaToTestDeudaMayor1Millon(deudaIrregular, posVivaNoVencida, estadoNoRecibido);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		// verify never call update
		verify(genericDao, never()).update(eq(Subasta.class), any(Subasta.class));
	}

	/**
	 * Si la subasta cumple las condiciones:
	 * 
	 * 	Riesgo de Consignación es true
	 *  Riesgo de Consignación > 10% de Deuda Irregular
	 *  
	 *  Resultado esperado: El estado es cambiado
	 *  
	*/
	@Test
	public void testDeterminarTipoSubastaRiesgoConsignacionSuperaUmbralSiRiesgoMayor10PorCiento(){
		float deudaIrregular = 5000f;
		float posVivaNoVencida = 5000f;
		float insPujasSinPostores = 12000.0f;

		Subasta subastaToTest = newSubastaToTestRiesgoDeConsignacionSuperaUmbral(deudaIrregular, posVivaNoVencida, insPujasSinPostores);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		comprobarSiLaSubastaHaSidoModificadaANoDelegada();
	}

	/**
	 * Si la subasta cumple las condiciones:
	 * 
	 * 	Riesgo de Consignación es true
	 *  Calculo de Riesgo de Consignación es negativo
	 *  
	 * Resultado esperado: 
	 *  
	 *  El estado no es cambiado y continua del tipo subasta delegada
	 *  
	 */
	@Test
	public void testDeterminarTipoSubastaDelegadaSiRiesgoConsignacionEsNegativo(){
		float deudaIrregular = 5000.0f;
		float posVivaNoVencida = 5000.0f;
		float insPujasSinPostores = 5000.0f;

		Subasta subastaToTest = newSubastaToTestRiesgoDeConsignacionSuperaUmbral(deudaIrregular, posVivaNoVencida, insPujasSinPostores);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		// verify never call update
		verify(genericDao, never()).update(eq(Subasta.class), any(Subasta.class));
	}
	
	/**
	 * Si la subasta no cumple las condiciones:
	 * 
	 *  Riesgo de Consignación > 10%
	 *  Riesgo de Consignación > 15000
	 *  
	 * Resultado esperado: 
	 *  
	 *  El estado no es cambiado y continua del tipo subasta delegada
	 *  
	 */
	@Test
	public void testDeterminarTipoSubastaDelegadaSiRiesgoConsignacionNoCumpleLasCondiciones(){
		float deudaIrregular = 0.0f;
		float posVivaNoVencida = 5000.0f;
		float insPujasSinPostores = 5000.1f;

		Subasta subastaToTest = newSubastaToTestRiesgoDeConsignacionSuperaUmbral(deudaIrregular, posVivaNoVencida, insPujasSinPostores);

		// Method to test
		subastaCalculoManager.determinarTipoSubastaTrasPropuesta(subastaToTest);

		// verify never call update
		verify(genericDao, never()).update(eq(Subasta.class), any(Subasta.class));
	}

	/**
	 * Dummy
	 * provee una subasta de tipo por defecto (delegada) que posee una deuda mayor de un millon
	 * 
	 * @return
	 */
	private Subasta newSubastaToTestDeudaMayor1Millon(float deudaIrregular, float posVivaNoVencida, String estadoNoRecibido) {
		DDEstadoContrato estadoContrato = new DDEstadoContrato();
		estadoContrato.setCodigo(estadoNoRecibido);	

		Movimiento movimiento = new Movimiento();
		movimiento.setDeudaIrregular(deudaIrregular);
		movimiento.setPosVivaNoVencida(posVivaNoVencida);

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
		lote.setRiesgoConsignacion(false);

		List<LoteSubasta> loteSubasta = new ArrayList<LoteSubasta>();
		loteSubasta.add(lote);

		Subasta subastaToTest = newSubastaToTest();	
		subastaToTest.setLotesSubasta(loteSubasta);

		return subastaToTest;
	}
	
	/**
	 * Dummy
	 * provee una subasta de tipo por defecto (delegada) que el riesgo de consignacion supera el umbral
	 * 
	 * @return dummy
	 */
	private Subasta newSubastaToTestRiesgoDeConsignacionSuperaUmbral(float deudaIrregular, float posVivaNoVencida, float insPujasSinPostores) {
		Movimiento movimiento = new Movimiento();
		movimiento.setDeudaIrregular(deudaIrregular);
		movimiento.setPosVivaNoVencida(posVivaNoVencida);

		ArrayList<Movimiento> arrayMovimientos = new ArrayList<Movimiento>();
		arrayMovimientos.add(movimiento);

		Contrato contrato = new Contrato();
		contrato.setMovimientos(arrayMovimientos);

		Expediente expediente = new Expediente();

		ExpedienteContrato expedienteContrato = new ExpedienteContrato();
		expedienteContrato.setContrato(contrato);
		expedienteContrato.setExpediente(expediente);

		ArrayList<ExpedienteContrato> arrayExpedienteContratos = new ArrayList<ExpedienteContrato>();
		arrayExpedienteContratos.add(expedienteContrato);

		Procedimiento procedimiento = new Procedimiento();

		ArrayList<Procedimiento> arrayProcedimientos = new ArrayList<Procedimiento>();
		arrayProcedimientos.add(procedimiento);

		Asunto asunto = new Asunto();
		asunto.setProcedimientos(arrayProcedimientos);

		procedimiento.setAsunto(asunto);
		procedimiento.setExpedienteContratos(arrayExpedienteContratos);

		LoteSubasta lote = new LoteSubasta();
		lote.setRiesgoConsignacion(true);
		lote.setInsPujaSinPostores(insPujasSinPostores);
		lote.setBienes(new ArrayList<Bien>());

		ArrayList<LoteSubasta> arrayLotes = new ArrayList<LoteSubasta>();
		arrayLotes.add(lote);

		Subasta subastaToTest = newSubastaToTest();
		subastaToTest.setLotesSubasta(arrayLotes);
		subastaToTest.setProcedimiento(procedimiento);

		return subastaToTest;
	}

	/**
	 * Dummy
	 * provee una subasta de tipo por defecto (delegada) que no cumple ninguna condicion para que se cambie el tipo a no delegada.
	 * 
	 * @return dummy
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

		// Subasta
		DDTipoSubasta tipoDelegada = new DDTipoSubasta();
		// Por defecto todas las subastas son de tipo delegada
		tipoDelegada.setCodigo(DDTipoSubasta.DEL);

		// Procedimiento Asunto
		Asunto asunto = new Asunto();
		asunto.setProcedimientos(new ArrayList<Procedimiento>());

		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setAsunto(asunto);

		List<LoteSubasta> loteSubasta = new ArrayList<LoteSubasta>();

		Subasta subasta = new Subasta();
		subasta.setTipoSubasta(tipoDelegada);
		subasta.setAsunto(asuntoSubasta);
		subasta.setCargasAnteriores("0");
		subasta.setLotesSubasta(loteSubasta);
		subasta.setProcedimiento(procedimiento);

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
