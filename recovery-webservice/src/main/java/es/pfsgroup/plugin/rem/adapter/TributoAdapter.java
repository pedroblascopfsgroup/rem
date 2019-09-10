package es.pfsgroup.plugin.rem.adapter;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;


@Service
public class TributoAdapter {
	
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTributoApi activoTributoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	

	public String uploadDocumento(WebFileItem webFileItem, String matricula) throws Exception {
		ActivoTributos activoTributo = activoTributoApi.getTributo(Long.parseLong(webFileItem.getParameter("idTributo")));
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocumentoTributos tipoDocumento = genericDao.get(DDTipoDocumentoTributos.class, filtro);
		if(!Checks.esNulo(tipoDocumento)) {
			matricula = tipoDocumento.getMatricula();
		}
		
		if (Checks.esNulo(activoTributo)) {
				
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoTributo(webFileItem, usuarioLogado.getUsername(), matricula);
				activoTributoApi.upload2(webFileItem, idDocRestClient);
			} else {
				activoTributoApi.upload(webFileItem);
			}
		} else {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if (!Checks.esNulo(tipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoTributo(webFileItem, usuarioLogado.getUsername(), matricula);
					activoTributoApi.uploadDocumento(webFileItem, idDocRestClient, activoTributo, matricula);
				}
			} else {
				activoTributoApi.uploadDocumento(webFileItem, null, activoTributo, matricula);
			}
		}
		
		return null;
	}
	
	
	
	
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null);

	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		FileItem result = dl.getFileItemTributo(id,nombreDocumento);
		if(result == null){
			throw new UserException("El fichero no existe");
		}
		return result;
	}

}
