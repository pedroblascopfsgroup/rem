package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ActivoAdjuntosAgrupacionApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;


@Service
public class AgrupacionAdjuntosAdapter {
	
	
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
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	//TODO: Revisar que se está copiando bien
	public List<DtoAdjuntoAgrupacion> getAdjuntosAgrupacion(Long idAgrupacion)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjuntoAgrupacion> listaAdjuntos = new ArrayList<DtoAdjuntoAgrupacion>();
		

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			return null;
		} else {
			listaAdjuntos = creaListaAdjuntosAgrupacion(idAgrupacion, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	public List<DtoAdjuntoAgrupacion> creaListaAdjuntosAgrupacion(Long idAgrupacion, List<DtoAdjuntoAgrupacion> listaAdjuntos) throws IllegalAccessException, InvocationTargetException {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
			List<ActivoAdjuntoAgrupacion> adjuntosAgrupacion = genericDao.getList(ActivoAdjuntoAgrupacion.class, filtro);

			for (ActivoAdjuntoAgrupacion adjuntoAgrupacion : adjuntosAgrupacion) {
				DtoAdjuntoAgrupacion dto = new DtoAdjuntoAgrupacion();
				//TODO: REVISAR PROPIEDADES
				BeanUtils.copyProperties(dto, adjuntoAgrupacion);
				listaAdjuntos.add(dto);
			}

		return listaAdjuntos;
	}
	
	
	public String uploadDocumento(WebFileItem webFileItem) throws Exception {
			Filter fAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", Long.parseLong(webFileItem.getParameter("idAgrupacion")));
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,fAgrupacion);
			
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			return null;
		} else {
			activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, null, agrupacion);
		}
		
		return null;
	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		FileItem result = dl.getFileItemPromocion(id,nombreDocumento);
		if(result == null){
			throw new UserException("El fichero no existe");
		}
		return result;
	}

}
