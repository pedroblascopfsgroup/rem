package es.capgemini.pfs.test.persona;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Test para probar el correcto funcionamiento del la calse PersonaManager 
 * 
 * @author lgiavedo
 */
public class PersonaTest extends CommonTestAbstract {

    @Autowired
    private PersonaManager personaManager;

    private final Long DEFAULT_PERSONA_ID = 1L;

    /**
     * Test PersonaManager.getList
     */
    @Test
    public void testGetList() {
        // Obtenemos la lista de personas
        List<Persona> plist = personaManager.getList();
        //Confirmamos que no sea nula
        assertNotNull(plist);
        //Confirmamos que contenga datos
        assertTrue(plist.size() > 0);
    }

    /**
     * Test PersonaManager.get
     */
    @Test
    public void testGet() {
        // Obtenemos la persona por su id
        Persona per = personaManager.get(DEFAULT_PERSONA_ID);
        // Confirmamos que no sea nula
        assertNotNull(per);
        //Confirmamos la condicion de su ID
        assertEquals(per.getId().longValue(), DEFAULT_PERSONA_ID.longValue());
    }

}
