package es.capgemini.pfs.test.politica;

import org.junit.Before;
import org.junit.Test;
import org.springframework.core.io.Resource;

import es.capgemini.pfs.test.CommonTestAbstract;

/**
 * Prueba las funciones del manager de objetivos.
 * @author aesteban
 * TODO: Falta rehacer este jUnit entero ya que cambió la estructura
 */
public class ObjetivoManagerTest extends CommonTestAbstract {

    @javax.annotation.Resource
    private Resource borrarPoliticas;

    @javax.annotation.Resource
    private Resource cargarPoliticas;

    /**
     * Test unitario.
     */
    @Test
    public void borrarObjetivoTest() {
        /*
        Objetivo obj;
        objetivoManager.borrarObjetivo(objHistorico);
        obj = objetivoDao.get(objHistorico);
        assertFalse("No se puede borrar objetivos de politicas historicas", obj.getAuditoria().isBorrado());
        objetivoManager.borrarObjetivo(objPropBorrable);
        obj = objetivoDao.get(objPropBorrable);
        assertTrue(obj.getAuditoria().isBorrado());
        assertEquals(DDEstadoObjetivo.ESTADO_BORRADO, obj.getEstadoObjetivo().getCodigo());
        */
    }

    /**
     * Test unitario.
     */
    @Test
    public void rechazarObjetivoTest() {
        /*
        Objetivo obj;
        objetivoManager.borrarObjetivo(objPropRechazable);
        obj = objetivoDao.get(objPropRechazable);
        assertTrue(obj.getAuditoria().isBorrado());
        assertEquals(DDEstadoObjetivo.ESTADO_RECHAZADO, obj.getEstadoObjetivo().getCodigo());
        */
    }

    /**
     * Test unitario.
     */
    @Test
    public void proponerBorradoObjetivoTest() {
        /*
        Objetivo obj;
        objetivoManager.borrarObjetivo(objVigPend);
        obj = objetivoDao.get(objVigPend);
        assertEquals(DDEstadoObjetivo.ESTADO_CONFIRMADO, obj.getEstadoObjetivo().getCodigo());
        assertEquals(1, obj.getTareas().size());
        TareaNotificacion tarea = obj.getTareas().iterator().next();
        assertEquals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO, tarea.getSubtipoTarea().getCodigoSubtarea());
        */
    }

    /**
     * Carga personas, contratos, sus relaciones y alertas.
     */
    @Before
    public void limpiarBBDD() {
        executeScript(borrarPoliticas);
        executeScript(cargarPoliticas);
        clearHibernateSession();
        flushHibernateSession();
    }
}
