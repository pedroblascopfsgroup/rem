package es.capgemini.pfs.test.analisis;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertTrue;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.mapaGlobalOficina.dao.MapaGlobalOficinaDao;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoBuscarMapaGlobalOficina;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoExportRow;
import es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis;
import es.capgemini.pfs.mapaGlobalOficina.model.MapaGlobalOficina;
import es.capgemini.pfs.subfase.model.DDFase;
import es.capgemini.pfs.subfase.model.Subfase;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.zona.model.Nivel;

/**
 * Tests para todo lo referente con MapaGlobalOficina.
 */
public class MapaGlobalOficinaTest extends CommonTestAbstract {

    @Autowired
    private MapaGlobalOficinaDao mapaGlobalOficinaDao;

    private DtoBuscarMapaGlobalOficina dto;

    /**
     * Borra la BBDD y carga datos.
     */
    @Before
    public void before() {
        enableHibernateLazyMode();
        clearHibernateSession();

        // Los análisis siempre se hacen sobre una fecha en particular
        dto = new DtoBuscarMapaGlobalOficina();
        dto.setFecha("08/11/2008");
    }

    /**
     * Borra la BBDD.
     */
    @After
    public void after() {
        //executeScript(destroyDatosScript);
    }

    /**
     * Buscar por la fecha actual.
     * @throws Exception e
     */
    @Test
    public void buscarPorFecha() throws Exception {
        // La fecha ya la seteo before()
        List<MapaGlobalOficina> datos = mapaGlobalOficinaDao.buscar(dto);
        assertNotNull(datos);
        final int size = 87;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar por la fase normal.
     * @throws Exception e
     */
    @Test
    public void buscarPorFase() throws Exception {
        dto.setCodigoFase(DDFase.FASE_NORMAL);

        List<MapaGlobalOficina> datos = mapaGlobalOficinaDao.buscar(dto);
        assertNotNull(datos);
        final int size = 59;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar por la subfase 'NV'.
     * @throws Exception e
     */
    @Test
    public void buscarPorSubfase() throws Exception {
        Set<String> subfases = new HashSet<String>();
        subfases.add(Subfase.SUBFASE_NV);
        dto.setCodigoSubfases(subfases);

        List<MapaGlobalOficina> datos = mapaGlobalOficinaDao.buscar(dto);
        assertNotNull(datos);
        final int size = 53;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar por segmento 'Cliente A'.
     * @throws Exception e
     */
    @Test
    public void buscarPorSegmento() throws Exception {
        Set<String> segmentos = new HashSet<String>();
        // Segmentos presentes en el set de datos
        final String segEmpleados = "1";
        final String segGeneral = "3";
        // Segmento NO presente en el set de datos
        final String segConsejeros = "2";
        segmentos.add(segEmpleados);
        segmentos.add(segConsejeros);
        segmentos.add(segGeneral);
        dto.setCodigoSegmentos(segmentos);

        List<MapaGlobalOficina> datos = mapaGlobalOficinaDao.buscar(dto);
        List<DtoExportRow> datosAgrupados = mapaGlobalOficinaDao.buscarAgrupandoPorSegmento(dto);
        assertNotNull(datosAgrupados);
        final int sizeAgrupados = 2;
        assertEquals(sizeAgrupados, datosAgrupados.size());

        assertNotNull(datos);
        final int size = 67;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar por producto 'Hipoteca Exp' (10102).
     * @throws Exception e
     */
    @Test
    public void buscarPorProducto() throws Exception {
        Set<String> productos = new HashSet<String>();
        final String creditoPersonal = "P13";
        final String cuentaCorriente = "P17";
        productos.add(creditoPersonal);
        productos.add(cuentaCorriente);
        dto.setTiposContratos(productos);

        List<MapaGlobalOficina> datos = mapaGlobalOficinaDao.buscar(dto);
        assertNotNull(datos);
        final int size = 17;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar agrupando por productos.
     * @throws Exception e
     */
    @Test
    public void buscarAgrupandoProducto() throws Exception {
        List<DtoExportRow> datos = mapaGlobalOficinaDao.buscarAgrupandoPorProducto(dto);
        assertNotNull(datos);
        final int size = 20;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar agrupando por segmento.
     * @throws Exception e
     */
    @Test
    public void buscarAgrupandoSegmento() throws Exception {
        List<DtoExportRow> datos = mapaGlobalOficinaDao.buscarAgrupandoPorSegmento(dto);
        assertNotNull(datos);
        final int size = 3;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar agrupando por zona.
     * @throws Exception e
     */
    @Test
    public void buscarAgrupandoZona() throws Exception {
        dto.setJerarquia(DDCriterioAnalisis.CRITERIO_SALIDA_JERARQUICO);
        dto.setCriterioSalidaJerarquico(Nivel.NIVEL_ZONA.toString());
        List<DtoExportRow> datos = mapaGlobalOficinaDao.buscarAgrupandoPorJerarquia(dto);
        assertNotNull(datos);
        final int size = 1;
        assertEquals(size, datos.size());
    }

    /**
     * Buscar agrupando por subfases.
     * @throws Exception e
     */
    @Test
    public void buscarAgrupandoSubfase() throws Exception {
        dto.setCodigoFase(DDFase.FASE_PRIMARIA);
        Set<String> codigosSubfases = new HashSet<String>();
        // Fase con resultados
        codigosSubfases.add(Subfase.SUBFASE_GV30_60);
        // Fase sin datos cargados
        codigosSubfases.add(Subfase.SUBFASE_CE);
        codigosSubfases.add(Subfase.SUBFASE_GV15_30);
        dto.setCodigoSubfases(codigosSubfases);
        List<DtoExportRow> datos = mapaGlobalOficinaDao.buscarAgrupandoPorSubfases(dto);
        assertNotNull(datos);
        // Se filtra con 3 fases - la que no tiene datos = 1
        final int size = 1;
        assertEquals(size, datos.size());
    }

    /**
     * Verifica que los montos de los resultados estén bien.
     * @throws Exception e
     */
    @Test
    public void verificarMontos() throws Exception {
        List<DtoExportRow> datos = mapaGlobalOficinaDao.buscarAgrupandoPorProducto(dto);
        assertNotNull(datos);
        assertTrue("Producto incorrecto", datos.get(4).getDescripcion().equals("Credito personal"));
        assertTrue("Cant. de clientes incorrecto", datos.get(4).getNumeroClientes() == 25L);
        assertTrue("Cant. de contratos incorrecto", datos.get(4).getNumeroContratos() == 25L);
        assertTrue("Pos. vencida incorrecta", datos.get(4).getSaldoVencido() == 3031148.36);
        assertTrue("Pos. total incorrecta", datos.get(4).getSaldoTotal() == 3033736.11);
    }
}
