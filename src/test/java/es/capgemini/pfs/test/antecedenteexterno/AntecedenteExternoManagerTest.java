package es.capgemini.pfs.test.antecedenteexterno;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.antecedenteexterno.AntecedenteExternoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class AntecedenteExternoManagerTest extends CommonTestAbstract {

    @Autowired
    AntecedenteExternoManager antecedenteExternoManager;

    @Test
    public final void testGet() {
        antecedenteExternoManager.get(1L);
    }

    @Test
    public final void testGetList() {
        antecedenteExternoManager.getList();
    }

    @Test
    public final void testGetAntecedenteExternoPersona() {
        antecedenteExternoManager.getAntecedenteExternoPersona(1L);
    }

}
