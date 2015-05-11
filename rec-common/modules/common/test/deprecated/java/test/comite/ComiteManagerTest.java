package es.capgemini.pfs.test.comite;

import static junit.framework.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.test.context.ContextConfiguration;

import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.ComiteManager;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.dao.DecisionComiteDao;
import es.capgemini.pfs.comite.dto.DtoSesionComite;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.test.AbstractCommonTest;

/**
 * @author Andrés Esteban
 */
@ContextConfiguration
public class ComiteManagerTest extends AbstractCommonTest {

    private static final Long COM_1 = new Long("1");
    private static final Long ASU_601 = new Long("601");
    private static final Long EXP_500 = new Long("500");

    @javax.annotation.Resource
    private Resource cargarComite;

    @Autowired
    private ComiteManager comiteManager;
    @Autowired
    private DecisionComiteDao decisionComiteDao;
    @Autowired
    private ExpedienteDao expedienteDao;
    @Autowired
    private ComiteDao comiteDao;
    @Autowired
    private AsuntoDao asuntoDao;
    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;

    /**
     * Enable set up.
     */
    @Before
    public void before() {
        enableHibernateLazyMode();
        cleanDDBB();
        cargarDatosComunes();
        executeScript(cargarComite);
        clearHibernateSession();
    }

    /**
     * Clean up.
     */
    @After
    public void after() {
        cleanDDBB();
    }

    /**
     * Testea que se cree un sesión para el comite 900.
     * <br>Verfica los estados antes y despues.
     * @throws Exception e
     */
    @Test
    public void crearSesion() throws Exception {
        Comite comite = comiteDao.get(COM_1);
        // Verifico que no tenga sesiones
        assertEquals(Comite.NO_INICIADO, comite.getEstado());

        // Crea un sesion
        DtoSesionComite dto = comiteManager.getDto(COM_1);
        comiteManager.crearSesion(dto);
        comite = comiteDao.get(COM_1);
        assertEquals(1, comite.getSesiones().size());
        //Verifica estado iniciado
        assertEquals(Comite.INICIADO, comite.getEstado());
    }

    /**
     * Testea que se cierra un sesión para el comite 900.
     * <br>Verfica los estados antes y despues.
     * @throws Exception e
     */
    @Test
    public void cerrarSesion() throws Exception {
        Comite comite = comiteDao.get(COM_1);
        // Crea un sesion
        DtoSesionComite dto = comiteManager.getDto(COM_1);
        comiteManager.crearSesion(dto);
        comite = comiteDao.get(COM_1);

        crearDecision(comite.getUltimaSesion());
        // Cierra la sesion y verifica el estados
        comiteManager.cerrarSesion(comite.getId(), false);
        comite = comiteDao.get(COM_1);
        assertEquals(Comite.CERRADO, comite.getEstado());

        List<TareaNotificacion> notificaciones = tareaNotificacionDao.getList();
        assertEquals(1, notificaciones.size());
        validarNotificacion(notificaciones, asuntoDao.get(ASU_601));
    }

    private void crearDecision(SesionComite sesion) {
        DecisionComite decision = new DecisionComite();
        decision.setAuditoria(Auditoria.getNewInstance());
        decision.setSesion(sesion);
        decisionComiteDao.saveOrUpdate(decision);
        Expediente exp = expedienteDao.get(EXP_500);
        exp.setDecisionComite(decision);
        expedienteDao.saveOrUpdate(exp);
        flushHibernateSession();
    }

    /**
     * Valida si existe una notificación de cierre de sesión para el asunto indicado.
     * @param notificaciones list
     * @param expediente object
     * @param codigoSubtipoTarea string
     */
    private void validarNotificacion(List<TareaNotificacion> notificaciones, Asunto asunto) {
        for (TareaNotificacion notificacion : notificaciones) {
            if (asunto.getId().equals(notificacion.getAsunto().getId())) {
                if (SubtipoTarea.CODIGO_NOTIFICACION_CIERRA_SESION.equals(notificacion.getSubtipoTarea().getCodigoSubtarea())) {
                    assertTrue(true);
                    return;
                }
            }
        }
        fail("No se encontró la notificación para el asunto " + asunto.getId());
    }

}
