package es.capgemini.pfs.test.expediente;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.politica.dto.DtoPersonaPoliticaUlt;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.titulo.DDSituacionManager;
import es.capgemini.pfs.titulo.DDTipoTituloManager;
import es.capgemini.pfs.titulo.TituloManager;
import es.capgemini.pfs.titulo.model.DDSituacion;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;
import es.capgemini.pfs.titulo.model.Titulo;

/**
 * Tests para expedientes.
 * @author Belén Torrado
 */
public class ExpedienteTest extends CommonTestAbstract {

    @javax.annotation.Resource
    private Resource cargarRelacionesValidas;

    @javax.annotation.Resource
    private Resource cargarContratoExpediente;

    @javax.annotation.Resource
    private Resource destroyCargasExpediente;

    @Autowired
    private ExpedienteManager expedienteManager;
    @Autowired
    private ContratoManager contratoManager;

    @Autowired
    private DDSituacionManager ddSituacionManager;
    @Autowired
    private DDTipoTituloManager ddTipoTituloManager;
    @Autowired
    private TituloManager tituloManager;

    private static final Long ID_PERSONA = new Long(1);
    private static final String AMBITO_EXPEDIENTE = DDAmbitoExpediente.CONTRATO_PASE;

    private static final Long ID_CONTRATO = new Long(10000);
    private static final Long ID_CONTRATO2 = new Long(5);
    private static final Long ID_EXPEDIENTE_RECUPERACION = new Long(1);
    private static final Long ID_EXPEDIENTE_SEGUIMIENTO = new Long(8);

    /**
     * set up.
     */
    @Before
    public void loadData() {
        clearHibernateSession();
    }

    /**
     * Limpeza de datos.
     */
    @After
    public void clean() {
        executeScript(destroyCargasExpediente);
    }

    /**
     * Busca expedientes para un contrato determinado.
     */
    @Test
    public final void buscarExpedientes() {
        executeScript(cargarContratoExpediente);

        DtoBuscarExpedientes dtoBuscarExpediente = new DtoBuscarExpedientes();
        dtoBuscarExpediente.setIdCnt(ID_CONTRATO);
    }

    /**
     */
    @Test
    public final void buscarSupervisor() {
        executeScript(cargarContratoExpediente);
        DtoBuscarExpedientes dtoBuscarExpediente = new DtoBuscarExpedientes();
        dtoBuscarExpediente.setIdCnt(ID_CONTRATO);
        List<String> expedientes = expedienteManager.obtenerSupervisorGeneracionExpediente(dtoBuscarExpediente);

        assertTrue("No existen expedientes para el contrato", expedientes.size() > 0);
        //executeScript(destroyContratoExpediente);
    }

    /**
     * Método encargado de insertar un título para un contrato determinado.
     */
    @Test
    public final void insertarTitulo() {
        executeScript(cargarContratoExpediente);
        DtoBuscarContrato dtoBuscarContrato = new DtoBuscarContrato();
        // Obtenemos el contrato
        dtoBuscarContrato.setId(ID_CONTRATO);
        Contrato contrato = contratoManager.findContrato(dtoBuscarContrato);
        Titulo titulo = new Titulo();
        titulo.setContrato(contrato);

        // Obtenemos la situacién
        DDSituacion situacion = ddSituacionManager.findSituacion(Titulo.CODIGO_SITUACION_TITULO_NINGUNO);
        titulo.setSituacion(situacion);

        // Obtenemos el tipo de título
        DDTipoTitulo tipoTitulo = ddTipoTituloManager.findTipoTitulo(Titulo.CODIGO_TIPO_TITULO_NINGUNO);
        titulo.setTipoTitulo(tipoTitulo);

        titulo.setAuditoria(Auditoria.getNewInstance());

        tituloManager.saveTitulo(titulo);
        flushHibernateSession();

        List<Titulo> titulos = tituloManager.findTituloByContrato(dtoBuscarContrato);

        assertTrue("No existen títulos para el contrato", titulos.size() > 0);
    }

    /**
     * Obtener todas las personas de marcado oblicatorio para el expediente.
     */
    @Test
    public final void getPersonasMarcadoObligatorioRecuperacion() {
        List<DtoPersonaPoliticaUlt> marcadoObligatorio = expedienteManager.getPersonasMarcadoObligatorio(ID_EXPEDIENTE_RECUPERACION);
        assertEquals(1, marcadoObligatorio.size());
    }

    /**
     * Obtener todas las personas de marcado opcional para el expediente.
     */
    @Test
    public final void getPersonasMarcadoOpcionalRecuperacion() {
        List<DtoPersonaPoliticaUlt> marcadoObligatorio = expedienteManager.getPersonasMarcadoOpcional(ID_EXPEDIENTE_RECUPERACION);
        assertEquals(10, marcadoObligatorio.size());
    }

    /**
     * Obtener todas las personas de marcado oblicatorio para el expediente.
     */
    @Test
    public final void getPersonasMarcadoObligatorioSeguimiento() {
        List<DtoPersonaPoliticaUlt> marcadoObligatorio = expedienteManager.getPersonasMarcadoObligatorio(ID_EXPEDIENTE_SEGUIMIENTO);
        assertEquals(1, marcadoObligatorio.size());
    }

    /**
     * Obtener todas las personas de marcado opcional para el expediente.
     */
    @Test
    public final void getPersonasMarcadoOpcionalSeguimiento() {
        List<DtoPersonaPoliticaUlt> marcadoObligatorio = expedienteManager.getPersonasMarcadoOpcional(ID_EXPEDIENTE_SEGUIMIENTO);
        assertEquals(2, marcadoObligatorio.size());
    }
}
