package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.Random;

import org.junit.After;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVFileManager;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVFileItem;

@RunWith(MockitoJUnitRunner.class)
public class MSVFileManagerTest {
	
	@InjectMocks MSVFileManager msvFileManager;
	
	@Mock
	private GenericABMDao mockGenericDao;

	private Random r = new Random();
	
	@After
	public void after(){
		
	}
	
	/**
	 * Test del método {@link MSVFileManager#uploadFile(FileItem)}
	 */
	@SuppressWarnings("unchecked")
	@Test
	public void testUploadFile(){
		
		Long idFichero = r.nextLong();
		FileItem fileItem = new FileItem();
		WebFileItem uploadform = new WebFileItem();
		uploadform.setFileItem(fileItem);
		
		MSVFileItem mockMSVFileItem = mock(MSVFileItem.class);
		when(mockMSVFileItem.getId()).thenReturn(idFichero);
		when(mockMSVFileItem.getFileItem()).thenReturn(fileItem);
		
		when(mockGenericDao.save(any(Class.class), any(MSVFileItem.class))).thenReturn(mockMSVFileItem);
		
		MSVDtoResultadoSubidaFicheroMasivo result = msvFileManager.uploadFile(uploadform);
		
		assertNotNull("Resultado no puede ser nulo.", result);
		assertNotNull("Id de fichero no puede ser nulo.", result.getIdFichero());
		assertEquals("El id de fichero no puede ser nulo.", idFichero, result.getIdFichero());
		
		verify(mockGenericDao, times(1)).save(any(Class.class), any(MSVFileItem.class));
	}
	
	/**
	 * Test del método {@link MSVFileManager#uploadFile(FileItem)} con parámetros de entrada nulos.
	 */
	@Test(expected=BusinessOperationException.class)
	@Ignore
	// diana: ignorado de momento para no perder tiempo con esto
	public void testUploadFileNulo(){
		
		msvFileManager.uploadFile(null);
	}
	
	@Test
	public void testGetFile(){
		
		Long idFichero = r.nextLong();
		
		Filter mockFilter = mock(Filter.class);
		MSVFileItem mockMSVFileItem = mock(MSVFileItem.class);
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idFichero)).thenReturn(mockFilter);
		when(mockGenericDao.get(MSVFileItem.class, mockFilter)).thenReturn(mockMSVFileItem);
		when(mockMSVFileItem.getId()).thenReturn(idFichero);
		
		MSVFileItem msvFileItem = msvFileManager.getFile(idFichero);
		
		assertNotNull("El object devuelto no puede ser nulo", msvFileItem);
		assertEquals("El id del fichero no coincide con el esperado.", idFichero, msvFileItem.getId());
	}
	
	/**
	 * Test del método {@link MSVFileManager#getFile} con parámetros de entrada nulos.
	 */
	@Test
	public void testGetFileNulo(){
		
		MSVFileItem msvFileItem = msvFileManager.getFile(null);
		
		assertNull("El object devuelto debe ser nulo", msvFileItem);
	}
}
