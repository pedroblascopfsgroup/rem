package es.pfsgroup.recovery.bpmframework.test.api.config.RecoveryBPMfwkCfgInputDto;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;

/**
 * Conjunto de pruebas para comprobar que los getters and setters del DTO se
 * comportan como deben cuando el estado del DTO consta de nulls (o valores por defecto).
 * 
 * @author bruno
 * 
 */
public class NullDefaultValuesTest {

    private RecoveryBPMfwkCfgInputDto dto;


    @Before
    public void before() {

        dto = new RecoveryBPMfwkCfgInputDto();
    }


    @After
    public void after() {
        dto = null;

    }
    
    /**
     * Comprueba los métodos get que devuelven lo que se ha seteado en el before()
     */
    @Test
    public void testSetters(){
        assertNull("El código de tipo de acción no coincide",dto.getCodigoTipoAccion());
        assertNull("El código de tipo de input no coincide", dto.getCodigoTipoInput());
        assertNull("El código de tipo de procedimiento no coincide", dto.getCodigoTipoProcedimiento());
        assertTrue("La configuración de los datos no coincide", Checks.estaVacio(dto.getConfigDatos()));
        assertFalse("El flag defaultNodesIncluded no coincide", dto.isDefaultNodesIncluded());
        assertTrue("La lista de nodos incluidos no coincide", dto.getNodesIncluded().length == 0);
        assertTrue("La lista de nodos excluidos no coincide", dto.getNodesExcluded().length == 0);
    }
    
   

}
