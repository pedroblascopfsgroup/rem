package es.pfsgroup.recovery.bpmframework.test.api.config.RecoveryBPMfwkCfgInputDto;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;

/**
 * Conjunto de pruebas para comprobar que los getters and setters del DTO se
 * comportan como deben.
 * 
 * @author bruno
 * 
 */
public class GetsAndSetsTest {

    private RecoveryBPMfwkCfgInputDto dto;

    private String codigoTipoAccion;

    private String codigoTipoInput;

    private String codigoTipoProcedimiento;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    private boolean defaultNodesIncluded;

    private String[] nodesIncluded;

    private String[] nodesExcluded;

    @Before
    public void before() {
        Random random = new Random();

        dto = new RecoveryBPMfwkCfgInputDto();

        codigoTipoAccion = "tatattatat" + random.nextLong();
        codigoTipoInput = "tititittiti" + random.nextLong();
        codigoTipoProcedimiento = "prrororororo" + random.nextLong();
        configDatos = creaMapaDatos(random.nextInt(10000));
        defaultNodesIncluded = random.nextBoolean();
        nodesIncluded = creaArray(random.nextInt(1000));
        nodesExcluded = creaArray(random.nextInt(1000));

        dto.setCodigoTipoAccion(codigoTipoAccion);
        dto.setCodigoTipoInput(codigoTipoInput);
        dto.setCodigoTipoProcedimiento(codigoTipoProcedimiento);
        dto.setConfigDatos(configDatos);
        dto.setDefaultNodesIncluded(defaultNodesIncluded);
        dto.setNodesExcluded(nodesExcluded);
        dto.setNodesIncluded(nodesIncluded);
    }


    @After
    public void after() {
        dto = null;

        codigoTipoAccion = null;
        codigoTipoInput = null;
        codigoTipoProcedimiento = null;
        configDatos = null;
        defaultNodesIncluded = !defaultNodesIncluded;
        nodesIncluded = null;
        nodesExcluded = null;
    }
    
    /**
     * Comprueba los métodos get que devuelven lo que se ha seteado en el before()
     */
    @Test
    public void testSetters(){
        assertEquals("El código de tipo de acción no coincide", codigoTipoAccion, dto.getCodigoTipoAccion());
        assertEquals("El código de tipo de input no coincide", codigoTipoInput, dto.getCodigoTipoInput());
        assertEquals("El código de tipo de procedimiento no coincide", codigoTipoProcedimiento, dto.getCodigoTipoProcedimiento());
        assertEquals("La configuración de los datos no coincide", configDatos, dto.getConfigDatos());
        assertEquals("El flag defaultNodesIncluded no coincide", defaultNodesIncluded, dto.isDefaultNodesIncluded());
        assertArrayEquals("La lista de nodos incluidos no coincide", nodesIncluded, dto.getNodesIncluded());
        assertArrayEquals("La lista de nodos excluidos no coincide", nodesExcluded, dto.getNodesExcluded());
    }
    
    /**
     * Crea un mapa de datos con contenido aleatorio
     * @param numItems
     * @return
     */
    private Map<String, RecoveryBPMfwkGrupoDatoDto> creaMapaDatos(int numItems) {
        final HashMap<String, RecoveryBPMfwkGrupoDatoDto> mapa = new HashMap<String, RecoveryBPMfwkGrupoDatoDto>();
        RecoveryBPMfwkGrupoDatoDto valor;
        for (int i = 0; i < Math.abs(numItems); i++){
            valor = new RecoveryBPMfwkGrupoDatoDto();
            String nombreInput = "nombreInput"+ i;
            valor.setNombreInput(nombreInput);
            valor.setGrupo("grupo" + i);
            valor.setDato("dato" + i);
            mapa.put(nombreInput, valor);
        }
        return mapa;
    }
    
    /**
     * Crea un array de Strings aleatorio
     * @param totalItems
     * @return
     */
    private String[] creaArray(int totalItems) {
       final ArrayList<String> lista = new ArrayList<String>();
       
       for (int i=0; i< Math.abs(totalItems); i++){
           lista.add("item" + i);
       }
       
       return lista.toArray(new String[]{});
    }

}
