package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.masivo.api.MSVEnvioImpresionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVPlazaCodigoPostalDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfEnvioImpresion;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

@Component
public class MSVEnvioImpresionManager implements MSVEnvioImpresionApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MSVPlazaCodigoPostalDao plazaCodigoDao;
	
	@Resource
	Properties appProperties;

	@Override
	@BusinessOperation(MSV_BO_ENVIO_IMPRESION)
	public void envioImpresion(Procedimiento proc, Date fechaImpresion,
			String tipoDocumentacion) {
 
		
		//Leer directorio en el que se van a dejar los documentos
		String rutaImpresion = (appProperties.getProperty(PROP_PATH_TO_PRINT) == null ? DEFAULT_PATH_TO_PRINT
				: appProperties.getProperty(PROP_PATH_TO_PRINT));
		
		List<MSVConfEnvioImpresion> listaConfCabecera = obtenerListaConfiguracionImpresion(tipoDocumentacion, false);
		List<MSVConfEnvioImpresion> listaConfDemandados = obtenerListaConfiguracionImpresion(tipoDocumentacion, true);
		
		//Recorrer lista de adjuntos del asunto y copiar al directorio destino
		if (proc != null) {
			Asunto asunto = proc.getAsunto();
			if (asunto != null && asunto.getAdjuntos() != null 
					&& asunto.getAdjuntos().size() > 0) {
				//Obtener plaza para el prefijo de los documentos
				String nomPlaza = obtenerPlaza(proc);
				//Obtener CASO_NOVA
				String numCasoNova = extraeCasoNova(asunto.getNombre());
				
				//Recorrer la lista de configuraciones de cabecera
				for (MSVConfEnvioImpresion envioImpresionCabecera : listaConfCabecera) {
					List<EXTAdjuntoAsunto> listaAdjuntoAsunto = obtenerAdjuntoAsunto(asunto.getId(), envioImpresionCabecera.getTipoDocumento().getId());
					if (listaAdjuntoAsunto != null && listaAdjuntoAsunto.size()>0) {
						if(!envioImpresionCabecera.getImprimirTodos()){
							EXTAdjuntoAsunto adjuntoAsunto = listaAdjuntoAsunto.get(0);
							if(adjuntoAsunto!=null)
								procesarAdjuntoAsuntoCabecera(adjuntoAsunto, envioImpresionCabecera, nomPlaza, 
									numCasoNova, rutaImpresion, fechaImpresion);
						}else{
							Iterator<EXTAdjuntoAsunto> it = listaAdjuntoAsunto.iterator();
							while (it.hasNext()) {
								EXTAdjuntoAsunto adjuntoAsunto = it.next();
								if(adjuntoAsunto!=null)
									procesarAdjuntoAsuntoCabecera(adjuntoAsunto, envioImpresionCabecera, nomPlaza, 
										numCasoNova, rutaImpresion, fechaImpresion);
							}
						}	
					}
				}

				//Recorrer la lista de configuraciones de demandados
				int numDemandados = obtenerNumDemandados(proc);
				for (MSVConfEnvioImpresion envioImpresionDemandado : listaConfDemandados) {
					for (int i = 1; i <= numDemandados; i++) {
						List<EXTAdjuntoAsunto> listaAdjuntoAsunto = obtenerAdjuntoAsunto(asunto.getId(), envioImpresionDemandado.getTipoDocumento().getId());
						if (listaAdjuntoAsunto != null && listaAdjuntoAsunto.size()>0) {
							if(!envioImpresionDemandado.getImprimirTodos()){
								EXTAdjuntoAsunto adjuntoAsunto = listaAdjuntoAsunto.get(0);
								if(adjuntoAsunto!=null)
									procesarAdjuntoAsuntoDemandado(adjuntoAsunto, envioImpresionDemandado, nomPlaza, 
										numCasoNova, rutaImpresion, fechaImpresion, i);
							}else{
								Iterator<EXTAdjuntoAsunto> it = listaAdjuntoAsunto.iterator();
								while (it.hasNext()) {
									EXTAdjuntoAsunto adjuntoAsunto = it.next();
									if(adjuntoAsunto!=null)
										procesarAdjuntoAsuntoDemandado(adjuntoAsunto, envioImpresionDemandado, nomPlaza, 
											numCasoNova, rutaImpresion, fechaImpresion, i);
								}
							}													
						}
					}
				}

			}
		}
		
	}

	/**
	 * Procesa un adjunto de un asunto de la cabecera
	 * @param adjuntoAsunto
	 * @param envioImpresionCabecera
	 * @param nomPlaza
	 * @param numCasoNova
	 * @param rutaImpresion
	 * @param fechaImpresion
	 * @param i
	 */
	private void procesarAdjuntoAsuntoCabecera(EXTAdjuntoAsunto adjuntoAsunto, MSVConfEnvioImpresion envioImpresionCabecera, 
			String nomPlaza, String numCasoNova, String rutaImpresion, Date fechaImpresion){
		File adjunto = adjuntoAsunto.getAdjunto().getFileItem().getFile();
		String nombreDoc = componerNombreEscrito(
				envioImpresionCabecera.getIncluirPlaza(),
				nomPlaza, numCasoNova, 0, envioImpresionCabecera.getNumOrden(), 
				0, adjuntoAsunto.getNombre());
		try {
			this.copiarFichero(rutaImpresion, fechaImpresion,
					adjunto, nombreDoc);
			if (envioImpresionCabecera.getNumCopiasAdicionales() > 0) {
				for (int j=1; j<=envioImpresionCabecera.getNumCopiasAdicionales(); j++) {
					String nombreDoc2 = componerNombreEscrito(
							envioImpresionCabecera.getIncluirPlaza(),
							nomPlaza, numCasoNova, 0,
							envioImpresionCabecera.getNumOrden(), 
							j, adjuntoAsunto.getNombre());
					this.copiarFichero(rutaImpresion, fechaImpresion,
							adjunto, nombreDoc2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	/**
	 * Procesa un adjunto de un asunto de un demandado
	 * @param adjuntoAsunto
	 * @param envioImpresionDemandado
	 * @param nomPlaza
	 * @param numCasoNova
	 * @param rutaImpresion
	 * @param fechaImpresion
	 * @param i
	 */
	private void procesarAdjuntoAsuntoDemandado(EXTAdjuntoAsunto adjuntoAsunto, MSVConfEnvioImpresion envioImpresionDemandado, 
			String nomPlaza, String numCasoNova, String rutaImpresion, Date fechaImpresion, int i){
		File adjunto = adjuntoAsunto.getAdjunto().getFileItem().getFile();
		String nombreDoc = componerNombreEscrito(
				envioImpresionDemandado.getIncluirPlaza(),
				nomPlaza, numCasoNova, i, envioImpresionDemandado.getNumOrden(), 
				0, adjuntoAsunto.getNombre());
		try {
			this.copiarFichero(rutaImpresion, fechaImpresion,
					adjunto, nombreDoc);
			if (envioImpresionDemandado.getNumCopiasAdicionales() > 0) {
				for (int j=1; j<=envioImpresionDemandado.getNumCopiasAdicionales(); j++) {
					String nombreDoc2 = componerNombreEscrito(
							envioImpresionDemandado.getIncluirPlaza(),
							nomPlaza, numCasoNova, 0,
							envioImpresionDemandado.getNumOrden(), 
							j, adjuntoAsunto.getNombre());
					this.copiarFichero(rutaImpresion, fechaImpresion,
							adjunto, nombreDoc2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
		

	private int obtenerNumDemandados(Procedimiento proc) {
		int resultado = 0;
		if (proc != null && proc.getPersonasAfectadas() != null) {
			resultado = proc.getPersonasAfectadas().size();
		}
		return resultado;
	}


	private String componerNombreEscrito(Boolean incluirPlaza, String nomPlaza, String numCasoNova,
			int numDemandado, Integer numOrden, Integer numCopiaAdicional, 
			String nombreDocumento) {
		String separador = "_";
		String copiaDemandado = "DemCop";
		String resultado = "";
		if (incluirPlaza) {
			resultado = this.sustituirCaracteresExtranyos(nomPlaza) + separador;
		}
		resultado = resultado + numCasoNova;
		if (numDemandado > 0) {
			resultado = resultado + separador + copiaDemandado + String.format("%02d", numDemandado);
		}
		resultado = resultado + separador + String.format("%02d", numOrden);
		if (numCopiaAdicional > 0) {
			resultado = resultado + separador + String.format("%02d", numCopiaAdicional);
		} else {
			resultado = resultado + separador + String.format("%02d", 0);
		}
		resultado = resultado + separador + sustituirCaracteresExtranyos(nombreDocumento);
		return resultado;
	}


	private List<EXTAdjuntoAsunto> obtenerAdjuntoAsunto(Long asuntoId, Long tipoDocId) {
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "asunto.id", asuntoId);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoFichero.id", tipoDocId);
		Order primeroMasReciente = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		return genericDao.getListOrdered(EXTAdjuntoAsunto.class, primeroMasReciente, filtro1, filtro2);		
	}


	private String obtenerPlaza(Procedimiento proc) {
		
		String nomPlaza = null;
		
		// Comprobamos si tiene plaza, en caso afirmativo devolvemos el nombre
		if (proc != null && proc.getJuzgado() != null && 
				proc.getJuzgado().getPlaza() != null && proc.getJuzgado().getPlaza().getDescripcionLarga() != null) {
			nomPlaza = proc.getJuzgado().getPlaza().getDescripcionLarga();
		}
		
		// En caso que no tenga plaza
		if (nomPlaza == null) {
			// Obtenemos primera dirección del primer titular
			Direccion direccion = obtenerDireccionPrimerTitular(proc);
			// Y a partir del CP, obtenemos la plaza
			if (direccion != null) {
				nomPlaza = obtenerPlazaDesdeDireccion(direccion.getId());
			}
		}
		
		//Si no se encuentra en la direccion que busque en el padre
		if (nomPlaza == null && proc != null && proc.getProcedimientoPadre() != null &&
				proc.getProcedimientoPadre().getJuzgado() != null && proc.getProcedimientoPadre().getJuzgado().getPlaza() != null &&
				proc.getProcedimientoPadre().getJuzgado().getPlaza().getDescripcionLarga() != null
				) {
			nomPlaza = proc.getProcedimientoPadre().getJuzgado().getPlaza().getDescripcionLarga();
		}
		
		//Si sigue sin plaza que devuelve "NO INFORMADO"
		if (nomPlaza == null) {
			nomPlaza = TXT_SIN_PLAZA;
		}
		
		return nomPlaza;
		
	}


	private String obtenerPlazaDesdeDireccion(Long idDireccion) {
		return plazaCodigoDao.obtenerNombrePlazaDeCP(idDireccion);
	}


	private Direccion obtenerDireccionPrimerTitular(Procedimiento proc) {
		Direccion resultado = null;
		if (proc != null && proc.getAsunto() != null
				&& proc.getAsunto().getContratos() != null
				&& proc.getAsunto().getContratos().iterator() != null
				&& proc.getAsunto().getContratos().iterator().next() != null) {
			Contrato contrato = proc.getAsunto().getContratos().iterator().next();
			Persona titular = null;
			List<Direccion> listaDirecciones = null;
			titular = (contrato == null ? null : contrato.getPrimerTitular());
			listaDirecciones = (titular == null ? null : titular.getDirecciones());
			resultado = (listaDirecciones == null ? null
					: (listaDirecciones.size() > 0 ? listaDirecciones.get(0) : null));
		}
		return resultado;
	}


	private List<MSVConfEnvioImpresion> obtenerListaConfiguracionImpresion(
			String tipoDocumentacion, Boolean repetirDemandado) {
		
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "packImpresion", tipoDocumentacion);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "repetirDemandado", repetirDemandado);
		Order orden = new Order(OrderType.ASC, "numOrden");
		List<MSVConfEnvioImpresion>  listaConfiguraciones = genericDao.getListOrdered(MSVConfEnvioImpresion.class, orden, filtro1, filtro2);
		
		return listaConfiguraciones;
	}


	private String sustituirCaracteresExtranyos(String nombre) {
		
		final char defCar = '-';
		final String defStr = String.valueOf(defCar);
		String resultado = nombre.toUpperCase();
		resultado = resultado.replaceAll(" ", "-");
		resultado = resultado.replaceAll("'", "-");
		resultado = resultado.replace("/", "-");
		resultado = resultado.replaceAll("À", "A").replace("Á", "A");
		resultado = resultado.replaceAll("È", "E").replace("É", "E");
		resultado = resultado.replace("Í", "I").replace("Ì", "I").replace("Ï", "I");
		resultado = resultado.replaceAll("Ò", "O").replace("Ó", "O");
		resultado = resultado.replaceAll("Ü", "U").replaceAll("Ù", "U").replaceAll("Ú", "U");
		resultado = resultado.replace("Ñ", "N");
		resultado = resultado.replace("Ç", "C");
		resultado = resultado.replaceAll("\\?", defStr).replace("\\*", defStr);
		for (int i=0 ; i<resultado.length() ; i++) {
			char c = resultado.charAt(i);
			if (Character.getType(c) == Character.OTHER_SYMBOL) {
				resultado = resultado.replace(c, defCar);
			}
		}
		return resultado;
	}


	private String extraeCasoNova(String nombreAsunto) {
		String[] arrDato = nombreAsunto.split("-");
		return (arrDato.length >= 2) ? arrDato[0] : nombreAsunto;
	}
	

	private void copiarFichero(String rutaImpresion, Date fechaImpresion, File adjunto, String nombreDoc) throws Exception {

		if (rutaImpresion == null || adjunto == null) {
			throw new IllegalArgumentException("[MSVEnvioImpresionManager.copiarFichero] : argumentos inválidos");
		}
		//Comprobar si existe el directorio, si no crearlo
		File directorioInicial = new File(rutaImpresion);
		if (!directorioInicial.exists()) {
			directorioInicial.mkdir();
		}
		
		if (!directorioInicial.canWrite()) {
			throw new Exception("[MSVEnvioImpresionManager.copiarFichero] : permisos insuficientes en el directorio " + rutaImpresion);
		}
		
		//Comprobar si existe el directorio particular del asunto, si no crearlo
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		String fechaImp = df.format(fechaImpresion);
		String nombreDirectorioAsunto = rutaImpresion + File.separator + fechaImp;
		File directorioAsunto = new File(nombreDirectorioAsunto);
		if (!directorioAsunto.exists()) {
			directorioAsunto.mkdir();
		}
		if (!directorioInicial.canWrite()) {
			throw new Exception("[MSVEnvioImpresionManager.copiarFichero] : permisos insuficientes en el directorio " + nombreDirectorioAsunto);
		}
		
		InputStream origen = new FileInputStream(adjunto);
		String nombreFicheroDestino = nombreDirectorioAsunto + File.separator + nombreDoc;
		File ficheroDestino = new File(nombreFicheroDestino);
		
		FileOutputStream destino = new FileOutputStream(ficheroDestino);
		FileUtils.copy(origen, destino);
		destino.flush();
		destino.close();
		origen.close();
		
		
	}
}
