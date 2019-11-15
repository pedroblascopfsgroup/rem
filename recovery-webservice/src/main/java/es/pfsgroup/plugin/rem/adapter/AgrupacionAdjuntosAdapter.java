package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
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
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoAdjuntosAgrupacionApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;


@Service
public class AgrupacionAdjuntosAdapter {
	
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	
	protected static final Log logger = LogFactory.getLog(AgrupacionAdjuntosAdapter.class);
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	@Autowired
	private ActivoAdjuntosAgrupacionApi activoAdjuntosAgrupacionApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	//TODO: Revisar que se está copiando bien
	public List<DtoAdjuntoAgrupacion> getAdjuntosAgrupacion(Long idAgrupacion)throws GestorDocumentalException, IllegalAccessException, InvocationTargetException, ParseException {
		List<DtoAdjuntoAgrupacion> listaAdjuntos = new ArrayList<DtoAdjuntoAgrupacion>();
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			 try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntoAgrupacion(idAgrupacion);
			} catch (GestorDocumentalException gex) {
				String[] error = gex.getMessage().split("-");
				if (error.length > 0 &&  (error[2].trim().contains("Error al obtener el activo, no existe"))) {
					Usuario usuario = genericAdapter.getUsuarioLogado();
					Integer idExp;
					try{ 
						idExp = gestorDocumentalAdapterApi.crearContenedorAdjuntoAgrupacion(idAgrupacion ,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + idAgrupacion + "]: ID EXPEDIENTE RECIBIDO " + idExp);
					} catch (GestorDocumentalException gexc) {
						gexc.printStackTrace();
						logger.debug(gexc.getMessage());
					}
				}
				try {
					throw gex;
				} catch (GestorDocumentalException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} else {
			listaAdjuntos = creaListaAdjuntosAgrupacion(idAgrupacion, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	public List<DtoAdjuntoAgrupacion> creaListaAdjuntosAgrupacion(Long idAgrupacion, List<DtoAdjuntoAgrupacion> listaAdjuntos) throws IllegalAccessException, InvocationTargetException {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrupacion.numAgrupRem", idAgrupacion);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<ActivoAdjuntoAgrupacion> adjuntosAgrupacion = genericDao.getList(ActivoAdjuntoAgrupacion.class, filtro,filtroBorrado);

			for (ActivoAdjuntoAgrupacion adjuntoAgrupacion : adjuntosAgrupacion) {
				if ( Checks.esNulo (adjuntoAgrupacion.getIdDocRestClient())) {
					DtoAdjuntoAgrupacion dto = new DtoAdjuntoAgrupacion(); 
					BeanUtils.copyProperties(dto, adjuntoAgrupacion);
					if (!Checks.esNulo(adjuntoAgrupacion.getAgrupacion()))
						BeanUtils.copyProperty(dto, "idAgrupacion", adjuntoAgrupacion.getAgrupacion().getId());
					if (!Checks.esNulo(adjuntoAgrupacion.getAdjunto()))
						BeanUtils.copyProperty(dto, "id", adjuntoAgrupacion.getAdjunto().getId());
					if (!Checks.esNulo(adjuntoAgrupacion.getTipoDocumentoAgrupacion())) {
						BeanUtils.copyProperty(dto, "codigoTipo", adjuntoAgrupacion.getTipoDocumentoAgrupacion().getCodigo());
						BeanUtils.copyProperty(dto, "descripcionTipo", adjuntoAgrupacion.getTipoDocumentoAgrupacion().getDescripcion());
					}
					if(!Checks.esNulo(adjuntoAgrupacion.getTamanyo())) {
						BeanUtils.copyProperty(dto, "tamanyo", adjuntoAgrupacion.getTamanyo());
					}
					if(!Checks.esNulo(adjuntoAgrupacion.getFechaDocumento())) {
						BeanUtils.copyProperty(dto, "fechaDocumento", adjuntoAgrupacion.getFechaDocumento());
					}
					listaAdjuntos.add(dto);
				}
			}

		return listaAdjuntos;
	}
	
	
	public String uploadDocumento(WebFileItem webFileItem) throws Exception {
		Filter fAgrupacion = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", Long.parseLong(webFileItem.getParameter("idAgrupacion")));
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,fAgrupacion); 
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipoDocumentoAgrupacion"));
		DDTipoDocumentoAgrupacion tipoDocumento = genericDao.get(DDTipoDocumentoAgrupacion.class, filtro);
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			if (!Checks.esNulo(tipoDocumento)) {
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoAgrupacionAdjunto(agrupacion, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, idDocRestClient,agrupacion,null,usuarioLogado);
			}
		}else {
			activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, null,agrupacion,null,usuarioLogado);
		}
		
		return null;
	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		FileItem result = dl.getFileItemAgrupacion(id,nombreDocumento);
		if(result == null){
			throw new UserException("El fichero no existe");
		}
		return result;
	}
	
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
			} catch (Exception e) {
				logger.error("Error en deleteAdjunto Agrupacion adapter", e);
			}
		} else {
			borrado = activoAdjuntosAgrupacionApi.deleteAdjunto(dtoAdjunto);
		}
		return borrado;
	}
	
	
	public Long getAgrupacionYubaiByIdActivo(Long id) {
		return activoDao.getAgrupacionYubaiByIdActivo(id);
	}

}
