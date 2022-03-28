package es.pfsgroup.plugin.rem.rest.api;

import java.io.File;
import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.plugin.rem.rest.dto.FileUpload;
import es.pfsgroup.plugin.rem.rest.dto.OperationResultResponse;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

public interface GestorDocumentalFotosApi {

	public enum PROPIEDAD {
		ACTIVO, AGRUPACION, SUBDIVISION
	}

	public enum TIPO {
		WEB, TECNICA, TESTIGO
	}

	public enum PRINCIPAL {
		SI, NO
	}

	public enum SITUACION {
		INTERIOR, EXTERIOR
	}
	
	public enum SUELOS {
		SI, NO
	}

	public enum PLANO {
		SI, NO
	}


	/**
	 * Indica si la conexion con el gestor documental esta activa
	 * 
	 * @return
	 */
	public boolean isActive();

	/**
	 * Sube un fichero al gestor documental
	 * 
	 * @param file
	 * @return
	 */
	public FileResponse upload(FileUpload file) throws IOException, RestClientException, HttpClientException;

	/**
	 * Sube un fichero al gestor documental
	 * 
	 * @param file
	 * @param fileToUpload
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileResponse upload(FileUpload file, java.io.File fileToUpload)
			throws IOException, RestClientException, HttpClientException;

	/**
	 * Sube un fichero al gestor documental
	 * 
	 * @param fileToUpload
	 * @param name
	 * @param propiedad
	 * @param tipo
	 * @param descripcion
	 * @param principal
	 * @param situacion
	 * @param orden
	 * @param suelos
	 * @param plano
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileResponse upload(File fileToUpload, String name, PROPIEDAD propiedad, Long idRegistro, TIPO tipo,
			String descripcion, PRINCIPAL principal, SITUACION situacion, Integer orden, SUELOS suelos, PLANO plano)
			throws IOException, RestClientException, HttpClientException;

	/**
	 * Sube un fichero al gestor documental propiedad de una subdivision
	 * 
	 * @param fileToUpload
	 * @param name
	 * @param idSubdivision
	 * @param idAgrupacion
	 * @param descripcion
	 * @return
	 * @throws IOException
	 * @throws RestClientException
	 * @throws HttpClientException
	 */
	public FileResponse uploadSubdivision(java.io.File fileToUpload, String name, Long idSubdivision,
			ActivoAgrupacion agrupacion, String descripcion, TIPO tipo,PRINCIPAL principal,SITUACION situacion, Integer orden) throws IOException, RestClientException, HttpClientException;

	/**
	 * Actualiza los metadatos de un fichero
	 * 
	 * @param idFile
	 * @param name
	 * @param propiedad
	 * @param idRegistro
	 * @param tipo
	 * @param descripcion
	 * @param principal
	 * @param situacion
	 * @param orden
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileResponse update(Long idFile, String name, TIPO tipo, String descripcion, PRINCIPAL principal,
			SITUACION situacion, Integer orden, SUELOS suelos, PLANO plano) throws IOException, RestClientException, HttpClientException;

	/**
	 * Actualiza los metadatos de un fichero
	 * 
	 * @param idFile
	 * @param orden
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileResponse upload(Long idFile, Integer orden) throws IOException, RestClientException, HttpClientException;

	/**
	 * Borra un fichero del gestor documental
	 * 
	 * @param fileId
	 * @return
	 */
	public OperationResultResponse delete(Long fileId) throws IOException, RestClientException, HttpClientException;

	/**
	 * Busca los ficheros que cumplan los criterios de busqueda
	 * 
	 * @param fileSearch
	 * @return
	 */
	public FileListResponse get(FileSearch fileSearch) throws IOException, RestClientException, HttpClientException;

	/**
	 * Busca los ficheros que cumplan los criterios de busqueda
	 * 
	 * @param propiedad
	 * @param idRegistro
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileListResponse get(PROPIEDAD propiedad, Long idRegistro)
			throws IOException, RestClientException, HttpClientException;

	/**
	 * Busca los ficheros que cumplan los criterios de busqueda
	 * 
	 * @param propiedad
	 * @param idRegistro
	 * @return
	 * @throws IOException
	 * @throws RestClientException
	 * @throws HttpClientException
	 */
	public FileListResponse get(PROPIEDAD propiedad, String idRegistro)
			throws IOException, RestClientException, HttpClientException;

	/**
	 * Busca los ficheros que cumplan los criterios de busqueda
	 * 
	 * @param fileId
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws Exception
	 */
	public FileListResponse get(Long fileId) throws IOException, RestClientException, HttpClientException;
}
