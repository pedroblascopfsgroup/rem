package es.pfsgroup.plugin.recovery.mejoras.cliente;

import java.util.List;

import es.capgemini.pfs.expediente.model.Evento;

public interface EventoClienteBuilder {

	
	List<Evento> getEventos(long idCliente);
}
