package es.capgemini.pfs.test.ingreso;

import static junit.framework.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.test.context.ContextConfiguration;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.ingreso.IngresoManager;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.test.AbstractCommonTest;

/**
 * @author Mariano Ruiz
 */
@ContextConfiguration
public class IngresosTest extends AbstractCommonTest {

    @javax.annotation.Resource
    private Resource cargarDatosScript;

    @Autowired
    private IngresoManager ingresoManager;

    @Autowired
    private PersonaManager personaManager;

    /**
     * Cargamos datos para el test.
     */
    @Before
    public void onSetUp() {
        enableHibernateLazyMode();
        cleanDDBB();
        cargarDatosComunes();
        executeScript(cargarDatosScript);
    }

    /**
     * Borramos los datos creados para el test.
     */
    @After
    public void after() {
        cleanDDBB();
    }

    /**
     * Verifica la lectura de los tipos de ingreso.
     */
    @Test
    public void testLeerTipos() {
        DDTipoIngreso tipoIngreso = ingresoManager.getTipoIngreso(1L);
        assertEquals("Ninguno", tipoIngreso.getDescripcion());
        assertTrue(!tipoIngreso.getAuditoria().isBorrado());
    }

    /**
     * Verifica lectura y escritura de los ingresos.
     */
    @Test
    public void testIngresos() {
        final Long ing80001 = 80001L;
        final Long per900 = 900L;
        final Long per901 = 901L;
        Ingreso ingreso = ingresoManager.getIngreso(ing80001);
        // Chequeo lectura
        assertEquals(ingreso.getPersona().getId(), per900);

        // Chequeo escritura
        Persona persona = personaManager.get(per901);
        Ingreso ingresoNuevo = new Ingreso();
        ingresoNuevo.setIngNetoBruto(Float.valueOf("3000"));
        ingresoNuevo.setPeriodicidad(1L);
        ingresoNuevo.setTipoIngreso(ingresoManager.getTipoIngreso(1L));
        ingresoNuevo.setPersona(persona);
        ingresoNuevo.setAuditoria(Auditoria.getNewInstance());

        // Agrego ingreso a la persona y persisto
        persona.getIngresos().add(ingresoNuevo);
        ingresoManager.saveIngreso(ingresoNuevo);
        //personaManager.saveOrUpdate(persona);

        // Compruebo..
        ingreso = personaManager.get(per901).getIngresos().get(0);
        assertEquals(ingreso.getIngNetoBruto(), Float.valueOf("3000"));

        // Borro..
        ingresoManager.deleteIngreso(ingreso.getId());
        assertTrue(personaManager.get(per901).getIngresos().get(0).getAuditoria().isBorrado());
    }
}
