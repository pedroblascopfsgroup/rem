package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

/**
 * Tests unitarios de la clase ExcelParser
 * @author pedro
 *
 */
@SuppressWarnings("deprecation")
@RunWith(MockitoJUnitRunner.class)
public class MSVExcelParserTest extends SampleBaseTestCase{
	
	private static final String RUTA_PLANTILLA = "~/DatosQuery.xls";
	private static final String RUTA_PLANTILLA_VACIA = "";

	//Definimos la clase sobre la que vamos a realizar los tests mediante la anotación @InjectMocks
	@Mock MSVHojaExcel mockHojaExcel;
	
	private MSVExcelParser excelParser;
	
	@Before
	public void before(){
		excelParser = new MSVExcelParser();
	}
	
	@After
	public void after(){
		excelParser = null;
		reset(mockHojaExcel);
		
	}
	
    /**
     * Comprobamos que existe y funciona el método getExcel(ruta)
     */
	@Test
	public void getExcelTest() {
		
		MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);
		MSVHojaExcel hoja = excelParser.getExcel(RUTA_PLANTILLA);

		mockHojaExcel.setRuta(RUTA_PLANTILLA);
		
		verify(mockHojaExcel).setRuta(RUTA_PLANTILLA);
    	assertEquals(RUTA_PLANTILLA, hoja.getRuta());
		
	}

	@Test
    public void getExcelTestNormal(){
    	
    	when(mockHojaExcel.getRuta()).thenReturn(RUTA_PLANTILLA);
    	
    	String ruta = mockHojaExcel.getRuta();

    	verify(mockHojaExcel).getRuta();
    	assertEquals(ruta, RUTA_PLANTILLA);
    	
    }

    /**
     * Comprobamos que el método getExcel(ruta) devuelve IllegalArgumentException
     * cuando ruta es vacía
     */
    @Test(expected=IllegalArgumentException.class)
    public void getExcelTestVacio(){
    	
    	doThrow(IllegalArgumentException.class).when(mockHojaExcel).setRuta(RUTA_PLANTILLA_VACIA);
    	mockHojaExcel.setRuta(RUTA_PLANTILLA_VACIA);
    	
    }
}
