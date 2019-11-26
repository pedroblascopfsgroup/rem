package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;

public interface TramitacionOfertasApi {

	String getSubtipoTrabajoByOferta(Oferta oferta);

	ExpedienteComercial crearExpediente(Oferta oferta, Trabajo trabajo, Oferta ofertaOriginalGencatEjerce)
			throws Exception;

	boolean saveOferta(DtoOfertaActivo dto, Boolean esAgrupacion) throws JsonViewerException, Exception, Error;

	public List<GastosExpediente> crearGastosExpediente(Oferta oferta, ExpedienteComercial nuevoExpediente);

}
