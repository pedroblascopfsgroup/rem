package es.capgemini.pfs.test.itinerario;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.itinerario.DDEstadoItinerarioManager;
import es.capgemini.pfs.itinerario.EstadoManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.test.CommonTestAbstract;

public class EstadoManagerTest extends CommonTestAbstract{
	
	@Autowired
	EstadoManager estadoManager;
	
	@Autowired
	DDEstadoItinerarioManager estadoItinerarioManager;

	@Test
	public final void testGet() {
		Itinerario itinerario = new Itinerario();
		DDEstadoItinerario ddEstadoItinerario = estadoItinerarioManager.getEstadosExpedientes().get(0);		
		estadoManager.get(itinerario, ddEstadoItinerario);
	}

}
