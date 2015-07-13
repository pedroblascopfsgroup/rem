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

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
	private LiquidacionDao liquidacionDao;

	@InjectMocks
	private LiquidacionManager liquidacionManager;

	/**
	 * Generic Id Liquidacion used to test
	 */
	private static final Long ID_LIQUIDACION = RandomUtils.nextLong();

	@Test
	public void testConfirmarLiquidacion() {
		// Mock methods
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.CONFIRMADA);
		when(liquidacionDao.get(ID_LIQUIDACION)).thenReturn(new LiquidacionPCO());

		// Method to test
		LiquidacionDTO liquidacionParaConfirmar = new LiquidacionDTO();
		liquidacionParaConfirmar.setId(ID_LIQUIDACION);

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
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.SOLICITADA);
		when(liquidacionDao.get(ID_LIQUIDACION)).thenReturn(new LiquidacionPCO());

		// Method to test
		Date fechaCierre = new Date();
		LiquidacionDTO liquidacionParaSolicitar = new LiquidacionDTO();
		liquidacionParaSolicitar.setFechaCierre(fechaCierre);
		liquidacionParaSolicitar.setId(ID_LIQUIDACION);

		liquidacionManager.solicitar(liquidacionParaSolicitar);

		// Capture the result
		ArgumentCaptor<LiquidacionPCO> capturador = ArgumentCaptor.forClass(LiquidacionPCO.class);
		Mockito.verify(liquidacionDao).saveOrUpdate(capturador.capture());

		// Check the result
		LiquidacionPCO liquidacionYaSolicitada  = capturador.getValue();

		assertEquals(DDEstadoLiquidacionPCO.SOLICITADA, liquidacionYaSolicitada.getEstadoLiquidacion().getCodigo());
		assertNotNull(liquidacionYaSolicitada.getFechaSolicitud());
		assertEquals(fechaCierre, liquidacionYaSolicitada.getFechaCierre());
		assertEquals(Float.valueOf(0), liquidacionYaSolicitada.getCapitalVencido());
		assertEquals(Float.valueOf(0), liquidacionYaSolicitada.getCapitalNoVencido());
		assertEquals(Float.valueOf(0), liquidacionYaSolicitada.getInteresesOrdinarios());
		assertEquals(Float.valueOf(0), liquidacionYaSolicitada.getInteresesDemora());
		assertEquals(Float.valueOf(0), liquidacionYaSolicitada.getTotal());
	}

	@Test
	public void testDescartarLiquidacion() {
		// Mock methods
		mockDameValorDiccionarioByCod(DDEstadoLiquidacionPCO.DESCARTADA);
		when(liquidacionDao.get(ID_LIQUIDACION)).thenReturn(new LiquidacionPCO());

		// Method to test
		LiquidacionDTO liquidacionParaDescartar = new LiquidacionDTO();
		liquidacionParaDescartar.setId(ID_LIQUIDACION);
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
}
