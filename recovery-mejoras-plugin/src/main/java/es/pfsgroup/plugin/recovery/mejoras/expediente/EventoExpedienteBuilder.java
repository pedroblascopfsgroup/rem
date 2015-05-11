package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.List;

import es.capgemini.pfs.expediente.model.Evento;

public interface EventoExpedienteBuilder {

	List<Evento> getEventos(long idExpediente);
}
