package es.pfsgroup.recovery.bpmframework.test.api.config.RecoveryBPMfwkGrupoDatoDto;

import static org.junit.Assert.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;

/**
 * Conjunto de pruebas para verificar que los gets y sets se comportan de forma
 * coherente
 * 
 * @author bruno
 * 
 */
public class GetsAndSetsTest {

    private RecoveryBPMfwkGrupoDatoDto dto;

    private String nombreInput;

    private String grupo;

    private String dato;

    @Before
    public void before() {
        Random random = new Random();
        nombreInput = "nnnn" + random.nextLong();
        grupo = "gggggg" + random.nextLong();
        dato = "ddddddd" + random.nextLong();

        dto = new RecoveryBPMfwkGrupoDatoDto();
        dto.setNombreInput(nombreInput);
        dto.setGrupo(grupo);
        dto.setDato(dato);
    }

    @After
    public void after() {
        dto = null;
        nombreInput = null;
        grupo = null;
        dato = null;
    }

    @Test
    public void testGetters() {
        assertEquals("El nombre del input no coincide", nombreInput, dto.getNombreInput());
        assertEquals("El nombre del grupo no coincide", grupo, dto.getGrupo());
        assertEquals("El nombre del dato no coinicde", dato, dto.getDato());
    }

}
