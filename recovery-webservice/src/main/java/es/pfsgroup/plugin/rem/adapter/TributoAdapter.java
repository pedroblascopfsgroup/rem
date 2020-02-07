package es.pfsgroup.plugin.rem.adapter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
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
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;


@Service
public class TributoAdapter {
	
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	protected static final Log logger = LogFactory.getLog(TributoAdapter.class);	
		
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
						crearFicheroRelacion( activoEntrada, webFileItem,  matricula,  idDocRestClient);

					}
				}
				
			} else {
				activoTributoApi.uploadDocumento(webFileItem, null, activoTributo, matricula);
			}
		}
		
		return null;
	}
	
	
	private void crearFicheroRelacion(Activo activoEntrada,WebFileItem webFileItem, String matricula, Long idDocRestClient) throws Exception{
		BufferedWriter out = null;
		try {
			File file = File.createTempFile("idDocRestClient["+idDocRestClient+"]", ".pdf");
			out = new BufferedWriter(new FileWriter(file));
		    out.write("pfs");
						    
		    FileItem fileItem = new FileItem();
			fileItem.setFileName("idDocRestClient["+idDocRestClient+"]");
			fileItem.setFile(file);
			fileItem.setLength(file.length());			
			webFileItem.setFileItem(fileItem);
			activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
			if(!file.delete()) {
				logger.error("Imposible borrar fichero temporal");
			}
		}finally {
			if(out != null){
				out.close();	
			}
		}
		
	}
	
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null);

	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItem(id,nombreDocumento);
	}

	public List<DtoAdjuntoTributo> getAdjuntos(Long idTributo)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException{
		List<DtoAdjuntoTributo> listaAdjuntos = new ArrayList<DtoAdjuntoTributo>();
		ActivoTributos tributo = null;
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				tributo = activoTributoApi.getTributo(idTributo);
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosTributo(tributo);
			}catch(GestorDocumentalException gex){
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
					gestorDocumentalAdapterApi.crearTributo(tributo, usuarioLogado.getUsername(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES);
				}
			}
		}else {
			listaAdjuntos = getAdjuntosTributo(idTributo, listaAdjuntos);
		}
		
		return listaAdjuntos;
	}
	
	private List<DtoAdjuntoTributo> getAdjuntosTributo(Long idTributo, List<DtoAdjuntoTributo> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		ActivoTributos tributo = activoTributoApi.getTributo(idTributo);
		
		for(ActivoAdjuntoTributo adjunto : tributo.getAdjuntos()) {
			DtoAdjuntoTributo dto = new DtoAdjuntoTributo();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(tributo.getActivo().getId().toString());
			dto.setIdTributo(idTributo);
			dto.setDescripcionTipo(adjunto.getTipoDocumentoTributo().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		
		return listaAdjuntos;
	}

	public Boolean deleteAdjunto(DtoAdjuntoTributo dto) {
		Boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dto.getId(), usuarioLogado.getUsername());
				ActivoAdjuntoTributo adjunto = activoTributoApi.getAdjuntoTributo(dto.getId());
				if(borrado && adjunto != null) {
					dto.setId(adjunto.getId());
					activoTributoApi.deleteAdjuntoDeTributo(dto);
				}
			} catch (Exception e) {
				logger.error("Error en ActivoAdapter", e);
			}
		} else {
			borrado = activoTributoApi.deleteAdjuntoDeTributo(dto);
		}
		return borrado;
	}

}
