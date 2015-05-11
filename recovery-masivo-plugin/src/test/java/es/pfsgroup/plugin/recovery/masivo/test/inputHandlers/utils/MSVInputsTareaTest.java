package es.pfsgroup.plugin.recovery.masivo.test.inputHandlers.utils;

import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;

// movido al plugin de lindorffProcedimientos-bpm
@Ignore
@RunWith(MockitoJUnitRunner.class)
public class MSVInputsTareaTest extends SampleBaseTestCase {
	
	
//	@InjectMocks
//	MSVInputsTarea inputsTarea;
//	
//	@Mock
//	List<MSVConfiguradorInputs> mockLista;
//	
//	@Mock
//	MSVConfiguradorInputs mockConfigurador;
//	
//	
//	@SuppressWarnings("unchecked")
//	@After
//	public void after(){
//			reset(mockConfigurador);
//			reset(mockLista);
//	}
//	
//	/**
//	 * comprobamos que dado un listado de inputs para tareas nos 
//	 * devuelve el código del input a generar si le pasamos el código de la tarea
//	 * y una serie de validadores
//	 */
//	@Test
//	public void testObtenerCodigoInput(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setCodigoInput("AAAA");
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertEquals("No se está encontrando el input correcto", "AAAA", resultado);
//	}
//	
//	/**
//	 * comprobamos que dado un listado de inputs para tareas nos 
//	 * devuelve el código del input a generar si le pasamos el código de la tarea
//	 * y una serie de validadores
//	 */
//	@Test
//	public void testObtenerCodigoInputNoEncontrado(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(false);
//		input.setCodigoInput("AAAA");
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertEquals("No debería de encontrar un input para esta configuracion", null, resultado);
//	}
//	
//	
//	/**
//	 * comprobamos que dado un listado de inputs para tareas nos 
//	 * devuelve el código del input a generar si le pasamos el código de la tarea
//	 * y una serie de validadores
//	 */
//	@Test
//	public void testObtenerCodigoInputVariosInputs(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(false);
//		input.setCodigoInput("AAAA");
//		MSVConfiguradorInputs input2=new MSVConfiguradorInputs();
//		input2.setCodigoTarea("A");
//		input2.setCodigoInput("BBBB");
//		
//		when(mockLista.size()).thenReturn(2);
//		when(mockLista.get(0)).thenReturn(input);
//		when(mockLista.get(1)).thenReturn(input2);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertEquals("No se ha encontrado el input correcto", "BBBB", resultado);
//	}
//	
//	/**
//	 * comprobamos que dado un listado de inputs para tareas nos 
//	 * devuelve el código del input a generar si le pasamos el código de la tarea
//	 * y una serie de validadores
//	 */
//	@Test
//	public void testObtenerCodigoInputConProcurador(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		dto.setTieneProcurador(true);
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(true);
//		input.setCodigoInput("AAAA");
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertEquals("No se ha encontrado el input correcto", "AAAA", resultado);
//	}
//	
//	@Test
//	public void testObtenerCodigoInputConRestoValoresNoEncontrado(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		dto.setTieneProcurador(true);
//		dto.setAdmitido(true);
//		dto.setAveriguacionPositiva(true);
//		dto.setAveriguacionRepetida(false);
//		dto.setPagado(true);
//		dto.setRequerimientoPago(true);
//		dto.setSolicitadaCuenta(true);
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(true);
//		input.setCodigoInput("AAAA");
//		input.setPagado(false);
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertNull(resultado);
//	}
//	
//	@Test
//	public void testObtenerCodigoInputConRestoValoresEncontrado(){
//		MSVConfiguradorInputs dto= new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		dto.setTieneProcurador(true);
//		dto.setAdmitido(true);
//		dto.setAveriguacionPositiva(true);
//		dto.setAveriguacionRepetida(false);
//		dto.setPagado(true);
//		dto.setRequerimientoPago(true);
//		dto.setSolicitadaCuenta(true);
//		dto.setFinalizado(false);
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(true);
//		input.setCodigoInput("AAAA");
//		input.setPagado(true);
//		input.setRequerimientoPago(true);
//		input.setAveriguacionPositiva(true);
//		input.setAveriguacionRepetida(false);
//		input.setSolicitadaCuenta(true);
//		input.setRequerimientoPago(true);
//		input.setAdmitido(true);
//		input.setFinalizado(false);
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		String resultado=inputsTarea.obtenerCodigoInput(dto);
//			
//		assertEquals("No se ha encontrado el input correcto", "AAAA", resultado);
//	}
//	
//	
//	/**
//	 * comprobamos que dado un listado de inputs para tareas nos 
//	 * devuelve el código del input a generar si le pasamos el código de la tarea
//	 * y una serie de validadores
//	 */
//	@Test
//	public void testobtenerConfiguracionInputTarea(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setCodigoInput("AAAA");
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		MSVConfiguradorInputs resultado=inputsTarea.obtenerConfiguracionInputTarea(dto);
//			
//		assertEquals("No se está encontrando el input correcto", "AAAA", resultado.getCodigoInput());
//	}
//	
//	@Test
//	public void testObtenerInputConRestoValoresNoEncontrado(){
//		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		dto.setTieneProcurador(true);
//		dto.setAdmitido(true);
//		dto.setAveriguacionPositiva(true);
//		dto.setAveriguacionRepetida(false);
//		dto.setPagado(true);
//		dto.setRequerimientoPago(true);
//		dto.setSolicitadaCuenta(true);
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(true);
//		input.setCodigoInput("AAAA");
//		input.setPagado(false);
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		MSVConfiguradorInputs resultado=inputsTarea.obtenerConfiguracionInputTarea(dto);
//			
//		assertNull(resultado);
//	}
//	
//	@Test
//	public void testObtenerInputConRestoValoresEncontrado(){
//		MSVConfiguradorInputs dto= new MSVConfiguradorInputs();
//		dto.setCodigoTarea("A");
//		dto.setTieneProcurador(true);
//		dto.setAdmitido(true);
//		dto.setAveriguacionPositiva(true);
//		dto.setAveriguacionRepetida(false);
//		dto.setPagado(true);
//		dto.setRequerimientoPago(true);
//		dto.setSolicitadaCuenta(true);
//		dto.setFinalizado(false);
//		
//		MSVConfiguradorInputs input=new MSVConfiguradorInputs();
//		input.setCodigoTarea("A");
//		input.setTieneProcurador(true);
//		input.setCodigoInput("AAAA");
//		input.setPagado(true);
//		input.setRequerimientoPago(true);
//		input.setAveriguacionPositiva(true);
//		input.setAveriguacionRepetida(false);
//		input.setSolicitadaCuenta(true);
//		input.setRequerimientoPago(true);
//		input.setAdmitido(true);
//		input.setFinalizado(false);
//		
//		when(mockLista.size()).thenReturn(1);
//		when(mockLista.get(0)).thenReturn(input);
//		
//		MSVConfiguradorInputs resultado=inputsTarea.obtenerConfiguracionInputTarea(dto);
//			
//		assertEquals("No se ha encontrado el input correcto", "AAAA", resultado.getCodigoInput());
//	}
//	
//	/**
//	 * Test que comprueba que no haya errores cuando no se inyecta el listado de inputs.
//	 */
//	@Test
//	public void testListaInputsNulo(){
//		MSVConfiguradorInputs dto= new MSVConfiguradorInputs();
//		inputsTarea.setListaInputs(null);
//
//		MSVConfiguradorInputs resultado=inputsTarea.obtenerConfiguracionInputTarea(dto);
//		assertNull(resultado);
//	}
//
//	/**
//	 * Test que comprueba que no haya errores cuando no se inyecta el mapa de configuraciones.
//	 */
//	@Test
//	public void testMapaConfiguracionesNulo(){
//		inputsTarea.setMapaConfiguraciones(null);
//		String tipoProc = RandomStringUtils.random(15);
//		
//		List<MSVConfiguradorInputs> resultado = inputsTarea.getListaElementosPorTipoProcedimiento(tipoProc);
//		assertNull(resultado);
//	}
//	

}
