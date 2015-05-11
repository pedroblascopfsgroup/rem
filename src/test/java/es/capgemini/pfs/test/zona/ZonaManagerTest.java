package es.capgemini.pfs.test.zona;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.zona.ZonaManager;

public class ZonaManagerTest extends CommonTestAbstract {

    @Autowired
    ZonaManager zonaManager;

    @Test
    public final void testGetNiveles() {
        zonaManager.getNiveles();
    }

    @Test
    public final void testGetZonasPorNivel() {
        zonaManager.getZonasPorNivel(1L);
    }

    @Test
    public final void testGetZonasPorPerfil() {
        zonaManager.getZonasPorPerfil(1L);
    }

    @Test
    public final void testGetZonaPorCentro() {
        zonaManager.getZonaPorCentro("01");
    }

    @Test
    public final void testGetZonaPorCodigo() {
        zonaManager.getZonaPorCodigo("01");
    }

    @Test
    public final void testGetZonaPorDescripcion() {
        zonaManager.getZonaPorDescripcion("Zona 1");
    }

    @Test
    public final void testGetNivel() {
        zonaManager.getNivel(1L);
    }

    @Test
    public final void testGetNivelById() {
        zonaManager.getNivelById("1");
    }

    @Test
    public final void testGetNivelByIdOrEmptyObj() {
        zonaManager.getNivelByIdOrEmptyObj("01");
    }

    @Test
    public final void testBuscarZonasPorPerfil() {
        zonaManager.buscarZonasPorPerfil(1L);
    }

}
