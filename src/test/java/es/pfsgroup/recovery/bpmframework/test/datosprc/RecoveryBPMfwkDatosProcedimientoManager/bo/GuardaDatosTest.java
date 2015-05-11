package es.pfsgroup.recovery.bpmframework.test.datosprc.RecoveryBPMfwkDatosProcedimientoManager.bo;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkConfiguracionError;
import es.pfsgroup.recovery.bpmframework.test.datosprc.RecoveryBPMfwkDatosProcedimientoManager.AbstractRecoveryBPMfwkDatosProcedimientoManagerTests;

@RunWith(MockitoJUnitRunner.class)
public class GuardaDatosTest extends AbstractRecoveryBPMfwkDatosProcedimientoManagerTests {

	private DatosEntradaInput entradaInput; 
	private Map<String, Object> datosInput;
	private Long idProcedimiento;
	private RecoveryBPMfwkCfgInputDto config;

	@Override
	public void childBefore() {

		entradaInput = new DatosEntradaInput(random);
		datosInput = new HashMap<String, Object>();
		idProcedimiento = random.nextLong();
		config = new RecoveryBPMfwkCfgInputDto();
		//Procedimiento prc = new Procedimiento();
		
		simular().getProcedimiento(idProcedimiento);
		simular().guardaDatos();
		
		
	}

	@Override
	public void childAfter() {

		entradaInput = null;
		datosInput = null;
		idProcedimiento = null;
		config = null;

	}
	
    @Test
    public void testCasoGeneral() throws RecoveryBPMfwkConfiguracionError {
    	
		datosInput = entradaInput.getDatosInput();
		//idProcedimiento = random.nextLong();
		config = getRecoveryBPMfwkCfgInputDto(datosInput);

		manager.guardaDatos(idProcedimiento, datosInput, config);
    	
    	verificar().seHanGuardadoLosDatos(datosInput.size());
    }


	/**
     * Test con datos nulos. Debe lanzar {@link RecoveryBPMfwkConfiguracionError}
     * @throws RecoveryBPMfwkConfiguracionError
     */
    @Test
    public void testDatosNulos(){

    	datosInput = null;
    	idProcedimiento = null;
    	config = null;
    	
    	try {
			manager.guardaDatos(idProcedimiento, datosInput, config);
			fail("No se ha lanzado la excepción.");
		} catch (RecoveryBPMfwkConfiguracionError e) {
			//e.printStackTrace();
		}
    	verificar().noSeHanGuardadoLosDatos();
    }	

    /**
     * Test sin datos de configuración ni datos de input
     * @throws RecoveryBPMfwkConfiguracionError
     */
    @Test
    public void testDatosVacios() throws RecoveryBPMfwkConfiguracionError {
    	
    	manager.guardaDatos(idProcedimiento, datosInput, config);
    	
    	verificar().noSeHanGuardadoLosDatos();

    }
    
    /**
     * Test con idProcedimiento Null. debe lanzar {@link RecoveryBPMfwkConfiguracionError}
     */
    @Test
    public void testIdProcedimientoNull() {
    	
		idProcedimiento = null;
		config = getRecoveryBPMfwkCfgInputDto(datosInput);

		try {
			manager.guardaDatos(idProcedimiento, datosInput, config);
			fail("No se ha lanzado la excepción.");
		} catch (RecoveryBPMfwkConfiguracionError e) {
			//e.printStackTrace();
		}

    	verificar().noSeHanGuardadoLosDatos();
    }  
    
    /**
     * Test no existe el procedimiento. debe lanzar {@link RecoveryBPMfwkConfiguracionError}
     */
    @Test
    public void testProcedimientoNull() {
    	
		idProcedimiento = random.nextLong();
		config = getRecoveryBPMfwkCfgInputDto(datosInput);
		
		simular().getProcedimientoNull(idProcedimiento);

		try {
			manager.guardaDatos(idProcedimiento, datosInput, config);
			fail("No se ha lanzado la excepción.");
		} catch (RecoveryBPMfwkConfiguracionError e) {
			//e.printStackTrace();
		}

    	verificar().noSeHanGuardadoLosDatos();
    }  
    
    @Test
    public void testMapasDistintoSize() {
    	
		datosInput = entradaInput.getDatosInput();
		//idProcedimiento = random.nextLong();
		config = getRecoveryBPMfwkCfgInputDto(datosInput);
		datosInput.put(RandomStringUtils.randomAlphanumeric(10), RandomStringUtils.randomAlphanumeric(10));

		try {
			manager.guardaDatos(idProcedimiento, datosInput, config);
			fail("No se ha lanzado la excepción.");
		} catch (RecoveryBPMfwkConfiguracionError e) {
			//e.printStackTrace();
		}
    	
		verificar().noSeHanGuardadoLosDatos();
    }
    
    @Test
    public void testClavesDistintas() {
    	
		datosInput = entradaInput.getDatosInput();
		
		String randomKey = RandomStringUtils.randomAlphanumeric(10);
		datosInput.put(randomKey, RandomStringUtils.randomAlphanumeric(10));

		config = getRecoveryBPMfwkCfgInputDto(datosInput);
		
		datosInput.remove(randomKey);
		datosInput.put(RandomStringUtils.randomAlphanumeric(10), RandomStringUtils.randomAlphanumeric(10));

		try {
			manager.guardaDatos(idProcedimiento, datosInput, config);
			fail("No se ha lanzado la excepción.");
		} catch (RecoveryBPMfwkConfiguracionError e) {
			//e.printStackTrace();
		}
    	
		verificar().noSeHanGuardadoLosDatos();
    }    
    
    private RecoveryBPMfwkCfgInputDto getRecoveryBPMfwkCfgInputDto(Map<String, Object> datosInput) {
    	
    	RecoveryBPMfwkCfgInputDto dtoCfg = new RecoveryBPMfwkCfgInputDto();
    	RecoveryBPMfwkGrupoDatoDto dtoGrupo = null;
    	Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos = new HashMap<String, RecoveryBPMfwkGrupoDatoDto>();
    	
		for(Map.Entry<String, Object> entry : datosInput.entrySet()){
			dtoGrupo = new RecoveryBPMfwkGrupoDatoDto();
			dtoGrupo.setNombreInput(entry.getKey());
			dtoGrupo.setDato(entry.getKey() + "_" + RandomStringUtils.randomAlphanumeric(5));
			dtoGrupo.setGrupo(RandomStringUtils.randomAlphanumeric(5));
			configDatos.put(dtoGrupo.getGrupo(), dtoGrupo);

		}    	
    	
    	dtoCfg.setConfigDatos(configDatos);
		return dtoCfg;
	}

}
