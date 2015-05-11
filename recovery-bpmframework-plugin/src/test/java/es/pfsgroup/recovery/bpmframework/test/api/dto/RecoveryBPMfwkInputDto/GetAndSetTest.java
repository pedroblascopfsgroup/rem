package es.pfsgroup.recovery.bpmframework.test.api.dto.RecoveryBPMfwkInputDto;


import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

/**
 * Esta clase comprueba que el funcionamiento de los getters y setters sea el esperado
 * @author bruno
 *
 */
public class GetAndSetTest {
	
	private static final String KEY_DATO_1 = "keyDato1";
	private static final String KEY_DATO_2 = "keyDato 2";
	private static final String KEY_DATO_3 = "#!@%key";

	// Clase bajo test
	private RecoveryBPMfwkInputDto dto;
	
	// Variables del test
	private Long idProcedimiento;

	private String codigoTipoInput;

	private FileItem adjunto;

	private String fileNameAdjunto;

	private Map<String, Object> datos;
	
	private String dato1String;
	private Long dato2Long;
	private Boolean dato3Boolean;
	
	@Before
	public void before(){
		dto = new RecoveryBPMfwkInputDto();
		
		Random r = new Random();
		idProcedimiento = r.nextLong();
		codigoTipoInput = "Codigo-" + r.nextLong();
		fileNameAdjunto = "Adjunto-" + r.nextLong();
		adjunto = new FileItem();
		adjunto.setFileName(fileNameAdjunto);
		
		dato1String = "Dato !#·~½¬&/()-" + r.nextLong(); 
		dato2Long = r.nextLong();
		dato3Boolean = r.nextBoolean();
		
		datos = new HashMap<String, Object>();
		datos.put(KEY_DATO_1, dato1String);
		datos.put(KEY_DATO_2, dato2Long);
		datos.put(KEY_DATO_3, dato3Boolean);
	}
	
	@After
	public void after(){
		dto = null;
		idProcedimiento = null;
		codigoTipoInput = null;
		adjunto = null;
		fileNameAdjunto = null;
		datos = null;
		dato1String = null;
		dato2Long = null;
		dato3Boolean = null;
	}
	
	/**
	 * Prueba todos los métodos de tipo get y set para el caso general en el que se le pasa algún valor
	 */
	@Test
	public void allGettersTest(){
		
		dto.setIdProcedimiento(idProcedimiento);
		dto.setCodigoTipoInput(codigoTipoInput);
		dto.setAdjunto(adjunto);
		dto.setDatos(datos);
		
		assertEquals("No coincide el idProcedimiento", idProcedimiento, dto.getIdProcedimiento());
		assertEquals("No coincide el código del tipo de Input", codigoTipoInput, dto.getCodigoTipoInput());
		
		assertEquals("El objeto adjunto no es el mismo", adjunto, dto.getAdjunto());
		assertEquals("El filename del adjunto no coincide", fileNameAdjunto, dto.getAdjunto().getFileName());
		
		assertEquals("El mapa de datos no es el mismo", datos, dto.getDatos());
		assertEquals("El dato 1 no coincide", dato1String, dto.getDatos().get(KEY_DATO_1));
		assertEquals("El dato 2 no coincide", dato2Long, dto.getDatos().get(KEY_DATO_2));
		assertEquals("El dato 3 no coincide", dato3Boolean, dto.getDatos().get(KEY_DATO_3));
		
	}

}
