package es.pfsgroup.plugin.precontencioso.liquidacion;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.when;

import java.util.Date;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.manager.LiquidacionManager;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@RunWith(MockitoJUnitRunner.class)
public class LiquidacionManagerTest {

	@Mock
    private ApiProxyFactory mockProxyFactory;

	@Mock
	private UtilDiccionarioApi mockUtilDiccionarioApi;

	@Mock
	private GestorTareasApi gestorTareasApi;
	
	@Mock
	private LiquidacionDao liquidacionDao;

	@InjectMocks
	private LiquidacionManager liquidacionManager;

	/**
	 * Generic Id Liquidacion used to test
	 */
	private static final Long ID_RANDOM = RandomUtils.nextLong();

	@Test
	public void testConfirmarLiquidacion() {
		// Mock methods
		when(mockProxyFactory.proxy(GestorTareasApi.class)).thenReturn(gestorTareasApi);
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.CONFIRMADA);
		when(liquidacionDao.get(ID_RANDOM)).thenReturn(newLiquidacionPcoToTest());

		// Method to test
		LiquidacionDTO liquidacionParaConfirmar = new LiquidacionDTO();
		liquidacionParaConfirmar.setId(ID_RANDOM);

		liquidacionManager.confirmar(liquidacionParaConfirmar);

		// Capture the result
		ArgumentCaptor<LiquidacionPCO> capturador = ArgumentCaptor.forClass(LiquidacionPCO.class);
		Mockito.verify(liquidacionDao).saveOrUpdate(capturador.capture());

		// Check the result
		LiquidacionPCO liquidacionYaConfirmada = capturador.getValue();
		assertEquals(DDEstadoLiquidacionPCO.CONFIRMADA, liquidacionYaConfirmada.getEstadoLiquidacion().getCodigo());
		assertNotNull(liquidacionYaConfirmada.getFechaConfirmacion());
	}

	@Test
	public void testSolicitarLiquidacion() {
		// Mock methods
		when(mockProxyFactory.proxy(GestorTareasApi.class)).thenReturn(gestorTareasApi);
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.SOLICITADA);
		when(liquidacionDao.get(ID_RANDOM)).thenReturn(newLiquidacionPcoToTest());

		// Method to test
		Date fechaCierre = new Date();
		LiquidacionDTO liquidacionParaSolicitar = new LiquidacionDTO();
		liquidacionParaSolicitar.setFechaCierre(fechaCierre);
		liquidacionParaSolicitar.setId(ID_RANDOM);

		liquidacionManager.solicitar(liquidacionParaSolicitar);

		// Capture the result
		ArgumentCaptor<LiquidacionPCO> capturador = ArgumentCaptor.forClass(LiquidacionPCO.class);
		Mockito.verify(liquidacionDao).saveOrUpdate(capturador.capture());

		// Check the result
		LiquidacionPCO liquidacionYaSolicitada  = capturador.getValue();

		assertEquals(DDEstadoLiquidacionPCO.SOLICITADA, liquidacionYaSolicitada.getEstadoLiquidacion().getCodigo());
		assertNotNull(liquidacionYaSolicitada.getFechaSolicitud());
		assertEquals(fechaCierre, liquidacionYaSolicitada.getFechaCierre());
		assertEquals(null, liquidacionYaSolicitada.getCapitalVencido());
		assertEquals(null, liquidacionYaSolicitada.getCapitalNoVencido());
		assertEquals(null, liquidacionYaSolicitada.getInteresesOrdinarios());
		assertEquals(null, liquidacionYaSolicitada.getInteresesDemora());
		assertEquals(null, liquidacionYaSolicitada.getComisiones());
		assertEquals(null, liquidacionYaSolicitada.getGastos());
		assertEquals(null, liquidacionYaSolicitada.getImpuestos());
		assertEquals(null, liquidacionYaSolicitada.getTotal());
	}

	@Test
	public void testDescartarLiquidacion() {
		// Mock methods
		when(mockProxyFactory.proxy(GestorTareasApi.class)).thenReturn(gestorTareasApi);
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.DESCARTADA);
		when(liquidacionDao.get(ID_RANDOM)).thenReturn(newLiquidacionPcoToTest());

		// Method to test
		LiquidacionDTO liquidacionParaDescartar = new LiquidacionDTO();
		liquidacionParaDescartar.setId(ID_RANDOM);
		liquidacionManager.descartar(liquidacionParaDescartar);

		// Capture the result
		ArgumentCaptor<LiquidacionPCO> capturador = ArgumentCaptor.forClass(LiquidacionPCO.class);
		Mockito.verify(liquidacionDao).saveOrUpdate(capturador.capture());

		// Check the result
		LiquidacionPCO liquidacionYaDescartada = capturador.getValue();

		assertEquals(DDEstadoLiquidacionPCO.DESCARTADA, liquidacionYaDescartada.getEstadoLiquidacion().getCodigo());
	}
	
	/**
	 * Realiza un mock para el metodo dameValorDiccionarioByCod de mockUtilDiccionarioApi
	 * @param codigo de estado
	 */
	private void mockDameValorDiccionarioByCod(String codigoEstado) {
		DDEstadoLiquidacionPCO estadoLiquidacionReturn = new DDEstadoLiquidacionPCO();
		estadoLiquidacionReturn.setCodigo(codigoEstado);

		when(mockProxyFactory.proxy(UtilDiccionarioApi.class)).thenReturn(mockUtilDiccionarioApi);
		when(mockUtilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, codigoEstado)).thenReturn(estadoLiquidacionReturn);
	}
	
	private LiquidacionPCO newLiquidacionPcoToTest() {
		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(ID_RANDOM);

		ProcedimientoPCO procedimientoPco = new ProcedimientoPCO();
		procedimientoPco.setProcedimiento(procedimiento);

		LiquidacionPCO liquidacion = new LiquidacionPCO();
		liquidacion.setProcedimientoPCO(procedimientoPco);
		return liquidacion;
	}
}
