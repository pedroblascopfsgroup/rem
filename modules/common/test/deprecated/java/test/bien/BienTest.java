package es.capgemini.pfs.test.bien;

import static junit.framework.Assert.assertEquals;

import java.util.Date;

import javax.mail.MessagingException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.test.context.ContextConfiguration;

import es.capgemini.pfs.bien.BienManager;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.test.AbstractCommonTest;

/**
 * Tests relacionados con el objeto Bien.
 */
@ContextConfiguration
public class BienTest extends AbstractCommonTest {

    private static final Long BIEN_ID_333 = 333L;

    @javax.annotation.Resource
    private Resource cargarBien;

    @Autowired
    private BienManager bienManager;

    /**
     * Enable set up.
     */
    @Before
    public void before() {
        enableHibernateLazyMode();
        cleanDDBB();
        cargarDatosComunes();

    }

    /**
     * Clean up.
     */
    @After
    public void after() {
        cleanDDBB();
    }

    /**
     * Prueba para validar que se verifique un bien.
     * @throws MessagingException e
     */
    @Test
    public void verificarBien() throws MessagingException {
        executeScript(cargarBien);
        clearHibernateSession();
        bienManager.verificarBien(BIEN_ID_333);
        Bien bien = bienManager.get(BIEN_ID_333);

        assertEquals("Fecha de verificación incorrecta", DF.format(new Date()), DF.format(bien.getFechaVerificacion()));
    }
}
