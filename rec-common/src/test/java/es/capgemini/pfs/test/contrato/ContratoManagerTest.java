package es.capgemini.pfs.test.contrato;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ContratoManagerTest extends CommonTestAbstract {

    @Autowired
    ContratoManager contratoManager;

    @Test
    public final void testFindContrato() {
        DtoBuscarContrato contrato = new DtoBuscarContrato();
        contrato.setId(1L);
        contratoManager.findContrato(contrato);
    }

    @Test
    public final void testGet() {
        contratoManager.get(1L);
    }

    @Test
    public final void testGetUltimaFechaCarga() {
        contratoManager.getUltimaFechaCarga();
    }

    @Test
    public final void testBuscarContratosExpediente() {
        DtoBuscarContrato dto = new DtoBuscarContrato();
        contratoManager.buscarContratosExpediente(dto);
    }

    @Test
    public final void testBuscarContratosCliente() {
        DtoBuscarContrato dto = new DtoBuscarContrato();
        dto.setStart(1);
        dto.setLimit(1);
        dto.setIdPersona(1L);
        dto.setTipoBusquedaPersona(1);
        contratoManager.buscarContratosCliente(dto);
    }

    @Test
    public final void testContratosDelExpedienteParaTitulos() {
        DtoBuscarContrato dto = new DtoBuscarContrato();
        dto.setIdExpediente(1L);
    }

    @Test
    public final void testPersonasDeLosContratos() {
        contratoManager.personasDeLosContratos("1");
    }

    @Test
    public final void testBuscarContratos() {
        BusquedaContratosDto dto = new BusquedaContratosDto();
        contratoManager.buscarContratos(dto);
    }

    @Test
    public final void testGetTitulosContratoPaginado() {
        DtoBuscarContrato dto = new DtoBuscarContrato();
        contratoManager.getTitulosContratoPaginado(dto);
    }

    @Test
    public final void testGetExpedientesHistoricosContrato() {
        contratoManager.getExpedientesHistoricosContrato(1L);
    }

    @Test
    public final void testGetAsuntosContrato() {
        contratoManager.getAsuntosContrato(1L);
    }

    @Test
    public final void testObtenerContratosGeneracionExpManual() {
        contratoManager.obtenerContratosGeneracionExpManual(1L);
    }

    @Test
    public final void testObtenerNumContratosGeneracionExpManual() {
        contratoManager.obtenerNumContratosGeneracionExpManual(1L);
    }

    @Test
    public final void testGetContratosById() {
        contratoManager.getContratosById("1");
    }

    @Test
    public final void testBuscarClientesDeContratos() {
        List<String> contratos = new ArrayList<String>(1);
        contratoManager.buscarClientesDeContratos(contratos);
    }

}
