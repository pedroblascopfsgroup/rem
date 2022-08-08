package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import es.pfsgroup.commons.utils.HQLBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVActualizarGestores extends MSVExcelValidatorAbstract {

	private final String ACTIVO_NO_EXISTE = "msg.error.masivo.gestores.activo.no.existe";
	private final String AGRUPACION_NO_EXISTE = "msg.error.masivo.gestores.agrupacion.no.existe";
	private final String EXPEDIENTE_COMERCIAL_NO_EXISTE = "msg.error.masivo.gestores.expediente.no.existe";
	private final String TIPO_GESTOR_NO_EXISTE = "msg.error.masivo.gestores.tipo.gestor.no.existe";
	private final String USERNAME_NO_EXISTE = "msg.error.masivo.gestores.username.no.existe";
	private final String SOLO_UN_CAMPO_RELLENO = "msg.error.masivo.gestores.campo.unico";
	private final String USUARIO_NO_ES_TIPO_GESTOR = "msg.error.masivo.gestores.usuario.no.corresponde";
	private final String COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA = "msg.error.masivo.gestores.combinacion.no.valida";
	private final String PRIMARIO_NO_EXISTE = "msg.error.masivo.gestores.api.primario.no.existe";
	private final String PRIMARIO_IGUAL_QUE_ESPEJO = "msg.error.masivo.gestores.api.espejo.igual.api.primario";
	private final String NO_TIENE_API_PRIMARIO = "msg.error.masivo.gestores.api.espejo.activo.sin.api";
	private final String PRIMARIO_TIPO_MEDIADOR_INCORRECTO = "msg.error.masivo.gestores.api.primario.proveedor.incorrecto";
	private final String ESPEJO_TIPO_MEDIADOR_INCORRECTO = "msg.error.masivo.gestores.api.espejo.proveedor.incorrecto";
	private final String ESPEJO_NO_EXISTE = "msg.error.masivo.gestores.api.espejo.no.existe";
	private final String ACTIVO_NO_ESTA_RELLENO = "msg.error.masivo.gestores.api.cambios.activo";
	private final String FALTA_SUPERPLANIF = "msg.error.masivo.gestores.perfil.no.valido";	
	private final String VALIDAR_FILA_EXCEPTION = "msg.error.masivo.gestores.exception";
	
	private final String PROVEEDOR_BLOQUEDO_PROVINCIA = "api.bloqueado.provincia";
	private final String PROVEEDOR_BLOQUEDO_CARTERA = "api.bloqueado.cartera";
	private final String PROVEEDOR_BLOQUEDO_LN = "api.bloqueado.tipo.comercializacion";
	private final String PROVEEDOR_BLOQUEDO_ESPECIALIDAD = "api.bloqueado.especialidad";
	
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 7;	
	private final int COL_TIPO_GESTOR = 0;
	private final int COL_USERNAME = 1;
	private final int COL_NUM_ACTIVO = 2;
	private final int COL_NUM_AGRUPACION = 3;
	private final int COL_NUM_EXPEDIENTE = 4;
	private final int COL_COD_API_PRIMARIO = 5;
	private final int COL_COD_API_ESPEJO = 6;	
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizarGestores::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(FILA_CABECERA, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
				
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			generarMapaErrores();
			if (!validarFichero(exc)) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
			}
		}
		exc.cerrar();

		return dtoValidacionContenido;
	}	
	
	private boolean validarFichero(MSVHojaExcel exc) {
		final String CODIGO_MEDIADOR = "MED";
		final String PONER_NULL_A_APIS = "0";
		boolean esCorrecto = true;

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				String tipoGestor = exc.dameCelda(fila, COL_TIPO_GESTOR);
				String username = exc.dameCelda(fila, COL_USERNAME);
				String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO);
				String numAgrupacion = exc.dameCelda(fila, COL_NUM_AGRUPACION);
				String numExpediente = exc.dameCelda(fila, COL_NUM_EXPEDIENTE);
				String codApiPrimario = exc.dameCelda(fila, COL_COD_API_PRIMARIO);
				String codApiEspejo = exc.dameCelda(fila, COL_COD_API_ESPEJO);

				if (!isSuperPlanif() && (!Checks.esNulo(codApiPrimario) || !Checks.esNulo(codApiEspejo))) {
					mapaErrores.get(messageServices.getMessage(FALTA_SUPERPLANIF)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(numActivo) && !particularValidator.existeActivo(numActivo)) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(numAgrupacion) && !particularValidator.existeAgrupacion(numAgrupacion)) {
					mapaErrores.get(messageServices.getMessage(AGRUPACION_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(numExpediente) && !particularValidator.existeExpedienteComercial(numExpediente)) {
					mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}

				if (CODIGO_MEDIADOR.equals(tipoGestor)) {
					if (!Checks.esNulo(numActivo)) {
						String codMediadorPrimario = codApiPrimario;
						String codMediadorEspejo = codApiEspejo;

						if (Checks.esNulo(codMediadorPrimario) && !Checks.esNulo(codMediadorEspejo)
								&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)) {
							codMediadorPrimario = particularValidator.getCodigoMediadorPrimarioByActivo(numActivo);
							
							if (Checks.esNulo(codMediadorPrimario)) {
								mapaErrores.get(messageServices.getMessage(NO_TIENE_API_PRIMARIO)).add(fila);
								esCorrecto = false;
							}
						} else if (Checks.esNulo(codMediadorEspejo) && !Checks.esNulo(codMediadorPrimario)
								&& !PONER_NULL_A_APIS.equals(codMediadorPrimario)) {
							codMediadorEspejo = particularValidator.getCodigoMediadorEspejoByActivo(numActivo);
						}


						if (!Checks.esNulo(codMediadorPrimario) && !Checks.esNulo(codMediadorEspejo)
								&& !PONER_NULL_A_APIS.equals(codMediadorPrimario)
								&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)
								&& codMediadorEspejo.equals(codMediadorPrimario)) {
							mapaErrores.get(messageServices.getMessage(PRIMARIO_IGUAL_QUE_ESPEJO)).add(fila);
							esCorrecto = false;
						}
					}

					if (!Checks.esNulo(codApiPrimario) && particularValidator.mediadorExisteVigente(codApiPrimario)
							&& !Checks.esNulo(numActivo) && !particularValidator.esTipoMediadorCorrecto(codApiPrimario)
							&& !PONER_NULL_A_APIS.equals(codApiPrimario)) {
						mapaErrores.get(messageServices.getMessage(PRIMARIO_TIPO_MEDIADOR_INCORRECTO)).add(fila);
						esCorrecto = false;
					}

					if (!Checks.esNulo(codApiEspejo) && particularValidator.mediadorExisteVigente(codApiEspejo)
							&& !Checks.esNulo(numActivo) && !particularValidator.esTipoMediadorCorrecto(codApiEspejo)
							&& !PONER_NULL_A_APIS.equals(codApiEspejo)) {
						mapaErrores.get(messageServices.getMessage(ESPEJO_TIPO_MEDIADOR_INCORRECTO)).add(fila);
						esCorrecto = false;
					}

				} else {

					if (!particularValidator.existeTipoGestor(tipoGestor)) {
						mapaErrores.get(messageServices.getMessage(TIPO_GESTOR_NO_EXISTE)).add(fila);
						esCorrecto = false;
					}
					if (!particularValidator.existeUsuario(username)) {
						mapaErrores.get(messageServices.getMessage(USERNAME_NO_EXISTE)).add(fila);
						esCorrecto = false;
					}

					if (!particularValidator.usuarioEsTipoGestor(username, tipoGestor)) {
						mapaErrores.get(messageServices.getMessage(USUARIO_NO_ES_TIPO_GESTOR)).add(fila);
						esCorrecto = false;
					}

					if (!particularValidator.combinacionGestorCarteraAcagexValida(tipoGestor, numActivo, numAgrupacion, numExpediente)) {
						mapaErrores.get(messageServices.getMessage(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA)).add(fila);
						esCorrecto = false;
					}

				}

				if ((!Checks.esNulo(numActivo) && (!Checks.esNulo(numAgrupacion) || !Checks.esNulo(numExpediente)))
						|| (!Checks.esNulo(numAgrupacion) && !Checks.esNulo(numExpediente))
						|| (Checks.esNulo(numAgrupacion) && Checks.esNulo(numExpediente) && Checks.esNulo(numActivo))) {
					mapaErrores.get(messageServices.getMessage(SOLO_UN_CAMPO_RELLENO)).add(fila);
					esCorrecto = false;
				}

				if (Checks.esNulo(numActivo) && (!Checks.esNulo(codApiPrimario) || !Checks.esNulo(codApiEspejo))) {
					mapaErrores.get(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(codApiPrimario) && !PONER_NULL_A_APIS.equals(codApiPrimario)
						&& !particularValidator.mediadorExisteVigente(codApiPrimario)) {
					mapaErrores.get(messageServices.getMessage(PRIMARIO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if (!Checks.esNulo(codApiEspejo) && !PONER_NULL_A_APIS.equals(codApiEspejo)
						&& !particularValidator.mediadorExisteVigente(codApiEspejo)) {
					mapaErrores.get(messageServices.getMessage(ESPEJO_NO_EXISTE)).add(fila);
					esCorrecto = false;
				}
				if(!Checks.esNulo(codApiEspejo) && !Checks.esNulo(numActivo)) {
					if(particularValidator.apiBloqueadoProvincia(numActivo, codApiEspejo)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_PROVINCIA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoCartera(numActivo, codApiEspejo)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_CARTERA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoLineaDeNegocio(numActivo, codApiEspejo)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_LN)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoEspecialidad(numActivo, codApiEspejo)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_ESPECIALIDAD)).add(fila);
						esCorrecto = false;
					}
				}
				
				if(!Checks.esNulo(codApiPrimario) && !Checks.esNulo(numActivo)) {
					if(particularValidator.apiBloqueadoProvincia(numActivo, codApiPrimario)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_PROVINCIA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoCartera(numActivo, codApiPrimario)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_CARTERA)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoLineaDeNegocio(numActivo, codApiPrimario)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_LN)).add(fila);
						esCorrecto = false;
					}
					if(particularValidator.apiBloqueadoEspecialidad(numActivo, codApiPrimario)) {
						mapaErrores.get(messageServices.getMessage(PROVEEDOR_BLOQUEDO_ESPECIALIDAD)).add(fila);
						esCorrecto = false;
					}
					
				}

			} catch (Exception e) {
				mapaErrores.get(messageServices.getMessage(VALIDAR_FILA_EXCEPTION)).add(fila);
				esCorrecto = false;
				logger.error(e.getMessage());
			}
		}

		return esCorrecto;
	}

	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * 
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if (compositeValidators != null) {
			List<MSVMultiColumnValidator> listaValidadores = compositeValidators.getValidatorForColumns(listaCabeceras);
			if (listaValidadores != null) {
				MSVValidationResult result = validationRunner.runCompositeValidation(listaValidadores, mapaDatos);
				resultado.setValido(result.isValid());
				resultado.setErroresFila(result.getErrorMessage());
			}
		}
		return resultado;
	}

	private boolean isSuperPlanif() {
		final String USUARIOSUPERPLANIF = "SUPERPLANIF";
		final String USUARIOSUPER = "HAYASUPER";	
		Perfil perfilSuperPlanif = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPERPLANIF));
		Perfil perfilSuper = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPER));
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		ZonaUsuarioPerfil usuarioPerfil = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilSuperPlanif),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		ZonaUsuarioPerfil usuarioSuper = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilSuper),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		return usuarioPerfil != null || usuarioSuper != null;
	}
	
	private void generarMapaErrores() {
		mapaErrores = new HashMap<String, List<Integer>>();
		mapaErrores.put(messageServices.getMessage(FALTA_SUPERPLANIF), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(AGRUPACION_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(TIPO_GESTOR_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(USERNAME_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(SOLO_UN_CAMPO_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(USUARIO_NO_ES_TIPO_GESTOR), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ACTIVO_NO_ESTA_RELLENO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PRIMARIO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESPEJO_NO_EXISTE), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PRIMARIO_IGUAL_QUE_ESPEJO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(NO_TIENE_API_PRIMARIO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PRIMARIO_TIPO_MEDIADOR_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(ESPEJO_TIPO_MEDIADOR_INCORRECTO), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(VALIDAR_FILA_EXCEPTION), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_PROVINCIA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_CARTERA), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_LN), new ArrayList<Integer>());
		mapaErrores.put(messageServices.getMessage(PROVEEDOR_BLOQUEDO_ESPECIALIDAD), new ArrayList<Integer>());
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
