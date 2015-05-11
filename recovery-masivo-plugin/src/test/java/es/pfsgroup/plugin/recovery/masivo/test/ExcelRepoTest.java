package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert. assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.any;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.ExcelRepoManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVDiccionarioManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;



/**
 * Tests unitarios de la clase ExcelRepo
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class ExcelRepoTest extends SampleBaseTestCase{
	
	private static final Long TIPO_PLANTILLA = 1L;
	private static final String RUTA_BASE = "/utils/testFiles/plantillas/";
	private static final String RUTA_EXCEL = "Plantilla_1.xls";

	//Definimos la clase sobre la que vamos a realizar los tests mediante la anotaci�n @InjectMocks
	@InjectMocks ExcelRepoManager excelRepo;
	@Mock FileItem mockFileItem;
	@Mock ApiProxyFactory mockProxyFactory;
	@Mock MSVDiccionarioManager mockMSVDiccionarioManager;
	@Mock Properties mockMasivoProperties;
	@Mock ServletContext mockServletContext;
    /**
     * Comprobamos que existe el m�todo dameExcel(tipoPlantilla)
     * @throws FileNotFoundException 
     */
    @Test    
    public void testDameExcelVacia() throws FileNotFoundException{
    	
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockMSVDiccionarioManager);
    	when(mockMSVDiccionarioManager.obtenerRutaExcel(TIPO_PLANTILLA)).thenReturn(RUTA_EXCEL);
    	when(mockMasivoProperties.getProperty(ExcelRepoManager.RUTA_EXCEL_PROPERTY)).thenReturn(RUTA_BASE);
    	when(mockServletContext.getRealPath(any(String.class))).thenReturn(new File(".").getAbsolutePath() + RUTA_BASE + RUTA_EXCEL);
    	FileItem result = excelRepo.dameExcel(TIPO_PLANTILLA);
    	assertTrue(result instanceof FileItem);
    	
    }

}
