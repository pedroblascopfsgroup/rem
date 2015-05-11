package es.capgemini.pfs.test.politica;

import static org.junit.Assert.assertEquals;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;

import es.capgemini.pfs.politica.PoliticaManager;
import es.capgemini.pfs.politica.dao.DDTipoPoliticaDao;
import es.capgemini.pfs.politica.dto.DtoPolitica;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.politica.model.DDMotivo;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.dao.PerfilDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Prueba las funciones del manager de politicas.
 * @author aesteban
 *
 */
public class PoliticaManagerTest extends CommonTestAbstract {

    @Autowired
    private PoliticaManager politicaManager;

    @javax.annotation.Resource
    private Resource borrarPoliticas;

    @javax.annotation.Resource
    private Resource cargarPoliticas;

    @Autowired
    private DDTipoPoliticaDao ddTipoPoliticaDao;

    @Autowired
    private PerfilDao perfilDao;

    @Autowired
    private ZonaDao zonaDao;

    @Autowired
    private UsuarioManager usuarioManager;

    /**
     * Test unitario.
     */
    @Test
    public void buscarPoliticasParaPersonaTest() {
        executeScript(cargarPoliticas);
        clearHibernateSession();

        List<CicloMarcadoPolitica> cicloMarcado;
        cicloMarcado = politicaManager.buscarPoliticasParaPersona(1L);
        assertEquals(4, cicloMarcado.get(0).getPoliticas().size());
        Date hoy = new Date();
        assertEquals(DF.format(hoy), DF.format(cicloMarcado.get(0).getAuditoria().getFechaCrear()));
        GregorianCalendar ayer = new GregorianCalendar();
        ayer.add(Calendar.DAY_OF_MONTH, -1);
        assertEquals(DF.format(ayer.getTime()), DF.format(cicloMarcado.get(1).getAuditoria().getFechaCrear()));
        cicloMarcado = politicaManager.buscarPoliticasParaPersona(2L);
        assertEquals(3, cicloMarcado.get(0).getPoliticas().size());
    }

    /**
     * Test unitario.
     */
    @Test
    public void buscarObjetivosParaEstadoTest() {
        executeScript(cargarPoliticas);
        clearHibernateSession();

        /*
        List<Objetivo> estados;
        estados = politicaManager.buscarObjetivosParaEstado(1L);
        assertEquals(2, estados.size());
        estados = politicaManager.buscarObjetivosParaEstado(2L);
        assertEquals(2, estados.size());
        estados = politicaManager.buscarObjetivosParaEstado(11L);
        assertEquals(2, estados.size());
        estados = politicaManager.buscarObjetivosParaEstado(12L);
        assertEquals(2, estados.size());
        estados = politicaManager.buscarObjetivosParaEstado(102L);
        assertEquals(2, estados.size());
        */
    }

    /**
     * Test unitario.
     */
    @Test
    public void getDtoPoliticaTest() {
        executeScript(cargarPoliticas);
        clearHibernateSession();

        DtoPolitica dto;
        dto = politicaManager.getDtoPolitica(0L, 1L);
        assertEquals(DF.format(new Date()), DF.format(dto.getPolitica().getAuditoria().getFechaCrear()));
        assertEquals(DDEstadoPolitica.ESTADO_PROPUESTA, dto.getPolitica().getEstadoPolitica().getCodigo());
        assertEquals(DDMotivo.MOT_MANUAL, dto.getPolitica().getMotivo().getCodigo());

        dto = politicaManager.getDtoPolitica(1L, 1L);
        assertEquals(DF.format(new Date()), DF.format(dto.getPolitica().getAuditoria().getFechaCrear()));
        assertEquals(DDEstadoPolitica.ESTADO_PROPUESTA, dto.getPolitica().getEstadoPolitica().getCodigo());
        assertEquals(DDMotivo.MOT_PREPOLITICA, dto.getPolitica().getMotivo().getCodigo());

        GregorianCalendar ayer = new GregorianCalendar();
        ayer.add(Calendar.DAY_OF_MONTH, -1);
        dto = politicaManager.getDtoPolitica(2L, 1L);
        assertEquals(DF.format(ayer.getTime()), DF.format(dto.getPolitica().getAuditoria().getFechaCrear()));
        assertEquals(DDEstadoPolitica.ESTADO_VIGENTE, dto.getPolitica().getEstadoPolitica().getCodigo());
        assertEquals(DDMotivo.MOT_MANUAL, dto.getPolitica().getMotivo().getCodigo());

    }

    /**
     * Test unitario.
     */
    @Test
    public void crearPoliticaSuperusuarioTest() {
        DtoPolitica dto;
        Long per = 15L;
        dto = politicaManager.getDtoPolitica(0L, per);
        usuarioManager.setDefaultUserId(usuarioManager.findByUsername("admin").get(0).getId());

        DDTipoPolitica tipo = ddTipoPoliticaDao.getList().get(0);
        Perfil perfilGestor = perfilDao.getList().get(0);
        Perfil perfilSuper = perfilDao.getList().get(1);
        DDZona zonaGestor = zonaDao.buscarZonasPorPerfil(perfilGestor.getId()).get(0);
        DDZona zonaSuper = zonaDao.buscarZonasPorPerfil(perfilSuper.getId()).get(0);

        dto.setCodigoTipoPolitica(tipo.getCodigo());
        dto.setCodigoGestorPerfil(perfilGestor.getCodigo());
        dto.setCodigoSupervisorPerfil(perfilSuper.getCodigo());
        dto.setCodigoGestorZona(zonaGestor.getCodigo());
        dto.setCodigoSupervisorZona(zonaSuper.getCodigo());

        politicaManager.guardarPolitica(dto);

        /*
        List<Politica> politicas = politicaDao.buscarPoliticasParaPersona(per);
        assertEquals(1, politicas.size());
        Politica politica = politicas.get(0);
        validarPolitica(politica, tipo, perfilGestor, perfilSuper, zonaGestor, zonaSuper, DDMotivo.MOT_MANUAL, DDEstadoPolitica.ESTADO_PROPUESTA);
        EstadoItinerarioPolitica estado = politica.getEstadoItinerarionActual();
        assertEquals(DDEstadoItinerarioPolitica.ESTADO_VIGENTE, estado.getEstadoItinerarioPolitica().getCodigo());
        */
    }

    /**
     * Test unitario.
     */
    @Test
    public void crearPoliticaGestorTest() {
        DtoPolitica dto;
        Long per = 8L;
        dto = politicaManager.getDtoPolitica(0L, per);
        usuarioManager.setDefaultUserId(usuarioManager.findByUsername("gestor").get(0).getId());

        DDTipoPolitica tipo = ddTipoPoliticaDao.getList().get(0);
        Perfil perfilGestor = perfilDao.getList().get(0);
        Perfil perfilSuper = perfilDao.getList().get(1);
        DDZona zonaGestor = zonaDao.buscarZonasPorPerfil(perfilGestor.getId()).get(0);
        DDZona zonaSuper = zonaDao.buscarZonasPorPerfil(perfilSuper.getId()).get(0);

        dto.setCodigoTipoPolitica(tipo.getCodigo());
        dto.setCodigoGestorPerfil(perfilGestor.getCodigo());
        dto.setCodigoSupervisorPerfil(perfilSuper.getCodigo());
        dto.setCodigoGestorZona(zonaGestor.getCodigo());
        dto.setCodigoSupervisorZona(zonaSuper.getCodigo());

        politicaManager.guardarPolitica(dto);

        /*
        List<Politica> politicas = politicaDao.buscarPoliticasParaPersona(per);
        assertEquals(1, politicas.size());
        Politica politica = politicas.get(0);
        validarPolitica(politica, tipo, perfilGestor, perfilSuper, zonaGestor, zonaSuper, DDMotivo.MOT_MANUAL, DDEstadoPolitica.ESTADO_PROPUESTA);
        EstadoItinerarioPolitica estado = politica.getEstadoItinerarionActual();
        assertEquals(DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE, estado.getEstadoItinerarioPolitica().getCodigo());
        */
    }

    /**
     * Test unitario.
     */
    @Test
    public void modificarPoliticaGestorTest() {
        executeScript(cargarPoliticas);
        clearHibernateSession();
        DtoPolitica dto;
        Long per = 1L;
        dto = politicaManager.getDtoPolitica(1L, per);
        usuarioManager.setDefaultUserId(usuarioManager.findByUsername("gestor").get(0).getId());

        DDTipoPolitica tipo = ddTipoPoliticaDao.getList().get(2);
        Perfil perfilGestor = perfilDao.getList().get(1);
        Perfil perfilSuper = perfilDao.getList().get(2);
        DDZona zonaGestor = zonaDao.buscarZonasPorPerfil(perfilGestor.getId()).get(1);
        DDZona zonaSuper = zonaDao.buscarZonasPorPerfil(perfilSuper.getId()).get(1);

        dto.setCodigoTipoPolitica(tipo.getCodigo());
        dto.setCodigoGestorPerfil(perfilGestor.getCodigo());
        dto.setCodigoSupervisorPerfil(perfilSuper.getCodigo());
        dto.setCodigoGestorZona(zonaGestor.getCodigo());
        dto.setCodigoSupervisorZona(zonaSuper.getCodigo());

        politicaManager.guardarPolitica(dto);

        /*
        List<Politica> politicas = politicaDao.buscarPoliticasParaPersona(per);
        assertEquals(4, politicas.size());
        Politica politica = politicas.get(0);
        validarPolitica(politica, tipo, perfilGestor, perfilSuper, zonaGestor, zonaSuper, DDMotivo.MOT_PREPOLITICA, DDEstadoPolitica.ESTADO_PROPUESTA);
        EstadoItinerarioPolitica estado = politica.getEstadoItinerarionActual();
        assertEquals(DDEstadoItinerarioPolitica.ESTADO_DECISION_COMITE, estado.getEstadoItinerarioPolitica().getCodigo());
        */
    }

    /**
     * Carga personas, contratos, sus relaciones y alertas.
     */
    @Before
    public void limpiarBBDD() {
        executeScript(borrarPoliticas);
        clearHibernateSession();
        flushHibernateSession();
    }
}
