package es.pfsgroup.plugin.rem.api;

import java.io.File;
import java.util.Map;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertaPdfPrincipal;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.service.api.GenerateJasperPdfServiceApi;

public interface GenerarPdfAprobacionOfertasApi extends GenerateJasperPdfServiceApi {
	

	public File getDocumentoPropuestaVenta(Oferta oferta) throws Exception;

	public Map<String, Object> paramsHojaDatos(Oferta oferta, CompradorExpediente compradorExp)  throws Exception;
	
	public DtoOfertaPdfPrincipal getDtoPdfPrincipalRelleno(Oferta oferta);

	public WebFileItem getWebFileItemByFile(File file, Long numExpediente);
	
}
