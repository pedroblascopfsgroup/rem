package es.pfsgroup.plugin.rem.adapter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;


@Service
public class TributoAdapter {
	
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoTributoApi activoTributoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	protected static final Log logger = LogFactory.getLog(TributoAdapter.class);
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	

	public String uploadDocumento(WebFileItem webFileItem, String matricula) throws Exception {
		ActivoTributos activoTributo = activoTributoApi.getTributo(Long.parseLong(webFileItem.getParameter("idTributo")));
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocumentoTributos tipoDocumento = genericDao.get(DDTipoDocumentoTributos.class, filtro);

		
		if(!Checks.esNulo(tipoDocumento)) {
			matricula = tipoDocumento.getMatricula();
		}
		
		if(!Checks.esNulo(activoTributo)) {
				
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
								
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoTributo(webFileItem, usuarioLogado.getUsername(), matricula);
				activoTributoApi.uploadDocumento(webFileItem, idDocRestClient, activoTributo, matricula);
				
				String activos = webFileItem.getParameter("activos");
				String[] arrayActivos = null;
				
				if (!Checks.esNulo(activos) && !Checks.esNulo(tipoDocumento.getVinculable()) && tipoDocumento.getVinculable() ) {
					
					CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
					
					crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
					crearRelacionExpedienteDto.setCodTipoDestino(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES);
					crearRelacionExpedienteDto.setCodClaseDestino(GestorDocumentalConstants.CODIGO_CLASE_TRIBUTOS);
					crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);
					
					gestorDocumentalAdapterApi.crearRelacionActivoTributo(activoTributo, idDocRestClient, activos, usuarioLogado.getUsername(),crearRelacionExpedienteDto);
					arrayActivos = activos.split(",");
					
					
					for(int i = 0; i < arrayActivos.length; i++){
						Activo activoEntrada = activoApi.getByNumActivo(Long.parseLong(arrayActivos[i],10));
						File file = File.createTempFile("idDocRestClient["+idDocRestClient+"]", ".pdf");
						BufferedWriter out = new BufferedWriter(new FileWriter(file));
						try {
							FileItem fileItem = new FileItem();
							fileItem.setFileName("idDocRestClient["+idDocRestClient+"]");
							fileItem.setFile(file);
							fileItem.setLength(file.length());			
							webFileItem.setFileItem(fileItem);
							activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
						}finally {
							 out.close();
							 if(!file.delete()){
								 logger.info("No se podido borrar el temporarl de descarga");
							 }
						}
					    out.write("pfs");
					   					    
					    
						
						
					}
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
