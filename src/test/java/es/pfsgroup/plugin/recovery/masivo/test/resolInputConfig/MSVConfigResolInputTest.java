package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;

public class MSVConfigResolInputTest {

	/**
	 * Prueba de comparación de objetos con null en todos los valores
	 */
	@Test
	public void testCompatibleTodosNull() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores típicos positivos
	 */
	@Test
	public void testCompatibleValoresTipicosPositivos() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		cri1.setCompleto(MSVConfigResolInput.TOTAL);
		cri1.setRespuesta(MSVConfigResolInput.APROBADA);
		cri1.setSentido(MSVConfigResolInput.POSITIVO);
		cri1.setTieneProcurador(MSVConfigResolInput.TRUE);
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto(MSVConfigResolInput.TOTAL);
		cri2.setRespuesta(MSVConfigResolInput.APROBADA);
		cri2.setSentido(MSVConfigResolInput.POSITIVO);
		cri2.setTieneProcurador(MSVConfigResolInput.TRUE);
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores típicos negativos
	 */
	@Test
	public void testCompatibleValoresTipicosNegativos() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		cri1.setCompleto(MSVConfigResolInput.PARCIAL);
		cri1.setRespuesta(MSVConfigResolInput.DENEGADA);
		cri1.setSentido(MSVConfigResolInput.NEGATIVO);
		cri1.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto(MSVConfigResolInput.PARCIAL);
		cri2.setRespuesta(MSVConfigResolInput.DENEGADA);
		cri2.setSentido(MSVConfigResolInput.NEGATIVO);
		cri2.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores equivalentes positivos
	 */
	@Test
	public void testCompatibleValoresEquivalentesPositivos() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		cri1.setCompleto(MSVConfigResolInput.TOTAL);
		cri1.setRespuesta(MSVConfigResolInput.APROBADA);
		cri1.setSentido(MSVConfigResolInput.POSITIVO);
		cri1.setTieneProcurador(MSVConfigResolInput.TRUE);
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto(MSVConfigResolInput.SI);
		cri2.setRespuesta(MSVConfigResolInput.TRUE);
		cri2.setSentido(MSVConfigResolInput.SI);
		cri2.setTieneProcurador(MSVConfigResolInput.TRUE);
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores equivalentes negativos
	 */
	@Test
	public void testCompatibleValoresEquivalentesNegativos() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		cri1.setCompleto(MSVConfigResolInput.PARCIAL);
		cri1.setRespuesta(MSVConfigResolInput.DENEGADA);
		cri1.setSentido(MSVConfigResolInput.NEGATIVO);
		cri1.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto(MSVConfigResolInput.NO);
		cri2.setRespuesta(MSVConfigResolInput.FALSE);
		cri2.setSentido(MSVConfigResolInput.NO);
		cri2.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores variados
	 * (incluyendo nulls)
	 */
	@Test
	public void testCompatibleValoresVariados() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		// no ponemos la propiedad completo (queda a null)
		// cri1.setCompleto(MSVConfigResolInput.TOTAL);
		cri1.setRespuesta(MSVConfigResolInput.APROBADA);
		cri1.setSentido(MSVConfigResolInput.POSITIVO);
		cri1.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto(MSVConfigResolInput.SI);
		cri2.setRespuesta(MSVConfigResolInput.TRUE);
		// no ponemos la propiedad sentido (queda a null)
		//cri2.setSentido(MSVConfigResolInput.SI);
		cri2.setTieneProcurador(MSVConfigResolInput.FALSE);
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}

	/**
	 * Prueba de comparación de objetos con valores reales
	 */
	@Test
	public void testCompatibleValoresReales() {
		
		MSVConfigResolInput cri1 = new MSVConfigResolInput();
		cri1.setCompleto("parcial");
		cri1.setRespuesta("denegada");
		cri1.setSentido("positivo");
		cri1.setTieneProcurador("SI");
		
		MSVConfigResolInput cri2 = new MSVConfigResolInput();
		cri2.setCompleto("parcial");
		cri2.setRespuesta("denegada");
		cri2.setSentido("positivo");
		cri2.setTieneProcurador("true");
		
		assertTrue("No son compatibles", cri1.compatible(cri2));
	}
}
