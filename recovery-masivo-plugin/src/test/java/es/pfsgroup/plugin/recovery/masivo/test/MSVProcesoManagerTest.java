package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyMap;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVInputFactory;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.impl.MSVSelectorLanzaETJdesdeFM;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.impl.MSVSelectorTestimonioRecibido;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.MSVLanzarETJdesdeFMBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.test.dto.MSVProcesoManagerTestLiberaFicheroDto;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.mejoras.api.revisionProcedimientos.RevisionProcedimientoApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

@RunWith(MockitoJUnitRunner.class)
public class MSVProcesoManagerTest extends SampleBaseTestCase {
	
	//definier el objeto sobre el que vamos a hacer el test
	@InjectMocks 
	private MSVProcesoManager procesoManager;
	
	@Mock
	private GenericABMDao mockGenericDao;
	
	@Mock
	private MSVProcesoDao mockProcesoDao;
	
	@Mock
	private MSVFicheroDao mockFicheroDao;
	
	@Mock
	private UsuarioApi mockUsuarioApi;
	
	@Mock
	private ApiProxyFactory mockProxyFactory;
	
	@Mock
	private MSVExcelParser mockExcelParser;
	
	@Mock
	private RecoveryBPMfwkBatchApi mockRecoveryBPMfwkBatchApi;
	
	@Mock
	private MSVInputFactory mockInputFactory;
	
	@Mock
	private MSVSelectorTestimonioRecibido mockSelectorTestimonioRecibido;
	
	@Mock
	private Asunto mockAsunto;
	
	@Mock
	private Procedimiento mockProcedimiento;
	
	@After
	public void after(){
		reset(mockGenericDao);
		reset(mockProcesoDao);
		reset(mockFicheroDao);
		reset(mockUsuarioApi);
		reset(mockProxyFactory);
		reset(mockRecoveryBPMfwkBatchApi);
		reset(mockInputFactory);
		reset(mockSelectorTestimonioRecibido);
		reset(mockAsunto);
		reset(mockProcedimiento);
	}
	

	@Test
	public void testIniciarProcesoMasivo() throws Exception {
		
		Long idProcesoEsperado=1L;
		MSVProcesoMasivo procesoMasivo=new MSVProcesoMasivo();
		procesoMasivo.setId(idProcesoEsperado);
		
		MSVDtoAltaProceso dto=new MSVDtoAltaProceso();
		dto.setIdTipoOperacion(1L);
		
		when(mockProcesoDao.crearNuevoProceso()).thenReturn(procesoMasivo);
		
		MSVDDOperacionMasiva tipoOperacion=new MSVDDOperacionMasiva();
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoOperacion());
		when(mockGenericDao.get(MSVDDOperacionMasiva.class, filtro)).thenReturn(tipoOperacion);
		
		Long idToken = Math.round((Math.random()*1000));
		when(mockProxyFactory.proxy(eq(RecoveryBPMfwkBatchApi.class))).thenReturn(mockRecoveryBPMfwkBatchApi);
		when(mockRecoveryBPMfwkBatchApi.getToken()).thenReturn(idToken);
		
		Long idProceso= procesoManager.iniciarProcesoMasivo(dto);
		
		assertEquals(idProcesoEsperado, idProceso);
	
	}
	
	@Test
	public void testModificarProcesoMasivoPorIdEstado() throws Exception{
		MSVProcesoMasivo procesoInicial=new MSVProcesoMasivo();
		Long idEstadoFinal=2L;
		Long idProceso=1L;
		
		MSVDtoAltaProceso dto=new MSVDtoAltaProceso();
		MSVDDEstadoProceso estadoFinal=new MSVDDEstadoProceso();
		estadoFinal.setId(idEstadoFinal);
		
		dto.setIdEstadoProceso(idEstadoFinal);
		dto.setIdProceso(idProceso);
		
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "id", idEstadoFinal);
		
		// Bruno 21/2/2013 Verificamos que usarmos el dao del proceso para obtenerlo
		when(mockProcesoDao.mergeAndGet(idProceso)).thenReturn(procesoInicial);
		when(mockGenericDao.get(MSVDDEstadoProceso.class, filtro)).thenReturn(estadoFinal);
		
		MSVProcesoMasivo proceso = procesoManager.modificarProcesoMasivo(dto);
		
		assertEquals(idEstadoFinal, procesoInicial.getEstadoProceso().getId());
		assertNotNull(proceso);
		
		// Bruno 21/2/2013 Verificamos que guardamos el proceso
		verify(mockProcesoDao,times(1)).mergeAndUpdate(procesoInicial);
	}
	
	
	@Test
	public void testModificarProcesoMasivoPorCodigoEstado() throws Exception{
		MSVProcesoMasivo procesoInicial=new MSVProcesoMasivo();
		String codigoEstadoFinal = "PTV";
		Long idProceso=1L;
		
		MSVDtoAltaProceso dto=new MSVDtoAltaProceso();
		MSVDDEstadoProceso estadoFinal=new MSVDDEstadoProceso();
		estadoFinal.setCodigo(codigoEstadoFinal);
		
		dto.setCodigoEstadoProceso(codigoEstadoFinal);
		dto.setIdProceso(idProceso);
		
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoFinal);
		
		// Bruno 21/2/2013 Verificamos que usarmos el dao del proceso para obtenerlo
		when(mockProcesoDao.mergeAndGet(idProceso)).thenReturn(procesoInicial);
		when(mockGenericDao.get(MSVDDEstadoProceso.class, filtro)).thenReturn(estadoFinal);
		
		MSVProcesoMasivo proceso = procesoManager.modificarProcesoMasivo(dto);
		
		assertEquals(codigoEstadoFinal, procesoInicial.getEstadoProceso().getCodigo());
		assertNotNull(proceso);
		
		// Bruno 21/2/2013 Verificamos que guardamos el proceso
		verify(mockProcesoDao,times(1)).mergeAndUpdate(procesoInicial);
	}
	
	
	@Test
	public void testEliminarProceso(){
		Long idProceso=1L;
		
		MSVDocumentoMasivo fichero=new MSVDocumentoMasivo();
		Auditoria auditoria=new Auditoria();
		auditoria.setBorrado(false);
		fichero.setAuditoria(auditoria);
		
		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(fichero);
		
		String resultado=procesoManager.eliminarProceso(idProceso);
		
		verify(mockFicheroDao).delete(fichero);
		verify(mockProcesoDao).deleteById(anyLong());
		assertEquals("ok", resultado);
		
	}
	
	@Test
	public void testMostrarProcesos(){
		
		Usuario usuario = new Usuario();
		usuario.setUsername("SUPER");
		usuario.setId(1L);
		List<MSVProcesoMasivo> procesos=new ArrayList<MSVProcesoMasivo>();
		MSVProcesoMasivo proceso1=new MSVProcesoMasivo();
		procesos.add(proceso1);
		
		when(mockProxyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioApi);
		when(mockUsuarioApi.getUsuarioLogado()).thenReturn(usuario);
		
		when(mockProcesoDao.dameListaProcesos(usuario.getUsername())).thenReturn(procesos);
		

		List<MSVProcesoMasivo> result = procesoManager.mostrarProcesos();

		assertEquals(result, procesos);

		
	}
	
	private MSVProcesoManagerTestLiberaFicheroDto simulaLiberarFichero(Long idProceso, String pEstadoProceso,
			String pTipoOperacion, String codigoEstadoFinal, String rutaFichero) throws Exception {
		
		MSVDDEstadoProceso estadoProceso=new MSVDDEstadoProceso();
		estadoProceso.setCodigo(pEstadoProceso);
		MSVDDOperacionMasiva tipoOperacion=new MSVDDOperacionMasiva();
		tipoOperacion.setCodigo(pTipoOperacion);
		MSVProcesoMasivo proceso= new MSVProcesoMasivo();
		proceso.setId(idProceso);
		proceso.setEstadoProceso(estadoProceso);
		proceso.setTipoOperacion(tipoOperacion);
		MSVDocumentoMasivo fichero=new MSVDocumentoMasivo();
		fichero.setProcesoMasivo(proceso);
		FileItem contenidoFichero= new FileItem();
		File file = new File(MSVUtilTest.getRutaFichero(rutaFichero));
		contenidoFichero.setFile(file);
		fichero.setContenidoFichero(contenidoFichero);
		MSVHojaExcel hojaExcel=new MSVHojaExcel();
		hojaExcel.setFile(file);
		Integer numeroFilasExcel = hojaExcel.getNumeroFilas()-1;
		MSVDtoAltaProceso dto=new MSVDtoAltaProceso();
		MSVDDEstadoProceso estadoFinal=new MSVDDEstadoProceso();
		estadoFinal.setCodigo(codigoEstadoFinal);
		
		dto.setCodigoEstadoProceso(codigoEstadoFinal);
		dto.setIdProceso(idProceso);
		
		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(fichero);
		
		
		MSVProcesoManagerTestLiberaFicheroDto dtoReturn = new MSVProcesoManagerTestLiberaFicheroDto();
		
		dtoReturn.setProceso(proceso);
		dtoReturn.setEstadoFinal(estadoFinal);
		dtoReturn.setDto(dto);
		dtoReturn.setFichero(fichero);
		dtoReturn.setHojaExcel(hojaExcel);
		dtoReturn.setNumeroFilasExcel(numeroFilasExcel);
		
		return dtoReturn;
	}
	
	@Test
	public void testLiberarFichero() throws Exception{
		Long idProceso=1L;
		String codigoEstadoFinal = MSVDDEstadoProceso.CODIGO_VALIDADO; 
		MSVProcesoManagerTestLiberaFicheroDto dtoDatos = simulaLiberarFichero(
				idProceso, 
				codigoEstadoFinal, 
				MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_TESTIMONIO,
				MSVDDEstadoProceso.CODIGO_PTE_PROCESAR,
				"RUTA_EXCEL_PRUEBAS_LIBERAR");
		
		
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoFinal);
		
		// Bruno 21/2/2013 Verificamos que usarmos el dao del proceso para obtenerlo
		when(mockProcesoDao.mergeAndGet(idProceso)).thenReturn(dtoDatos.getProceso());
		when(mockGenericDao.get(MSVDDEstadoProceso.class, filtro)).thenReturn(dtoDatos.getEstadoFinal());
		
		MSVProcesoMasivo procesoFinal = procesoManager.modificarProcesoMasivo(dtoDatos.getDto());
		
		when(mockInputFactory.dameSelector(any(MSVDDOperacionMasiva.class), anyMap())).thenReturn(mockSelectorTestimonioRecibido);
		when(mockSelectorTestimonioRecibido.getTipoInput(anyMap())).thenReturn(MSVDDOperacionMasiva.CODIGO_INPUT_TESTIMONIO_RECIBIDO);
		when(mockProcesoDao.mergeAndGet(idProceso)).thenReturn(dtoDatos.getProceso());
		
		
		when(mockExcelParser.getExcel(dtoDatos.getFichero().getContenidoFichero().getFile())).thenReturn(dtoDatos.getHojaExcel());
		when(mockProxyFactory.proxy(RecoveryBPMfwkBatchApi.class)).thenReturn(mockRecoveryBPMfwkBatchApi);
		
		MSVProcesoMasivo resultado= procesoManager.liberarFichero(idProceso);
		
		assertNotNull(resultado);
		assertEquals(MSVDDEstadoProceso.CODIGO_PTE_PROCESAR, resultado.getEstadoProceso().getCodigo());
		
		// comprobamos que se crean tantos inputs como filas tiene el fichero excel
		verify(mockRecoveryBPMfwkBatchApi,times(dtoDatos.getNumeroFilasExcel())).programaProcesadoInput(anyLong(),any(RecoveryBPMfwkInputDto.class),any(MSVProcedimientoBackOfficeBPMCallback.class));
	}

	@Test
	public void testLiberarFichero_Alta_Reorganizacion() throws Exception{
		Long idProceso=1L;
		String codigoEstadoFinal = MSVDDEstadoProceso.CODIGO_VALIDADO; 
		MSVProcesoManagerTestLiberaFicheroDto dtoDatos = simulaLiberarFichero(
				idProceso, 
				codigoEstadoFinal, 
				MSVDDOperacionMasiva.CODIGO_REORGANIZACION_ASUNTOS,
				MSVDDEstadoProceso.CODIGO_PROCESADO,
				"RUTA_EXCEL_PRUEBAS_PLANTILLAS");
		
		when(mockExcelParser.getExcel(dtoDatos.getFichero().getContenidoFichero().getFile())).thenReturn(dtoDatos.getHojaExcel());
		RevisionProcedimientoApi mockRevisionProcedimientoApi = mock(RevisionProcedimientoApi.class);
		when(mockProxyFactory.proxy(RevisionProcedimientoApi.class)).thenReturn(mockRevisionProcedimientoApi);
		
		procesoManager.liberarFichero(idProceso);
		
		//verify(mockRevisionProcedimientoCoreApi, times(dtoDatos.getNumeroFilasExcel())).saveRevision(any(RevisionProcedimientoCoreDto.class));
	}	
	
	@Test
	public void testLiberarFichero_LanzarTramite() throws Exception{
		Long idProceso=1L;
		EXTContrato mockContrato = mock(EXTContrato.class);
		DDEstadoAsunto estadoAsunto = new DDEstadoAsunto();
		estadoAsunto.setId(2L);
		
		TipoProcedimiento tipoProcedimientoMonitorio = new TipoProcedimiento();
		tipoProcedimientoMonitorio.setId(1L);
		
		String codigoEstadoFinal = MSVDDEstadoProceso.CODIGO_VALIDADO; 
		MSVProcesoManagerTestLiberaFicheroDto dtoDatos = simulaLiberarFichero(
				idProceso, 
				codigoEstadoFinal, 
				MSVDDOperacionMasiva.CODIGO_LANZAMIENTO_ETJ_DESDE_FM,
				MSVDDEstadoProceso.CODIGO_PROCESADO,
				"RUTA_EXCEL_PRUEBAS_PLANTILLAS");
		
		when(mockExcelParser.getExcel(dtoDatos.getFichero().getContenidoFichero().getFile())).thenReturn(dtoDatos.getHojaExcel());
		
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "nroContrato", 123456);
		when(mockGenericDao.get(EXTContrato.class, filtro)).thenReturn(mockContrato);

		filtro=mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVProcesoManager.ESTADO_ASUNTO_FM);
		when(mockGenericDao.get(DDEstadoAsunto.class, filtro)).thenReturn(estadoAsunto);

		filtro=mockGenericDao.createFilter(FilterType.EQUALS, "codigo", MSVProcesoManager.TIPO_PROCEDIMIENTO_FIN_MONITORIO);
		when(mockGenericDao.get(TipoProcedimiento.class, filtro)).thenReturn(tipoProcedimientoMonitorio);

		List<Asunto> asuntos = new ArrayList<Asunto>();
		asuntos.add(mockAsunto);
		when(mockContrato.getAsuntosActivos()).thenReturn(asuntos);

		List<Procedimiento> prcs = new ArrayList<Procedimiento>();
		prcs.add(mockProcedimiento);
		when(mockAsunto.getProcedimientos()).thenReturn(prcs);
		when(mockProcedimiento.getId()).thenReturn(1L);
		when(mockAsunto.getEstadoAsunto()).thenReturn(estadoAsunto);
		when(mockProcedimiento.getTipoProcedimiento()).thenReturn(tipoProcedimientoMonitorio);
		
		MSVSelectorLanzaETJdesdeFM mockSelectorLanzaETJdesdeFM = mock(MSVSelectorLanzaETJdesdeFM.class);
		
		when(mockInputFactory.dameSelector(any(MSVDDOperacionMasiva.class), anyMap())).thenReturn(mockSelectorLanzaETJdesdeFM);
		when(mockSelectorLanzaETJdesdeFM.getTipoInput(anyMap())).thenReturn(MSVDDOperacionMasiva.CODIGO_INPUT_LANZAR_ETJ_DESDE_FM);
		
		when(mockProxyFactory.proxy(eq(RecoveryBPMfwkBatchApi.class))).thenReturn(mockRecoveryBPMfwkBatchApi);
		
		procesoManager.liberarFichero(idProceso);
		
		verify(mockRecoveryBPMfwkBatchApi,times(dtoDatos.getNumeroFilasExcel())).programaProcesadoInput(anyLong(),any(RecoveryBPMfwkInputDto.class),any(MSVLanzarETJdesdeFMBPMCallback.class));
	}
	
	@Test
	public void testGetByToken() {
		Long token = 1L;
		MSVProcesoMasivo procesoMasivo=new MSVProcesoMasivo();
		procesoMasivo.setToken(token);
		
		when(mockProcesoDao.getByToken(token)).thenReturn(procesoMasivo);
		MSVProcesoMasivo result =  procesoManager.getByToken(token);
		
		assertEquals(result.getToken(), token);
	}
	

}
