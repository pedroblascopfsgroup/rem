package es.capgemini.pfs.test.notificaciones;

import java.util.Date;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.EstadoAsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.dao.DDEstadoExpedienteDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.dao.DDEstadoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.test.AbstractCommonTest;

/**
 * @author Pablo Müller
 */
public class NotificacionManagerTest extends AbstractCommonTest {

    @Autowired
    private TareaNotificacionManager notificacionManager;
    @Autowired
    private DDEstadoExpedienteDao ddEstadoExpedienteDao;
    @Autowired
    private DDEstadoItinerarioDao ddEstadoItinerarioDao;
    @Autowired
    private GestorDespachoDao gestorDespachoDao;
    @Autowired
    private ExpedienteManager expedienteManager;

    @Autowired
    private ArquetipoManager arquetipoManager;

    @Autowired
    private AsuntoDao asuntoDao;

    @Autowired
    private OficinaDao oficinaDao;

    @Autowired
    private EstadoAsuntoDao estadoAsuntoDao;
    private final Long plazo = 10000L;

    private static final Long ARQ_DEFAULT = 9999L;

    /**
     * before.
     */
    @Before
    public void onSetUp() {
        enableHibernateLazyMode();
        cleanDDBB();
        cargarDatosComunes();
        clearHibernateSession();
    }

    /**
     * after.
     */
    @After
    public void after() {
        cleanDDBB();
        clearHibernateSession();
    }

    /* -------------- EXPEDIENTES ------------------ */

    /**
     * Prueba la inserción de una notificación.
     * @throws Exception Exception si hay errror.
     */
    @Test
    public void testCrearNotificacionExpediente() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setId(1L);

        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();//12344321L;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO;
        //GENERO LA NOTIFICACION
        notificacionManager.crearNotificacion(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea, null);
    }

    /**
     * prueba la creación de una tarea.
     * @throws Exception Exception si hay errror.
     */
    @Test
    public void testCrearTareaExpediente() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE;
        //GENERO LA NOTIFICACION
        notificacionManager.crearTarea(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea, false, false,
                plazo, null);
    }

    /**
     * prueba la creación de una tarea.
     * @throws Exception Exception si hay errror.
     */
    @Test
    public void testCrearTareaAlertaExpediente() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE;
        //GENERO LA NOTIFICACION
        notificacionManager.crearTarea(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea, false, true,
                plazo, null);
    }

    /**
     * prueba la creación de una tarea.
     * @throws Exception Exception si hay errror.
     */
    @Test
    public void testCrearTareaEnEsperaExpediente() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        exp.setVersion(1);
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE;
        //GENERO LA NOTIFICACION
        notificacionManager.crearTarea(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea, true, false,
                plazo , null);
    }

    /**
     * Prueba el borrado lógico de tareas.
     * @throws Exception si hay errror.
     */
    @Test
    public void testBorrarTareaExpediente() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setExpId(1L);
        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();//12344321L;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO;
        notificacionManager.crearNotificacion(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea, null);
        notificacionManager.borrarNotificacionTarea(exp.getId(), TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoSubtipoTarea);
    }

    /**
     * Prueba el borrado lógico de tareas.
     * @throws Exception si hay errror.
     */
    @Test
    public void testBorrarTareaPorId() throws Exception {
        //Inserto el expediente para buscar
        Expediente exp = new Expediente();
        exp.setEstadoExpediente(ddEstadoExpedienteDao.getByCodigo(DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO));
        exp.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE).get(0));
        exp.setFechaEstado(new Date());
        exp.setOficina(oficinaDao.get(new Long(1)));
        exp.setArquetipo(arquetipoManager.get(ARQ_DEFAULT));
        expedienteManager.saveExpediente(exp);
        Long idEntidadInformacion = exp.getId();//12344321L;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO;
        Long idNotif = notificacionManager.crearNotificacion(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                codigoSubtipoTarea, null);
        notificacionManager.borrarNotificacionTarea(idNotif);
    }

    /**
     * Prueba la inserción de una notificación.
     * @throws Exception Exception si hay errror.
     */
    @Test
    public void testCrearNotificacionAsunto() throws Exception {
        //Inserto el asunto para buscar
        Asunto asu = new Asunto();
        asu.setEstadoAsunto(estadoAsuntoDao.get(2L));
        asu.setFechaEstado(new Date());
        asu.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_ASUNTO).get(0));
        asu.setGestor(gestorDespachoDao.get(1L));
        asuntoDao.save(asu);
        Long idEntidadInformacion = asu.getId();
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO;
        //GENERO LA NOTIFICACION
        notificacionManager.crearNotificacion(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_ASUNTO, codigoSubtipoTarea, null);
    }

    /**
     * Prueba el borrado lógico de tareas.
     * @throws Exception si hay errror.
     */
    @Test
    public void testBorrarTareaPorIdAsunto() throws Exception {
        //Inserto el asunto para buscar
        Asunto asu = new Asunto();
        asu.setEstadoAsunto(estadoAsuntoDao.get(2L));
        asu.setFechaEstado(new Date());
        asu.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_ASUNTO).get(0));
        asu.setGestor(gestorDespachoDao.get(1L));
        asuntoDao.save(asu);
        Long idEntidadInformacion = asu.getId();
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO;
        Long idNotif = notificacionManager.crearNotificacion(idEntidadInformacion, TipoEntidad.CODIGO_ENTIDAD_ASUNTO, codigoSubtipoTarea,
                null);
        notificacionManager.borrarNotificacionTarea(idNotif);
    }
}
