package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;

public interface TramitacionOfertasApi {

	String getSubtipoTrabajoByOferta(Oferta oferta);

	boolean saveOferta(DtoOfertaActivo dto, Boolean esAgrupacion) throws JsonViewerException, Exception, Error;

	ExpedienteComercial crearExpediente(Oferta oferta, Trabajo trabajo, Oferta ofertaOriginalGencatEjerce,
			Activo activo) throws Exception;

}
