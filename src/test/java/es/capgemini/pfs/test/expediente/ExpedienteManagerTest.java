package es.capgemini.pfs.test.expediente;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ExpedienteManagerTest extends CommonTestAbstract {

    @Autowired
    ExpedienteManager expedienteManager;

    @Test
    public final void testFindExpedientesPaginated() {
        DtoBuscarExpedientes expedientes = new DtoBuscarExpedientes();
        expedienteManager.findExpedientesPaginated(expedientes);
    }

    @Test
    public final void testFindExpedientesContrato() {
        DtoBuscarExpedientes expedientes = new DtoBuscarExpedientes();
        expedientes.setIdCnt(1L);
    }

    @Test
    public final void testFindExpedientesContratoPorId() {
        expedienteManager.findExpedientesContratoPorId(1L);
    }

    @Test
    public final void testContratosDeUnExpedienteSinPaginar() {
        DtoBuscarContrato dto = new DtoBuscarContrato();
        dto.setIdExpediente(1L);
        expedienteManager.contratosDeUnExpedienteSinPaginar(dto);
    }

    @Test
    public final void testFindPersonasByExpedienteId() {
        expedienteManager.findPersonasByExpedienteId(1L);
    }

    @Test
    public final void testObtenerPersonasGeneracionExpediente() {
    }

    @Test
    public final void testObtenerSupervisorGeneracionExpediente() {
        DtoBuscarExpedientes expediente = new DtoBuscarExpedientes();
        expediente.setIdCnt(1L);
        expedienteManager.obtenerSupervisorGeneracionExpediente(expediente);
    }

    @Test
    public final void testGetExpediente() {
        expedienteManager.getExpediente(1L);
    }

    @Test
    public final void testObtenerExpedientesDeUnaPersona() {
        expedienteManager.obtenerExpedientesDeUnaPersona(1L);
    }

    @Test
    public final void testObtenerExpedientesDeUnaPersonaNoCancelados() {
        expedienteManager.obtenerExpedientesDeUnaPersonaNoCancelados(1L);
    }

    @Test
    public final void testFindTitulosExpediente() {
        expedienteManager.findTitulosExpediente(1L);
    }

    @Test
    public final void testBuscarAAA() {
        expedienteManager.buscarAAA(1L);
    }

    @Test
    public final void testFindPersonasTitContratosExpediente() {
        expedienteManager.findPersonasTitContratosExpediente(1L);
    }

    @Test
    public final void testFindPersonasContratosConAdjuntos() {
        expedienteManager.findPersonasContratosConAdjuntos(1L);
    }

    @Test
    public final void testFindContratosConAdjuntos() {
        expedienteManager.findContratosConAdjuntos(1L);
    }

    @Test
    public final void testGetPropuestaExpedienteManual() {
        expedienteManager.getPropuestaExpedienteManual(1L);
    }

    @Test
    public final void testFindExclusionExpedienteClienteByExpedienteId() {
        expedienteManager.findExclusionExpedienteClienteByExpedienteId(1L);
    }

    @Test
    public final void testBuscarSolicitudCancelacion() {
        expedienteManager.buscarSolicitudCancelacion(1L);
    }

    @Test
    public final void testBuscarSolCancPorTarea() {
        expedienteManager.buscarSolCancPorTarea(1L);
    }

    @Test
    public final void testFindExpedientesParaExcel() {
        DtoBuscarExpedientes dto = new DtoBuscarExpedientes();
        expedienteManager.findExpedientesParaExcel(dto);
    }

    @Test
    public final void testGetReglasElevacionExpediente() {
        expedienteManager.getReglasElevacionExpediente(1L);
    }

    @Test
    public final void testGetEntidadReglaElevacionExpediente() {
        expedienteManager.getEntidadReglaElevacionExpediente(1L, 1L);
    }

    @Test
    public final void testGetPersonasMarcadoObligatorio() {
        expedienteManager.getPersonasMarcadoObligatorio(1L);
    }

    @Test
    public final void testGetPersonasMarcadoOpcional() {
        expedienteManager.getPersonasMarcadoOpcional(1L);
    }

    @Test
    public final void testGetPersonasPoliticasDelExpediente() {
        expedienteManager.getPersonasPoliticasDelExpediente(1L);
    }

    @Test
    public final void testGetExpedienteContrato() {
        expedienteManager.getExpedienteContrato(1L);
    }

}
