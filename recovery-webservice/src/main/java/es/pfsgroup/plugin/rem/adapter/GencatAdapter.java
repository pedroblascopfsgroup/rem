package es.pfsgroup.plugin.rem.adapter;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.gencat.GencatManager;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Service
public class GencatAdapter {
	
	@Autowired
	private GencatManager gencatManager;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;

	private String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {

		if (Checks.esNulo(activoEntrada)) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Activo activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);
				Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo, webFileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				gencatManager.uploadDocumento(webFileItem, idDocRestClient, null, null, usuarioLogado);
			} 
			else {
				gencatManager.uploadDocumento(webFileItem, null, null, null, usuarioLogado);
			}
		} 
		else {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao
						.get(DDTipoDocumentoActivo.class, filtro);

				if (!Checks.esNulo(tipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.upload(activoEntrada, webFileItem,
							usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					gencatManager.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula, usuarioLogado);
				}
			} 
			else {
				gencatManager.uploadDocumento(webFileItem, null, activoEntrada, matricula, usuarioLogado);
			}
		}
		return null;
	}
	
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);

	}
	
}
