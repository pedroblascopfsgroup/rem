package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.ServletContext;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVResolucionManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVCampoDinamico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasApi;

@RunWith(MockitoJUnitRunner.class)
public class MSVResolucionManagerTest {

	@InjectMocks MSVResolucionManager msvResolucionManager;
	
	@Mock private GenericABMDao mockGenericDao;
	@Mock private UsuarioApi mockUsuarioApi;
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private MSVResolucionDao mockMSVResolucionDao;
	@Mock private ServletContext mockServletContext;
	@Mock private ProcedimientoApi mockProcedimientoApi;
	@Mock private RecoveryBPMfwkConfigApi mockBPMConfigApi;
	@Mock private RecoveryBPMfwkDatosProcedimientoApi mockDatosProcedimientoManager;
	
	private Random r = new Random();

	public final static String FICHERO_RESOL_PRUEBA="FICHERO_RESOL_PRUEBA";
	public final static String FICHERO_RESOL_INEXISTENTE="FICHERO_RESOL_INEXISTENTE";
	
	@After
	public void after(){
		reset(mockGenericDao);
		reset(mockUsuarioApi);
		reset(mockProxyFactory);
		reset(mockMSVResolucionDao);
		reset(mockServletContext);
		reset(mockProcedimientoApi);
		reset(mockBPMConfigApi);
		reset(mockDatosProcedimientoManager);
	}
	


	/**
	 * Tests del m�todo List<MSVResolucion> mostrarResoluciones()
	 * @throws Exception
	 */
	@Test
	public void testMostrarResoluciones() throws Exception {
		
		Usuario usuario = new Usuario();
		usuario.setUsername("SUPER");
		usuario.setId(1L);
		
		List<MSVResolucion> lista = new ArrayList<MSVResolucion>();
		
		when(mockProxyFactory.proxy(UsuarioApi.class)).thenReturn(mockUsuarioApi);
		when(mockUsuarioApi.getUsuarioLogado()).thenReturn(usuario);
		when(mockMSVResolucionDao.dameListaProcesos(usuario.getUsername())).thenReturn(lista);
		
		List<MSVResolucion> result = msvResolucionManager.mostrarResoluciones();
		
		//Comprobamos que el resultado no es nulo y devuleve una lista de resoluciones.
		assertNotNull(result);
		assertSame(lista, result);
	}

	
	
	/**
	 * Tests del m�todo MSVResolucion getResolucion(Long idResolucion)
	 */
	@Test
	public void testGetResolucion(){
		
		//idResolucion nulo.
		try {
			msvResolucionManager.getResolucion(null);
		} catch (BusinessOperationException ex) {
			//Excepci�n Controlada
		}
		
		//Comportamiento normal.
		Long idResolucion = r.nextLong();
		try {
			MSVResolucion resolucion = new MSVResolucion();
			when(mockMSVResolucionDao.mergeAndGet(any(Long.class))).thenReturn(resolucion);
			MSVResolucion result = msvResolucionManager.getResolucion(idResolucion);
			
			//Comprobamos que el resultado no es nulo y devuleve una lista de resoluciones.
			assertNotNull(result);
			assertSame(resolucion, result);
		} catch (Exception e) {
			fail("Error en el test testGetResolucion");
		}
		
	}
	
	
	
	/**
	 * Tests del m�todo MSVResolucion guardarDatos(MSVResolucionesDto dto)
	 */
	@Test
	public void testGuardarDatos(){
		
		MSVResolucionesDto dto = new MSVResolucionesDto();
		MSVResolucion resolucion = new MSVResolucion();
		String rutaFichero = MSVUtilTest.getRutaFichero(FICHERO_RESOL_PRUEBA);
		MSVDDTipoJuicio msvDDTipoJuicio = new MSVDDTipoJuicio();
		MSVDDTipoResolucion msvDDTipoResolucion = new MSVDDTipoResolucion();
		
		when(mockServletContext.getRealPath(any(String.class))).thenReturn(rutaFichero);
		when(mockMSVResolucionDao.get(any(Long.class))).thenReturn(resolucion);

		when(mockGenericDao.get(MSVDDTipoJuicio.class, mockGenericDao.createFilter(any(FilterType.class), any(String.class), any(Long.class)))).thenReturn(msvDDTipoJuicio);
		when(mockGenericDao.get(MSVDDTipoResolucion.class, mockGenericDao.createFilter(any(FilterType.class), any(String.class), any(Long.class)))).thenReturn(msvDDTipoResolucion);

		//Comprobamos que el resultado no es nulo.
		MSVResolucion result = msvResolucionManager.guardarDatos(dto);
		assertNotNull(result);
		
		//Comprobamos que existe un fichero.
		assertNotNull(result.getContenidoFichero().getFile());
		
		//Comprobamos que se rellenan los campos.
		dto.setComboTipoJuicioNew(r.nextLong());
		dto.setComboTipoResolucionNew(r.nextLong());
		dto.setIdAsunto(r.nextLong());
		Map<String, String> camposDinamicos = new HashMap<String, String>();
		camposDinamicos.put(RandomStringUtils.randomAlphanumeric(15) , RandomStringUtils.randomAlphanumeric(15));
		camposDinamicos.put(RandomStringUtils.randomAlphanumeric(15) , "2012-12-25T00:00:00");
		dto.setCamposDinamicos(camposDinamicos);
		
		result = msvResolucionManager.guardarDatos(dto);
		assertNotNull(result);
		assertEquals(msvDDTipoJuicio, result.getTipoJuicio());
		assertEquals(msvDDTipoResolucion, result.getTipoResolucion());
		
		//Comprobamos que el resultado no es nulo y se devuelve la resoluci�n correcta.
		dto.setIdResolucion(r.nextLong());
		MSVCampoDinamico campo1 = new MSVCampoDinamico();
		campo1.setNombreCampo(RandomStringUtils.randomAlphanumeric(15));
		campo1.setValorCampo(RandomStringUtils.randomAlphanumeric(15));
		campo1.setId(r.nextLong());
		Set<MSVCampoDinamico> campos = new HashSet<MSVCampoDinamico>();
		campos.add(campo1);
		
		camposDinamicos.put(campo1.getNombreCampo() , RandomStringUtils.randomAlphanumeric(15));
		dto.setCamposDinamicos(camposDinamicos);
		
		resolucion.setCamposDinamicos(campos);
		result = msvResolucionManager.guardarDatos(dto);
		
		//FIXME: comprobar que realmente la resoluci�n que se recupera es correcta.
		assertNotNull(result);
		assertEquals(resolucion, result);
		
		
	}
	
	/**
	 * Tests del m�todo String dameAyuda(Long idTipoResolucion)
	 */
	@Test
	public void testDameAyuda(){
		
		Long idTipoResolucion = r .nextLong();
		String ayuda = String.valueOf(r.nextLong());
		MSVDDTipoResolucion msvDDTipoResolucion = new MSVDDTipoResolucion();
		msvDDTipoResolucion.setAyuda(ayuda);
		
		try {
			when(mockGenericDao.get(MSVDDTipoResolucion.class, mockGenericDao.createFilter(any(FilterType.class), any(String.class), any(Long.class)))).thenReturn(msvDDTipoResolucion);
			String result = msvResolucionManager.dameAyuda(idTipoResolucion);
			
			//Comprobamos que el resultado no es nulo y devuleve una lista de resoluciones.
			assertNotNull(result);
			assertSame(ayuda, result);
		} catch (Exception e) {
			fail("Error en el test testDameAyuda");
		}
		
	}
	
	/**
	 * Tests del m�todo {@link MSVResolucionManager#getTipoResolucion(Long)}
	 */
	@Test
	public void testGetTipoResolucion(){
		
		//Inicializaci�n.
		Long idTipoResolucion = r.nextLong();
		Filter f1 = mock(Filter.class);
		MSVDDTipoResolucion msvDDTipoResolucion = new MSVDDTipoResolucion();
		msvDDTipoResolucion.setId(idTipoResolucion);
		
		//Comportamiento.
		when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idTipoResolucion)).thenReturn(f1);
		when(mockGenericDao.get(MSVDDTipoResolucion.class, f1)).thenReturn(msvDDTipoResolucion);
		
		//Ejecuci�n.
		MSVDDTipoResolucion result = msvResolucionManager.getTipoResolucion(idTipoResolucion);
		
		//Validaciones
		assertNotNull(result);
		assertEquals("El idTipoResolucion no es correcto.", msvDDTipoResolucion.getId(), result.getId());
		assertSame(msvDDTipoResolucion, result);
	}
	
	/**
	 * Tests del m�todo {@link MSVResolucionManager#getTiposDeResolucion(Long)}
	 */
	@Test
	public void testGetTiposDeResolucion(){
		
		//Inicializaci�n.
		Long idProcedimiento = r.nextLong();
		Procedimiento mockProcedimiento = mock(Procedimiento.class);
		TipoProcedimiento mockTipoProcedimiento = mock(TipoProcedimiento.class);
		Filter mockFilter = mock(Filter.class);
		List<MSVDDTipoResolucion> lista = new ArrayList<MSVDDTipoResolucion>();
		
		//idProcedimiento Nulo
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		try{
			msvResolucionManager.getTiposDeResolucion(null);
			fail("No se lanz� la excepci�n.");
		}
		catch(BusinessOperationException ex){
			//Excepci�n controlada.
		}
		
		//procedimiento Nulo
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		try{
			msvResolucionManager.getTiposDeResolucion(idProcedimiento);
			fail("No se lanz� la excepci�n.");
		}
		catch(BusinessOperationException ex){
			//Excepci�n controlada.
		}
		
		//Comportamiento normal.
		when(mockProcedimientoApi.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);
		when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipoProcedimiento);
		when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoJuicio.tipoProcedimiento", mockProcedimiento.getTipoProcedimiento())).thenReturn(mockFilter);
		when(mockGenericDao.getList(MSVDDTipoResolucion.class, mockFilter)).thenReturn(lista);
		
		//Ejecuci�n.
		List<MSVDDTipoResolucion> result = msvResolucionManager.getTiposDeResolucion(idProcedimiento);
		
		//Validaciones
		assertNotNull(result);
		assertEquals("El resultado no es correcto.", result.size(), lista.size());
		
	}
	
	/**
	 * Tests del m�todo {@link MSVResolucionManager#procesaResolucion(Long)}
	 * Este test hay que llevarlo al plugin de lindorff al igual que todo el c�digo de resoluciones.
	 */
	@Test
	public void testProcesaResolucion(){
		
		//Inicializaci�n.
		Long idResolucion = r.nextLong();
		MSVResolucion msvResolucion = new MSVResolucion();
		Filter mockFilter = mock(Filter.class);
		MSVDDEstadoProceso msvDDEstadoProceso = new MSVDDEstadoProceso();
		String[] codigos = new String[]{MSVDDEstadoProceso.CODIGO_ERROR, MSVDDEstadoProceso.CODIGO_PROCESADO};
		msvDDEstadoProceso.setCodigo(codigos[(int)(Math.random() * 2)]);
		
		//Comportamiento.
		when(mockMSVResolucionDao.mergeAndGet(idResolucion)).thenReturn(msvResolucion);
		when(mockGenericDao.createFilter(any(FilterType.class), any(String.class), any(String.class))).thenReturn(mockFilter);
		when(mockGenericDao.get(MSVDDEstadoProceso.class, mockFilter)).thenReturn(msvDDEstadoProceso);
		
		//idResolucion Nulo
		try{
			msvResolucionManager.procesaResolucion(null);
			fail("No se lanz� la excepci�n.");
		}
		
		catch(BusinessOperationException ex){
			//Excepci�n controlada.
		}
		
		
		//Ejecuci�n normal.
		//Inicializaci�n ej. normal
		TipoProcedimiento tipoProcedimiento = new TipoProcedimiento();
		tipoProcedimiento.setCodigo("CODIGO_PROCEDIMIENTO");
		
		MEJProcedimiento prc = new MEJProcedimiento();
		Long idProcedimiento = r.nextLong();
		
		Asunto asunto = new Asunto();
		asunto.setId(r.nextLong());
		
		prc.setId(idProcedimiento);
		prc.setTipoProcedimiento(tipoProcedimiento);
		prc.setAsunto(asunto);
		
		MSVDDTipoResolucion tipoResolucion = new MSVDDTipoResolucion();
		tipoResolucion.setId(idResolucion);
		tipoResolucion.setCodigo("CODIGO_RESOLUCION");
		
		MSVResolucionApi mockResolucionApi = mock(MSVResolucionApi.class);
		when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockResolucionApi);	
		
		MSVResolucion resolucion = new MSVResolucion();
		resolucion.setTipoResolucion(tipoResolucion);
		resolucion.setProcedimiento(prc);
		
		when(mockMSVResolucionDao.mergeAndGet(any(Long.class))).thenReturn(resolucion);
		
		when(mockResolucionApi.getTipoResolucion(anyLong())).thenReturn(tipoResolucion);
		
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		when(mockProcedimientoApi.getProcedimiento(idProcedimiento)).thenReturn(prc);
		
		MSVResolucionInputApi mockResolucionInputApi = mock(MSVResolucionInputApi.class);
		
		String strTipoInput = "TIPO_INPUT";

		Map<String, String> campos = new HashMap<String, String>();
		campos.put("importeMayor","MENOR");
		campos.put("notificacion","TOTAL");
		campos.put("tieneProc","NO");
		campos.put("tramiteEmbargo","NINGUNO");

		when(mockProxyFactory.proxy(MSVResolucionInputApi.class)).thenReturn(mockResolucionInputApi);
		when(mockResolucionInputApi.obtenerTipoInputParaResolucion(idProcedimiento, tipoProcedimiento.getCodigo(), tipoResolucion.getCodigo(), campos)).thenReturn(strTipoInput);
		
		
		RecoveryBPMfwkDDTipoInput tipoInput = new RecoveryBPMfwkDDTipoInput();
		tipoInput.setCodigo("CODIGO_TIPO_INPUT");
		when(mockGenericDao.get(RecoveryBPMfwkDDTipoInput.class, mockGenericDao.createFilter(any(FilterType.class), any(String.class), any(String.class)))).thenReturn(tipoInput);
		
		RecoveryBPMfwkInputApi mockRecoveryBPMfwlInputApi = mock(RecoveryBPMfwkInputApi.class);
		when(mockProxyFactory.proxy(RecoveryBPMfwkInputApi.class)).thenReturn(mockRecoveryBPMfwlInputApi);
		RecoveryBPMfwkInput myInput = new RecoveryBPMfwkInput();
		myInput.setId(r.nextLong());
		myInput.setIdProcedimiento(idProcedimiento);
		myInput.setTipo(tipoInput);
		
		when(mockRecoveryBPMfwlInputApi.saveInput(any(RecoveryBPMfwkInputDto.class))).thenReturn(myInput);
		
		RecoveryBPMfwkCfgInputDto config = new RecoveryBPMfwkCfgInputDto();
	    when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockBPMConfigApi);
	    when(mockBPMConfigApi.getInputConfigNodo(tipoInput.getCodigo(), tipoProcedimiento.getCodigo(), MSVResolucionInputApi.MSV_NODO_SIN_TAREAS)).thenReturn(config);
	    
	    
		MSVResolucion result = msvResolucionManager.procesaResolucion(idResolucion);
		
		assertNotNull(result);
		assertTrue("El resultado no es correcto.", (result.getEstadoResolucion().getCodigo().equals(MSVDDEstadoProceso.CODIGO_ERROR) || 
				result.getEstadoResolucion().getCodigo().equals(MSVDDEstadoProceso.CODIGO_PROCESADO)));
		
	    
	    
		//Con tarea
		EXTTareaExterna tarea = new EXTTareaExterna();
		tarea.setId(r.nextLong());
		resolucion.setTarea(tarea);
		
				
	    RecoveryBPMfwkRunApi mockRecoveryBPMfwkRunApi = mock(RecoveryBPMfwkRunApi.class);
	    when(mockProxyFactory.proxy(RecoveryBPMfwkRunApi.class)).thenReturn(mockRecoveryBPMfwkRunApi);
	    when(mockRecoveryBPMfwkRunApi.procesaInput(any(RecoveryBPMfwkInputDto.class))).thenReturn(myInput.getId());
		
		
	    RecoveryBPMfwkInputsTareasApi mockRecoveryBPMfwkInputsTareasApi = mock(RecoveryBPMfwkInputsTareasApi.class);
	    when(mockProxyFactory.proxy(RecoveryBPMfwkInputsTareasApi.class)).thenReturn(mockRecoveryBPMfwkInputsTareasApi);
		
		
		MSVResolucion result2 = msvResolucionManager.procesaResolucion(idResolucion);
		
		
		verify(mockRecoveryBPMfwkInputsTareasApi, times(1)).save(myInput.getId(), resolucion.getTarea().getId());
			
		
		assertNotNull(result2);
		assertTrue("El resultado no es correcto.", (result2.getEstadoResolucion().getCodigo().equals(MSVDDEstadoProceso.CODIGO_ERROR) || 
				result2.getEstadoResolucion().getCodigo().equals(MSVDDEstadoProceso.CODIGO_PROCESADO)));
	}
	
	
	
	
	
	
	

	/**
	 * Queremos probar que el m�todo uploadFile funciona correctamente
	 * - Si recibe idResolucion nulo, ejecuta un alta
	 * - Recibe un fichero y lo guarda en la BD
	 * - Devuelve el id de la Resoluci�n creada
	 * 
	 * @throws Exception
	 */
	@Ignore
	public void testUploadFileAlta() throws Exception {
		
		Long idResolucion = r.nextLong();
		MSVDtoFileItem dto = new MSVDtoFileItem();
		

		
		ExcelFileBean uploadForm=new ExcelFileBean();
		FileItem fileItem = new FileItem();
		String nombreFichero=MSVUtilTest.getRutaFichero(FICHERO_RESOL_PRUEBA);
		fileItem.setFile(new File(nombreFichero));
		fileItem.setFileName(nombreFichero);
		uploadForm.setFileItem(fileItem);
		
		MSVDtoResultadoSubidaFicheroMasivo resultado;
		MSVResolucion resolucionEsperada = new MSVResolucion();
		resolucionEsperada.setNombreFichero(nombreFichero);
		resolucionEsperada.setContenidoFichero(fileItem);
		resolucionEsperada.setId(idResolucion);
		
		//Cuando se lance el alta, devolver un Dto con el id de resolución esperado
		//ArgumentCaptor<File> argFichero = ArgumentCaptor.forClass(File.class);
		ArgumentCaptor<MSVResolucion> argResolucion = ArgumentCaptor.forClass(MSVResolucion.class);
		//ArgumentCaptor<Class> argClase = ArgumentCaptor.forClass(Class.class);
		
		when(mockMSVResolucionDao.get(any(Long.class))).thenReturn(resolucionEsperada);
		doReturn(resolucionEsperada).when(mockMSVResolucionDao).saveOrUpdate(any(MSVResolucion.class));
		resultado=msvResolucionManager.uploadFile(uploadForm, dto);
		
		assertNotNull("Id. resoluci�n en la respuesta debe ser no nulo", resultado.getIdProceso());
		assertEquals("Nombres de fichero diferentes (resultado)", nombreFichero, resultado.getNombreFichero());
		
		//Comprobar que save se ha invocado una vez
		verify(mockMSVResolucionDao, times(1)).saveOrUpdate( argResolucion.capture());
		
		//Comprobar que se ha creado
		MSVResolucion resol=new MSVResolucion();
		resol.setId(idResolucion);
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "id", resultado.getIdProceso());
		when(mockGenericDao.get(MSVResolucion.class, filtro)).thenReturn(resol);
		
		assertEquals(resultado.getIdProceso(), resol.getId());
		
	}
	
	/**
	 * Queremos probar que el m�todo uploadFile funciona correctamente
	 * - Si recibe idResolucion no nulo, ejecuta una modificacion
	 * - Recibe un fichero y lo guarda en la BD
	 * - Devuelve el id de la Resoluci�n creada
	 * 
	 * @throws Exception
	 */
	@Test
	public void testUploadFileModificacion() throws BusinessOperationException {
		
		//Inicializaci�n
		Long idResolucion = r.nextLong();
		MSVDtoFileItem dto = new MSVDtoFileItem();

		dto.setIdResolucion(idResolucion);
		dto.setIdAsunto(r.nextLong());
		
		ExcelFileBean uploadForm=new ExcelFileBean();
		FileItem fileItem = new FileItem();
		String nombreFichero=MSVUtilTest.getRutaFichero(FICHERO_RESOL_PRUEBA);
		fileItem.setFile(new File(nombreFichero));
		fileItem.setFileName(nombreFichero);
		uploadForm.setFileItem(fileItem);
		
		MSVDtoResultadoSubidaFicheroMasivo resultado;
		MSVResolucion resolucionEsperada = new MSVResolucion();
		resolucionEsperada.setId(idResolucion);
		resolucionEsperada.setNombreFichero(nombreFichero);
		resolucionEsperada.setContenidoFichero(fileItem);
		
		//Comportamiento
		when(mockMSVResolucionDao.get(idResolucion)).thenReturn(resolucionEsperada);
		
		//Ejecuci�n
		resultado = msvResolucionManager.uploadFile(uploadForm, dto);
		
		//Validaciones.
		assertEquals("Nombres de fichero diferentes", nombreFichero, resolucionEsperada.getNombreFichero());
		assertEquals("Id. resoluci�n diferentes", idResolucion, resolucionEsperada.getId());
		assertEquals("Ficheros diferentes", fileItem, resolucionEsperada.getContenidoFichero());
		
		assertEquals("Id. resoluci�n diferentes (resultado)", idResolucion, resultado.getIdProceso());
		assertEquals("Nombres de fichero diferentes (resultado)", nombreFichero, resultado.getNombreFichero());
		
		verify(mockMSVResolucionDao, times(1)).get(idResolucion);
		verify(mockMSVResolucionDao, times(1)).saveOrUpdate(resolucionEsperada);
		
	}

	/**
	 * Queremos probar que con un fichero inexistente devuelve la excepci�n esperada
	 * 
	 * @throws Exception
	 */
	@Test(expected=Exception.class)
	public void testUploadFileExcepcion() throws Exception {
		
		Long idResolucion=1L;
		MSVDtoFileItem dto=new MSVDtoFileItem();
		dto.setIdProceso(idResolucion);
		
		ExcelFileBean uploadForm=new ExcelFileBean();
		FileItem fileItem = new FileItem();
		String nombreFichero=MSVUtilTest.getRutaFichero(FICHERO_RESOL_INEXISTENTE);
		fileItem.setFile(new File(nombreFichero));
		fileItem.setFileName(nombreFichero);
		uploadForm.setFileItem(fileItem);
		
		msvResolucionManager.uploadFile(uploadForm, dto);
		
	}
	
	/**
	 * Probamos si se recupera correctamente el tipo de resolucion a partir
	 * a partir del c�digo
	 */
	@Test
	public void testGetTipoResolucionPorCodigo() {
		
		String codigo = "CODIGO_RESOL";
		String nombreResol = "NOMBRE_RESOL";
		MSVDDTipoResolucion tipoResol=new MSVDDTipoResolucion();
		tipoResol.setCodigo(codigo);
		tipoResol.setDescripcion(nombreResol);
		Filter filtro=mockGenericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		when(mockGenericDao.get(MSVDDTipoResolucion.class, filtro)).thenReturn(tipoResol);
		
		MSVDDTipoResolucion tipoResol2 = msvResolucionManager.getTipoResolucionPorCodigo(codigo);
		
		assertEquals("Codigo recuperado de manera incorrecta", codigo, tipoResol2.getCodigo());
		assertEquals("Descripci�n recuperado de manera incorrecta", nombreResol, tipoResol2.getDescripcion());

	}
	
}
