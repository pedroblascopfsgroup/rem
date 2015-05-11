package es.pfsgroup.recovery.bpmframework.test.config.RecoveryBPMfwkConfigManager.bo;

import static org.junit.Assert.*;

import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.test.config.RecoveryBPMfwkConfigManager.AbstractRecoveryBPMfwkConfigManagerTests;

/**
 * Pruebas de la operación de negocio de obtener la configuración de un tipo de input
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetInputConfigTest extends AbstractRecoveryBPMfwkConfigManagerTests{
	
	private String codigoTipoInput;
	
	private String codigoTipoProcedimiento;
	
	private String nodoProcedimiento;
	
	private RecoveryBPMfwkTipoProcInput tipoProcInput;
	
	@Override
	public void childBefore() {

		codigoTipoInput = RandomStringUtils.randomAlphanumeric(10);
		
		codigoTipoProcedimiento = RandomStringUtils.randomAlphanumeric(10);
		
		nodoProcedimiento = RandomStringUtils.randomAlphanumeric(10);
		
		tipoProcInput = generaTipoProcInput(codigoTipoInput, codigoTipoProcedimiento);
		
		simular().getTipoProcInput(codigoTipoInput, codigoTipoProcedimiento, tipoProcInput);
		
	}
	
	@Override
	public void childAfter() {
		
		codigoTipoInput = null;
		
		codigoTipoProcedimiento = null;
		
	}
	
    /**
     * Prueba el caso general de guardado de un input
     * @throws RecoveryBPMfwkError 
     */
    @Test
    public void testCasoGeneral() throws RecoveryBPMfwkError {
    	
    	RecoveryBPMfwkCfgInputDto result = manager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento);
    	
    	verificar().seHaRecuperadoElInputConfig();
    	
    	// Comprobamos que el dto contiene los mismos valores que el objeto recuperado de la base de datos.
    	assertNotNull("result no puede ser nulo", result);
    	assertEquals("El campo codigoTipoInput no coincide", codigoTipoInput, result.getCodigoTipoInput());
    	assertEquals("El campo codigoTipoProcedimiento no coincide", codigoTipoProcedimiento, result.getCodigoTipoProcedimiento());
    	assertTrue("El campo defaultNodesIncluded no es true", result.isDefaultNodesIncluded());
    	assertEquals("El campo codigoTipoAccion no coincide", tipoProcInput.getTipoAccion().getCodigo(), result.getCodigoTipoAccion());
    	assertEquals("El campo NodesExcluded no coincide", tipoProcInput.getNodesExcludedAsArray().length, result.getNodesExcluded().length);
    	assertEquals("El campo NodesIncluded no coincide", tipoProcInput.getNodesIncludedAsArray().length, result.getNodesIncluded().length);
    	assertEquals("El campo NodesExcluded no coincide", RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED, result.getNodesExcluded()[0]);
    	assertEquals("El campo NodesIncluded no coincide", RecoveryBPMfwkTipoProcInput.ALL_INCLUDED, result.getNodesIncluded()[0]);
    	assertEquals("El campo nombreTransicion no coincide", tipoProcInput.getNombreTransicion(), result.getNombreTransicion());
    	assertEquals("El campo codigoPlantilla no coincide", tipoProcInput.getPlantilla().getCodigo(), result.getCodigoPlantilla());
    	assertEquals("El tamaño del mapa no coincide", tipoProcInput.getInputDatosAsCfgInputDtoMap().size(), result.getConfigDatos().size());
    	for(Map.Entry<String,RecoveryBPMfwkGrupoDatoDto> entry : tipoProcInput.getInputDatosAsCfgInputDtoMap().entrySet()){
    		assertNotNull("No coincide la clave " + entry.getKey(), result.getConfigDatos().get(entry.getKey()));
    		assertEquals("No coincide el valor de la clave " + entry.getKey(), entry.getValue().getDato(), result.getConfigDatos().get(entry.getKey()).getDato());
    		assertEquals("No coincide el valor de la clave " + entry.getKey(), entry.getValue().getGrupo(), result.getConfigDatos().get(entry.getKey()).getGrupo());
    		assertEquals("No coincide el valor de la clave " + entry.getKey(), entry.getValue().getNombreInput(), result.getConfigDatos().get(entry.getKey()).getNombreInput());
    	}
    }
    
    /**
     * Prueba el caso en el que no existe configuración.
     * @throws RecoveryBPMfwkError 
     */
    @Test(expected=RecoveryBPMfwkError.class)
    public void testNoEncuentraConfiguracion() throws RecoveryBPMfwkError {
    	
    	//Cambiamos la simulación para comprobar que devuelve null si no encuentra configuración.
    	simular().getTipoProcInput(codigoTipoInput, codigoTipoProcedimiento, null);
    	
    	RecoveryBPMfwkCfgInputDto result = manager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento);
    	
    	verificar().seHaRecuperadoElInputConfig();
    	
    	assertNull("result debe ser nulo", result);
    	
    }
    
    /**
     * Comprobamos que no falle si algún parámetro de la configuración es nulo.
     * Comprobamos qué pasa cuando existen nodos.
     * @throws RecoveryBPMfwkError 
     */
    @Test
    public void testTodoNull() throws RecoveryBPMfwkError {
    	
    	//Cambiamos la simulación para inyectar todos los campos a null.
    	tipoProcInput = new RecoveryBPMfwkTipoProcInput();

		simular().getTipoProcInput(codigoTipoInput, codigoTipoProcedimiento, tipoProcInput);
		
    	RecoveryBPMfwkCfgInputDto result = manager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento);

		// Comprobamos que el dto contiene los mismos valores que el objeto recuperado de la base de datos.
    	assertNotNull("result no puede ser nulo", result);
    	
    }


}
