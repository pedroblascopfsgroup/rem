package es.pfsgroup.plugin.recovery.iplus.test;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.iplus.GestionIplusFacade;

@RunWith(MockitoJUnitRunner.class)
public class GestionIplusFacadeTest {

	@InjectMocks GestionIplusFacade facade;
	
	@Test
	public void testNormalizar() {
			    
	    String original = "2012-03-26-IM PROCÉDASE A AVERIGUAR TELE.PDF";
	    String resultadoEsperado = "2012-03-26-IM PROCEDASE A AVERIGUAR TELE.PDF";
	    
	    String resultado = facade.normalizar(original);
	    
	    assertEquals("El resultado no es el esperado", resultadoEsperado, resultado);

	}

	@Test
	public void testNormalizar2() {
		
		String original = "áàäéèëíìïóòöúùüñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ";
	    String resultadoEsperado =    "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC";
	    
	    String resultado = facade.normalizarOld(original);
	    
	    assertEquals("El resultado no es el esperado", resultadoEsperado, resultado);

	}

	@Test
	public void testNormalizar3() {
		
		char[] chars = new char[13];
//		Á 		\u00C1
		chars[0] =  '\u00C1';
//		á 		\u00E1
		chars[1] =  '\u00E1';
//		É 		\u00C9
		chars[2] =  '\u00C9';
//		é 		\u00E9
		chars[3] =  '\u00E9';
//		Í 		\u00CD
		chars[4] =  '\u00CD';
//		í 		\u00ED
		chars[5] =  '\u00ED';
//		Ó 		\u00D3
		chars[6] =  '\u00D3';
//		ó 		\u00F3
		chars[7] = '\u00F3';
//		Ú 		\u00DA
		chars[8] = '\u00DA';
//		ú 		\u00FA
		chars[9] = '\u00FA';
//		Ü 		\u00DC
		chars[10] = '\u00DC';
//		ü 		\u00FC
		chars[11] = '\u00FC';
//		ñ 		\u00F1
		chars[12] = '\u00F1';

		String original = new String (chars);
		String resultadoEsperado =    "AaEeIiOoUuUun";
	    
	    String resultado = facade.normalizar(original);
	    
	    assertEquals("El resultado no es el esperado", resultadoEsperado, resultado);

	}

}
