package es.pfsgroup.plugin.recovery.masivo.test.callbacks.lanzarEJTdesdeFM.api.impl;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;




import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcedimientoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api.impl.MSVLanzarETJdesdeFMCallback;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVContratoDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.test.MSVUtilTest;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVLanzaETJdesdeFMColumns;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

@RunWith(MockitoJUnitRunner.class)
public class MSVLanzarETJdesdeFMCallbackTest  {
	
	private Random r = new Random();
	
	@InjectMocks MSVLanzarETJdesdeFMCallback mockMSVLanzarETJdesdeFMCallback;

	@Mock private MSVFicheroDao mockFicheroDao;
	@Mock private ApiProxyFactory mockProxyFactory;	
	@Mock private GenericABMDao mockGenericDao;
	@Mock private MSVContratoDao mockMSVContratoDao;
	@Mock private ProcedimientoDao mockProcedimientoDao;
	
	private Long tokenProceso;
	
	@Before
	public void before() {
		tokenProceso=r.nextLong();
	}
	
	@After
	public void after() {
		reset(mockFicheroDao);
		reset(mockProxyFactory);
		reset(mockGenericDao);
		reset(mockMSVContratoDao);
		reset(mockProcedimientoDao);
	}
	
	@Test
	public void testOnEndProcessLong() {
		// este m�todo no hace nada
		assertTrue("Este m�todo no est� implementado", true);
	}

	@Test
	public void testOnStartProcessLong() throws Exception {
		MSVProcesoMasivo msvProcesoMasivo = new MSVProcesoMasivo();
		msvProcesoMasivo.setId(r.nextLong());
		
		MSVProcesoApi mockMSVProcesoApi = mock(MSVProcesoApi.class);		
		when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockMSVProcesoApi);
		when(mockMSVProcesoApi.getByToken(tokenProceso)).thenReturn(msvProcesoMasivo);
		
		//getHojaExcel		
		MSVDocumentoMasivo fichero = getFichero();
		when(mockFicheroDao.findByIdProceso(msvProcesoMasivo.getId())).thenReturn(fichero);
		
		mockMSVLanzarETJdesdeFMCallback.onStartProcess(tokenProceso);
		
		verify(mockMSVProcesoApi, times(1)).modificarProcesoMasivo(any(MSVDtoAltaProceso.class));

	}

	@Test
	public void testOnErrorLongRecoveryBPMfwkInputInfoString() {
		// este m�todo no hace nada
		assertTrue("Este m�todo no est� implementado", true);

	}
	
	@Test
	public void testOnSuccessLongRecoveryBPMfwkInputInfo() {
		Long idProcedimiento = r.nextLong();
		Long idProcedimientoHijo = r.nextLong();
				
		Map<String, Object> datos = new HashMap<String, Object>();
		datos.put(MSVLanzaETJdesdeFMColumns.PRINCIPAL, null);
		datos.put(MSVProcesoManager.COLUMNA_NUMERO_FILA, "1");
		
		FileItem mockFileItem = mock(FileItem.class);
		RecoveryBPMfwkInputDto input = new RecoveryBPMfwkInputDto();
		input.setAdjunto(mockFileItem);
		input.setCodigoTipoInput("CODIGO");
		input.setIdProcedimiento(idProcedimiento);
		input.setDatos(datos);
		
		Filter mockFilter = mock(Filter.class);
		TipoProcedimiento mockTipoProcedimiento = mock(TipoProcedimiento.class);
		ProcedimientoApi mockProcedimientoApi = mock(ProcedimientoApi.class);
		Procedimiento mockProcedimiento = mock(Procedimiento.class);
		MEJProcedimiento mockProcedimientoHijo = mock(MEJProcedimiento.class);
		when(mockProcedimientoHijo.getId()).thenReturn(idProcedimientoHijo);
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVProcesoManager.TIPO_PROCEDIMIENTO_ETJ)).thenReturn(mockFilter);
		when(mockGenericDao.get(TipoProcedimiento.class, mockFilter)).thenReturn(mockTipoProcedimiento);
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		when(mockProcedimientoDao.get(idProcedimiento)).thenReturn(mockProcedimiento);
//		when(mockProcedimientoApi.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);
		
		JBPMProcessApi mockJBPMProcessApi = mock(JBPMProcessApi.class);
		when(mockProxyFactory.proxy(JBPMProcessApi.class)).thenReturn(mockJBPMProcessApi);
		MSVProcedimientoApi mockMSVProcedimientoApi = mock(MSVProcedimientoApi.class);
		
		when(mockProxyFactory.proxy(MSVProcedimientoApi.class)).thenReturn(mockMSVProcedimientoApi);		
		when(mockMSVProcedimientoApi.creaProcedimientoHijoMasivo(mockTipoProcedimiento, mockProcedimiento)).thenReturn(mockProcedimientoHijo);
		
//		when(mockProcedimientoDao.get(mockProcedimientoHijo.getId())).thenReturn(mockProcedimientoHijo);		
//		when(mockProcedimientoApi.getProcedimiento(mockProcedimientoHijo.getId())).thenReturn(mockProcedimientoHijo);
				
		
		Asunto mockAsunto = mock(Asunto.class);
		Set<Contrato> contratos = new HashSet<Contrato>();
		Contrato mockContrato = mock(Contrato.class);
		contratos.add(mockContrato);
		when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
		when(mockAsunto.getContratos()).thenReturn(contratos);
		Long idContrato = r.nextLong();
		when(mockContrato.getId()).thenReturn(idContrato);
		
		when(mockMSVContratoDao.getRestanteDemanda(idContrato)).thenReturn(BigDecimal.valueOf(r.nextDouble()));
		
		DDEstadoProcedimiento mockDDEstadoProcedimiento = mock(DDEstadoProcedimiento.class);
		DDEstadoProcedimiento mockDDEstadoProcedimientoDao = mock(DDEstadoProcedimiento.class);
		when(mockProcedimiento.getEstadoProcedimiento()).thenReturn(mockDDEstadoProcedimiento);
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)).thenReturn(mockFilter);
		when(mockGenericDao.get(DDEstadoProcedimiento.class, mockFilter)).thenReturn(mockDDEstadoProcedimientoDao);
		
		DDEstadoAsunto mockDDEstadoAsunto = mock(DDEstadoAsunto.class);
		when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO)).thenReturn(mockFilter);
		when(mockGenericDao.get(DDEstadoAsunto.class, mockFilter)).thenReturn(mockDDEstadoAsunto);
		when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
		when(mockAsunto.getEstadoAsunto()).thenReturn(mockDDEstadoAsunto);
		
		when(mockJBPMProcessApi.lanzaBPMAsociadoAProcedimiento(idProcedimientoHijo, null)).thenReturn(r.nextLong());
		
		
		mockMSVLanzarETJdesdeFMCallback.onSuccess(tokenProceso, input);
		
		// este m�todo no hace nada
//		assertTrue("Este m�todo no est� implementado", true);
		
		verify(mockProcedimientoDao, times(1)).saveOrUpdate(mockProcedimientoHijo);
		verify(mockProcedimientoDao, times(1)).saveOrUpdate(mockProcedimiento);
		verify(mockGenericDao, times(1)).update(Asunto.class, mockAsunto);
		
		
	}	

	/**
	 * Simula la busqueda del ficheroDao
	 * 
	 * @return
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	private MSVDocumentoMasivo getFichero() throws IllegalArgumentException, IOException {
		
		MSVDocumentoMasivo fichero = new MSVDocumentoMasivo();
		
		FileItem fileitem = new FileItem();		
		fileitem.setFile(new File(MSVUtilTest.getRutaFichero("RUTA_EXCEL_PRUEBAS_LIBERAR")));
		fichero.setContenidoFichero(fileitem);
		
		return fichero;
	}
}
