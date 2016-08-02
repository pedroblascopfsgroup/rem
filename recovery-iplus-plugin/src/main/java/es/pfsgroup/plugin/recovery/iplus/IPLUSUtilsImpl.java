package es.pfsgroup.plugin.recovery.iplus;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.iplus.IPLUSAdjuntoAuxDto;
import es.capgemini.pfs.iplus.IPLUSUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Component("IPLUSUtils")
public class IPLUSUtilsImpl implements IPLUSUtils {

	private static final String DEVON_HOME_BANKIA = "datos/usuarios/recovecp";
	private static final String DEVON_HOME = "DEVON_HOME";
	private static final String DEVON_PROPERTIES = "devon.properties";
	private static final String IPLUS_INSTALADO = "iplus.instalado";
	private static final String IPLUS_INSTALADO_SI = "SI";
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Resource
	private Properties appProperties;
	
	@Autowired
	private GestionIplusFacade iplusFacade;
	
	private boolean iplusInstalado;
	
	public IPLUSUtilsImpl() {
		if (appProperties == null) {
			this.appProperties = cargarProperties(DEVON_PROPERTIES);
		}
		if (appProperties == null) {
			System.out.println("No puedo consultar devon.properties");
			iplusInstalado = false;
		} else if (appProperties.containsKey(IPLUS_INSTALADO) && appProperties.getProperty(IPLUS_INSTALADO).equals(IPLUS_INSTALADO_SI)) {
			System.out.println("IPLUS instalado");
			iplusInstalado = true;
		} else {
			System.out.println("IPLUS no instalado");
			iplusInstalado = false;
		}

	}
	
	public boolean instalado() {
		return iplusInstalado;
	}

	public void almacenar(Asunto asunto, EXTAdjuntoAsunto adjuntoAsunto) {
		System.out.println("Almacenar en IPLUS: " + asunto.getId() + "---" + adjuntoAsunto.getTipoFichero().getCodigo());
		
		//Poner el campo correcto como "id_procedi" (ID_ASUNTO_EXTERNO : codigoExterno)
		String idProcedi = obtenerIdAsuntoExterno(asunto.getId());
		String tipoFicheroAdjunto = adjuntoAsunto.getTipoFichero().getCodigo();
		String nombreDoc = adjuntoAsunto.getNombre(); //Puede que haya que cambiar este origen de dato
		File file = adjuntoAsunto.getAdjunto().getFileItem().getFile();
		iplusFacade.almacenar(idProcedi, tipoFicheroAdjunto, nombreDoc, file);
	}
	
	public Set<AdjuntoAsunto> listarAdjuntosIplus(String idProcedi) {
		System.out.println("Lista de documentos almacenados en IPLUS: " + idProcedi);
		
		Set<AdjuntoAsunto> adjuntos = new HashSet<AdjuntoAsunto>();
		List<IplusDocDto> listaDocs = iplusFacade.listaDocumentos(idProcedi);
		if (listaDocs != null) {
			for (IplusDocDto doc : listaDocs) {
				FileItem fi = new FileItem();
				fi.setFile(doc.getFile());
				fi.setLength(doc.getFile().length());
				fi.setFileName(doc.getNombreFichero());
				AdjuntoAsunto adjunto = new EXTAdjuntoAsunto(fi);
				adjunto.setNombre(doc.getNombreFichero());

				String descripcion = doc.getFile().getName();
				adjunto.setDescripcion(descripcion);
				
				Auditoria auditoria = new Auditoria();
				Date fechaCrear = doc.getFechaCrear();
				String usuarioCrear = doc.getUsuarioCrear();
				auditoria.setFechaCrear(fechaCrear);
				auditoria.setUsuarioCrear(usuarioCrear);
				adjunto.setAuditoria(auditoria);

				adjuntos.add(adjunto);
			}
		}
		return adjuntos;
	}
	
	private Properties cargarProperties(String nombreProps) {

		InputStream input = null;
		Properties prop = new Properties();
		
		String devonHome = DEVON_HOME_BANKIA;
		if (System.getenv(DEVON_HOME) != null) {
			devonHome = System.getenv(DEVON_HOME);
		}
		
		try {
			input = new FileInputStream("/" + devonHome + "/" + nombreProps);
			prop.load(input);
		} catch (IOException ex) {
			System.out.println("[IPlusUtils.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + ex.getMessage());
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					System.out.println("[IPlusUtils.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + e.getMessage());
				}
			}
		}
		return prop;
	}

	public String obtenerIdAsuntoExterno(Long id) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
		EXTAsunto m = genericDao.get(EXTAsunto.class, f1);
		if (m != null && m.getCodigoExterno() != null && !m.getCodigoExterno().equals("")) {
			return m.getCodigoExterno();
		} else {
			return "0";
		}
	}
	
	// OBTENER EL PROC (Actuacion) a partir del asunto y el nombre del documento
	// utilizado para los documentos subidos a IPLUS
	/** 
	 * Completamos la info del adjunto obtenido mediante IPLUS con otros datos que recuperamos de Recovery
	 */
	public IPLUSAdjuntoAuxDto completarInformacionAdjunto(Long asuId, String nombre) {

		Procedimiento proc = null;
		String contentType = "";
		Long longitud = null;
		DDTipoFicheroAdjunto tipoDocumento = null;
		IPLUSAdjuntoAuxDto auxDto = new IPLUSAdjuntoAuxDtoImpl();
		
		try{
			List<AdjuntoAsunto> aaList = genericDao.getList(AdjuntoAsunto.class, 
					genericDao.createFilter(FilterType.EQUALS, "asunto.id", asuId));
			logger.debug("Adjuntos recovery obtenidos " + aaList.size());
			if (!Checks.esNulo(aaList)) {
				for (AdjuntoAsunto aa : aaList) {
					logger.debug("Comprobamos adjunto recovery  " + aa.getId());
					if (!Checks.esNulo(aa.getNombre())) {
						logger.debug("Nombre adjunto recovery no nulo");
						logger.debug("Nombre adjunto recovery " + aa.getNombre());
						String nombreAA = aa.getNombre().toUpperCase();
						logger.debug("Nombre adjunto recovery upper " + nombreAA);
						nombre = nombre.toUpperCase();
						logger.debug("Nombre adjunto iplus upper " + nombre);
						if (nombre.endsWith(nombreAA)) {
							logger.debug("Nombre endsWith nombreAA");
							proc = aa.getProcedimiento();
							logger.debug("Procedimiento: " + aa.getProcedimiento().getId());
							contentType = aa.getContentType();
							logger.debug("contentType: " + aa.getContentType());
							longitud = aa.getLength();
							logger.debug("longitud: " + aa.getLength());
							tipoDocumento = ((EXTAdjuntoAsunto)aa).getTipoFichero();
							logger.debug("tipoDocumento: " + ((EXTAdjuntoAsunto)aa).getTipoFichero().getCodigo());
							break;
						}
					}
				}
			}
		} catch(Exception e){
			System.out.println("[" + this.getClass().getName() + ".obtenerProcedimiento]: "+e);
		}
		
		auxDto.setProc(proc);
		auxDto.setContentType(contentType);
		auxDto.setLongitud(longitud);
		auxDto.setTipoDocumento(tipoDocumento);
		logger.debug("Devuelve auxDto " + (Checks.esNulo(auxDto)? "NULO": "RELLENO"));
		return auxDto;
	}

	/**
	 * Elimina del set de adjuntosRecovery los adjuntos ya existentes en IPLUS
	 * @param adjuntosRecovery set de adjuntos recuperados de Recovery 
	 * @param adjuntosIplus lista de adjuntos procedentes de IPLUS
	 * @return
	 */
	public Set<EXTAdjuntoDto> eliminarRepetidos(Set<EXTAdjuntoDto> adjuntosRecovery,
			List<EXTAdjuntoDto> adjuntosIplus) {
		
		Set<EXTAdjuntoDto> setResultado = new HashSet<EXTAdjuntoDto>();
		
		if (adjuntosIplus.isEmpty()) {
			setResultado = adjuntosRecovery;
		} else {
			if (adjuntosRecovery != null && ! adjuntosRecovery.isEmpty()) {
				for (EXTAdjuntoDto adjRecovery : adjuntosRecovery ) {
					boolean existe = false;
					for (EXTAdjuntoDto adjIplus : adjuntosIplus) {
						AdjuntoAsunto aRecovery = (AdjuntoAsunto) adjRecovery.getAdjunto();
						AdjuntoAsunto aIplus = (AdjuntoAsunto) adjIplus.getAdjunto();
						if (compararAdjuntos(aRecovery, aIplus)) {
							existe = true;
						}
					}
					if (!existe) {
						setResultado.add(adjRecovery);
					}
				}
			}
		}
		return setResultado;
		
	}

	/**
	 * Compara adjuntos procedentes de Recovery con adjuntos procedentes de IPLUS:
	 * 	la única manera de hacerlo es mediante el nombre
	 * @param aRecovery adjunto procedente de recovery
	 * @param aIplus adjunto procedente de iplus
	 * @return
	 */
	private boolean compararAdjuntos(AdjuntoAsunto aRecovery, AdjuntoAsunto aIplus) {
		
		boolean iguales = false;
		
		if (Checks.esNulo(aRecovery)) {
			//System.out.println("[IPLUSUtilsImpl.compararAdjuntos]: aRecovery es nulo.");
			return iguales;
		}
		
		if (Checks.esNulo(aIplus)) {
			//System.out.println("[IPLUSUtilsImpl.compararAdjuntos]: aIplus es nulo.");
			return iguales;
		}

		String aRecoveryNombre = aRecovery.getNombre().toUpperCase();
		String aIplusNombre = aIplus.getNombre().toUpperCase();
		String aIplusDesc = aIplus.getDescripcion().toUpperCase();
		
		System.out.println(new Date() + "[IPLUSUtilsImpl.compararAdjuntos]: aRecovery.getNombre(): " + aRecoveryNombre);
		System.out.println(new Date() + "[IPLUSUtilsImpl.compararAdjuntos]: aIplus.getNombre(): " + aIplus.getNombre() +
					" - aIplus.getNombre(): " + aIplus.getDescripcion() );
		
		if (Checks.esNulo(aRecoveryNombre) || Checks.esNulo(aIplusDesc) || Checks.esNulo(aIplusNombre) ) {
			return iguales;
		} 

		if (aIplusNombre.endsWith(aRecoveryNombre) || aIplusDesc.endsWith(aRecoveryNombre)) {
			iguales = true;
		}
			
		return iguales;
	}
	
}
