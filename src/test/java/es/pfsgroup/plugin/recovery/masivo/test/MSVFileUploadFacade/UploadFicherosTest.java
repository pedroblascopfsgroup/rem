package es.pfsgroup.plugin.recovery.masivo.test.MSVFileUploadFacade;

import java.util.Random;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.MSVFileUploadFacade;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVFileManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;
import es.pfsgroup.plugin.recovery.masivo.test.MSVFileUploadFacade.matchers.MSVDtoFileItemArgumentMatcher;
import es.pfsgroup.plugin.recovery.masivo.test.MSVFileUploadFacade.matchers.UploadFormArgumentMatcher;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class UploadFicherosTest extends SampleBaseTestCase {
	
	@InjectMocks 
	private MSVFileUploadFacade procesoManager;
	
	@Mock
	private ExcelManagerApi excelManager;
	
	@Mock
	private ApiProxyFactory mockProxyFactory;
	
	@Mock
	private WebFileItem webFileItem;
	
	@Mock
	private MSVResolucionApi mockResolucionManager;
	
	@Mock
	private MSVFileManagerApi mockMSVFileManagerApi;

	private Random r = new Random();
	
	
	@Before
	public void before(){
		when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(excelManager);
		when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockResolucionManager);
	}
	
	public void after(){
		reset(excelManager);
		reset(mockProxyFactory);
		reset(webFileItem);
		reset(mockResolucionManager);
	}
	
	
	@Test
	public void guardarFicheroSubidoTest(){
		/*
		 * Objetos que se reciben en la petici�n
		 */
		FileItem fileItem = new FileItem();
		Long idProceso = r.nextLong();
		Long idTipoOperacion = r.nextLong();
		
		when(webFileItem.getFileItem()).thenReturn(fileItem);
		when(webFileItem.getParameter("idProceso")).thenReturn(idProceso.toString());
		when(webFileItem.getParameter("idTipoOperacion")).thenReturn(idTipoOperacion.toString());
		
		/*
		 * Hacemos la llamda
		 */
		procesoManager.subirFicheroParaProcesar(webFileItem);
		
		/*
		 * Comprobamos que se hace la llamada para guardar el fichero que hemos subido
		 */
		try {
			verify(excelManager).uploadFile(argThat(new UploadFormArgumentMatcher(fileItem)), argThat(new MSVDtoFileItemArgumentMatcher(idTipoOperacion, idProceso)));
		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}
	}
	
	@Test
	public void subirFicheroResolucionesTest(){
		/*
		 * Objetos que se reciben en la petici�n
		 */		
		FileItem fileItem = new FileItem();
		Long idResolucion = r.nextLong();
		Long idTipoJuicio = r.nextLong();
		Long idTipoResolucion = r.nextLong();
		Double principal = r.nextDouble();
		Long idAsunto = r.nextLong();
		Long idTarea = r.nextLong();
		
		MSVDtoResultadoSubidaFicheroMasivo dto = new MSVDtoResultadoSubidaFicheroMasivo();
		dto.setIdProceso(idResolucion);
		try {
			
			when(webFileItem.getFileItem()).thenReturn(fileItem);
			when(webFileItem.getParameter("idResolucion")).thenReturn(idResolucion.toString());
			when(webFileItem.getParameter("idTipoJuicio")).thenReturn(idTipoJuicio.toString());
			when(webFileItem.getParameter("idTipoResolucion")).thenReturn(idTipoResolucion.toString());
			when(webFileItem.getParameter("principal")).thenReturn(principal.toString());			
			when(webFileItem.getParameter("idAsunto")).thenReturn(idAsunto.toString());
			when(webFileItem.getParameter("idTarea")).thenReturn(idTarea.toString());
			when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockResolucionManager);

			when(mockResolucionManager.uploadFile(any(ExcelFileBean.class),any(MSVDtoFileItem.class))).thenReturn(dto);
			
			
			String result = procesoManager.subirFicheroResoluciones(webFileItem);
			
			/*
			 * Comprobamos que se hace la llamada para guardar el fichero que hemos subido
			 */
		
			verify(mockResolucionManager).uploadFile(argThat(new UploadFormArgumentMatcher(fileItem)), argThat(new MSVDtoFileItemArgumentMatcher(null, null)));
			assertNotNull(result);
			assertEquals(String.valueOf(idResolucion), result);
			//assertEquals(idProceso, result);
		} catch (Exception e) {
			e.printStackTrace();
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}
		
	}
	
	/**
	 * Test del m�todo {@link MSVFileUploadFacade#subirFichero(WebFileItem)}
	 */
	@Ignore
	@Test
	public void testSubirFichero(){
		
		Long idFichero = r.nextLong();
		MSVDtoResultadoSubidaFicheroMasivo mockMSVDtoResultadoSubidaFicheroMasivo = mock(MSVDtoResultadoSubidaFicheroMasivo.class);
		
		when(mockProxyFactory.proxy(MSVFileManagerApi.class)).thenReturn(mockMSVFileManagerApi);
//		when(mockMSVFileManagerApi.uploadFile(any(FileItem.class))).thenReturn(mockMSVDtoResultadoSubidaFicheroMasivo);
		when(mockMSVDtoResultadoSubidaFicheroMasivo.getIdFichero()).thenReturn(idFichero);
		
		String result = procesoManager.subirFichero(webFileItem);
		
		assertNotNull(result);
		assertEquals(String.valueOf(idFichero), result);
	}
	
	/**
	 * Test del m�todo {@link MSVFileUploadFacade#subirFichero(WebFileItem)} 
	 * con par�metros de entrada nulos.
	 */
	@Test(expected=BusinessOperationException.class)
	public void testSubirFicheroNulo(){
		
		procesoManager.subirFichero(null);
		fail("No se ha lanzado la excepci�n.");
	}

}
