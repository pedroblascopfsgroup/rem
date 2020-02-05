package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

	public static final String ACTIVO_NO_EXISTE = "El activo no existe.";
	public static final String AGRUPACION_NO_EXISTE = "La agrupacion no existe.";
	public static final String EXPEDIENTE_COMERCIAL_NO_EXISTE = "El expediente comercial no existe.";
	public static final String TIPO_GESTOR_NO_EXISTE = "El tipo de gestor no existe.";
	public static final String USERNAME_NO_EXISTE = "El username no existe.";
	public static final String SOLO_UN_CAMPO_RELLENO = "Solo debe rellenar un campo: ACTIVO, AGRUPACION o EXPEDIENTE.";
	public static final String USUARIO_NO_ES_TIPO_GESTOR = "El usuario no corresponde con el Tipo de gestor";
	public static final String COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA = "Combinación tipo de gestor- cartera - agrupación/activo/expediente invalida";
	public static final String PRIMARIO_NO_EXISTE = "El API Primario introducido no existe o esta dado de baja en REM";
	public static final String CODIGO_MEDIADOR = "MED";
	public static final String PONER_NULL_A_APIS = "0";
	public static final String PRIMARIO_IGUAL_QUE_ESPEJO = "El API espejo no puede ser igual que el API primario";
	public static final String NO_TIENE_API_PRIMARIO = "No puedes asignar API espejo a un activo sin API primario";
	public static final String PRIMARIO_TIPO_MEDIADOR_INCORRECTO = "Tipo de proveedor DEL API primario incorrecto (Mediador o Fuerza venta directa)";
	public static final String ESPEJO_TIPO_MEDIADOR_INCORRECTO = "Tipo de proveedor DEL API espejo incorrecto (Mediador o Fuerza venta directa)";
	public static final String ESPEJO_NO_EXISTE = "El API Espejo introducido no existe o esta dado de baja en REM";
	public static final String ACTIVO_NO_ESTA_RELLENO = "Los cambios de API Primario y API Espejo solo se aplican a nivel de activo";
	public static final String FALTA_SUPERPLANIF = "Debe tener el perfil 'Superusuario de Planificación Comercial' para informar  las columnas API espejo y primario";

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

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

	public static final String USUARIOSUPERPLANIF = "SUPERPLANIF";
	public static final String USUARIOSUPER = "HAYASUPER";

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null) {
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory
				.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory
				.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators,
				compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(FALTA_SUPERPLANIF, isSuperPlanifRequerido(exc));
			mapaErrores.put(ACTIVO_NO_EXISTE, isActiveNotExistsRows(exc));
			mapaErrores.put(AGRUPACION_NO_EXISTE, isAgrupacionNotExistsRows(exc));
			mapaErrores.put(EXPEDIENTE_COMERCIAL_NO_EXISTE, isExpedienteNotExistsRows(exc));
			mapaErrores.put(TIPO_GESTOR_NO_EXISTE, isTipoGestorNotExistsRows(exc));
			mapaErrores.put(USERNAME_NO_EXISTE, isUsuarioNotExistsRows(exc));
			mapaErrores.put(SOLO_UN_CAMPO_RELLENO, soloUnCampoRelleno(exc));
			mapaErrores.put(USUARIO_NO_ES_TIPO_GESTOR, usuarioEsTipoGestor(exc));
			mapaErrores.put(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA, combinacionGestorCarteraAcagexValida(exc));
			mapaErrores.put(ACTIVO_NO_ESTA_RELLENO, activoNoEstaRelleno(exc));
			mapaErrores.put(PRIMARIO_NO_EXISTE, apiPrimarioExiste(exc));
			mapaErrores.put(ESPEJO_NO_EXISTE, apiEspejoExiste(exc));
			mapaErrores.put(PRIMARIO_IGUAL_QUE_ESPEJO, espejoIgualQuePrimario(exc));
			mapaErrores.put(NO_TIENE_API_PRIMARIO, tieneMediadorPrimario(exc));
			mapaErrores.put(PRIMARIO_TIPO_MEDIADOR_INCORRECTO, esTipoMediadorPrimarioCorrecto(exc));
			mapaErrores.put(ESPEJO_TIPO_MEDIADOR_INCORRECTO, esTipoMediadorEspejoCorrecto(exc));

			if (!mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty() || !mapaErrores.get(AGRUPACION_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(FALTA_SUPERPLANIF).isEmpty()
					|| !mapaErrores.get(EXPEDIENTE_COMERCIAL_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(TIPO_GESTOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(USERNAME_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(SOLO_UN_CAMPO_RELLENO).isEmpty()
					|| !mapaErrores.get(USUARIO_NO_ES_TIPO_GESTOR).isEmpty()
					|| !mapaErrores.get(COMBINACION_GESTOR_CARTERA_ACAGEX_INVALIDA).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_ESTA_RELLENO).isEmpty()
					|| !mapaErrores.get(PRIMARIO_NO_EXISTE).isEmpty() || !mapaErrores.get(ESPEJO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(PRIMARIO_IGUAL_QUE_ESPEJO).isEmpty()
					|| !mapaErrores.get(NO_TIENE_API_PRIMARIO).isEmpty()
					|| !mapaErrores.get(PRIMARIO_TIPO_MEDIADOR_INCORRECTO).isEmpty()
					|| !mapaErrores.get(ESPEJO_TIPO_MEDIADOR_INCORRECTO).isEmpty()) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
			}
		}
		exc.cerrar();

		return dtoValidacionContenido;
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

	private List<Integer> isSuperPlanifRequerido(MSVHojaExcel exc)
			throws IOException, ParseException {
		List<Integer> listaFilas = new ArrayList<Integer>();
		if (!isSuperPlanif()) {
			for (int i = 1; i < this.numFilasHoja; i++) {
				String apiPrimario = exc.dameCelda(i, 5);
				String apiEspejo = exc.dameCelda(i, 6);
				if ((apiPrimario != null && !apiPrimario.isEmpty()) || (apiEspejo != null && !apiEspejo.isEmpty())) {
					listaFilas.add(i);
				}

			}
		}

		return listaFilas;
	}

	private boolean isSuperPlanif() {
		Perfil perfilSuperPlanif = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPERPLANIF));
		Perfil perfilSuper = genericDao.get(Perfil.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", USUARIOSUPER));
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		ZonaUsuarioPerfil usuarioPerfil = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilSuperPlanif));
		ZonaUsuarioPerfil usuarioSuper = genericDao.get(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario", usu),
				genericDao.createFilter(FilterType.EQUALS, "perfil", perfilSuper));

		return usuarioPerfil != null || usuarioSuper != null;
	}

	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, 2)) && !particularValidator.existeActivo(exc.dameCelda(i, 2)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}
		return listaFilas;
	}

	private List<Integer> isExpedienteNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, 4))
							&& !particularValidator.existeExpedienteComercial(exc.dameCelda(i, 4)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}
		return listaFilas;
	}

	private List<Integer> isAgrupacionNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!Checks.esNulo(exc.dameCelda(i, 3))
							&& !particularValidator.existeAgrupacion(exc.dameCelda(i, 3)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}
		return listaFilas;
	}

	private List<Integer> isTipoGestorNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (!CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0))) {
						if (!particularValidator.existeTipoGestor(exc.dameCelda(i, 0)))
							listaFilas.add(i);
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}
		return listaFilas;
	}

	private List<Integer> isUsuarioNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String username = exc.dameCelda(i, 1);
					if (!CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0))) {
						if (!particularValidator.existeUsuario(username))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}
		return listaFilas;
	}

	private List<Integer> soloUnCampoRelleno(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String numActivo = exc.dameCelda(i, 2);
					String numAgrupacion = exc.dameCelda(i, 3);
					String numExpediente = exc.dameCelda(i, 4);

					if ((!Checks.esNulo(numActivo) && (!Checks.esNulo(numAgrupacion) || !Checks.esNulo(numExpediente)))
							|| (!Checks.esNulo(numAgrupacion)
									&& (!Checks.esNulo(numActivo) || !Checks.esNulo(numExpediente)))
							|| (!Checks.esNulo(numExpediente)
									&& (!Checks.esNulo(numActivo) || !Checks.esNulo(numAgrupacion)))
							|| (Checks.esNulo(numAgrupacion) && Checks.esNulo(numExpediente)
									&& Checks.esNulo(numActivo))) {

						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;

	}

	private List<Integer> usuarioEsTipoGestor(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String codigoTipoGestor = exc.dameCelda(i, 0);
					String username = exc.dameCelda(i, 1);
					if (!CODIGO_MEDIADOR.equals(codigoTipoGestor)) {
						if (!Checks.esNulo(codigoTipoGestor) || !Checks.esNulo(username)) {
							if (!particularValidator.usuarioEsTipoGestor(username, codigoTipoGestor)) {
								listaFilas.add(i);
							}
						}
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> combinacionGestorCarteraAcagexValida(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String numActivo = exc.dameCelda(i, 2);
					String numAgrupacion = exc.dameCelda(i, 3);
					String numExpediente = exc.dameCelda(i, 4);
					String codigoTipoGestor = exc.dameCelda(i, 0);

					if ((!CODIGO_MEDIADOR.equals(codigoTipoGestor.toUpperCase())) && (!Checks.esNulo(numAgrupacion)
							|| !Checks.esNulo(numExpediente) || !Checks.esNulo(numActivo))) {
						if (!particularValidator.combinacionGestorCarteraAcagexValida(codigoTipoGestor, numActivo,
								numAgrupacion, numExpediente)) {
							listaFilas.add(i);
						}
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;

	}

	private List<Integer> apiPrimarioExiste(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String codMediador = exc.dameCelda(i, 5);

					if (!Checks.esNulo(codMediador) && !PONER_NULL_A_APIS.equals(codMediador)
							&& !particularValidator.mediadorExisteVigente(codMediador)) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;

	}

	private List<Integer> apiEspejoExiste(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String codMediador = exc.dameCelda(i, 6);

					if (!Checks.esNulo(codMediador) && !PONER_NULL_A_APIS.equals(codMediador)
							&& !particularValidator.mediadorExisteVigente(codMediador)) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> espejoIgualQuePrimario(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0))) {
						String numActivo = exc.dameCelda(i, 2);
						String codMediadorPrimario = exc.dameCelda(i, 5);
						String codMediadorEspejo = exc.dameCelda(i, 6);

						if (!Checks.esNulo(numActivo)) {
							if (Checks.esNulo(codMediadorPrimario) && !Checks.esNulo(codMediadorEspejo)
									&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)) {
								codMediadorPrimario = particularValidator.getCodigoMediadorPrimarioByActivo(numActivo);
							} else if (Checks.esNulo(codMediadorEspejo) && !Checks.esNulo(codMediadorPrimario)
									&& !PONER_NULL_A_APIS.equals(codMediadorPrimario)) {
								codMediadorEspejo = particularValidator.getCodigoMediadorEspejoByActivo(numActivo);
							}

							if (!Checks.esNulo(codMediadorPrimario) && !Checks.esNulo(codMediadorEspejo)
									&& !PONER_NULL_A_APIS.equals(codMediadorPrimario)
									&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)) {
								if (codMediadorEspejo.equals(codMediadorPrimario)) {
									listaFilas.add(i);
								}
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> tieneMediadorPrimario(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					if (CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0))) {
						String numActivo = exc.dameCelda(i, 2);
						String codMediadorPrimario = exc.dameCelda(i, 5);
						String codMediadorEspejo = exc.dameCelda(i, 6);

						if (!Checks.esNulo(numActivo)) {
							if (Checks.esNulo(codMediadorPrimario) && !Checks.esNulo(codMediadorEspejo)
									&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)) {
								if (Checks.esNulo(particularValidator.getCodigoMediadorPrimarioByActivo(numActivo))) {
									listaFilas.add(i);
								}
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> esTipoMediadorPrimarioCorrecto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String numActivo = exc.dameCelda(i, 2);
					String codMediadorPrimario = exc.dameCelda(i, 5);
					if (CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0)) && !Checks.esNulo(codMediadorPrimario)
							&& particularValidator.mediadorExisteVigente(codMediadorPrimario)
							&& !Checks.esNulo(numActivo)
							&& !particularValidator.esTipoMediadorCorrecto(codMediadorPrimario)
							&& !PONER_NULL_A_APIS.equals(codMediadorPrimario)) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> esTipoMediadorEspejoCorrecto(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String numActivo = exc.dameCelda(i, 2);
					String codMediadorEspejo = exc.dameCelda(i, 6);
					if (CODIGO_MEDIADOR.equals(exc.dameCelda(i, 0)) && !Checks.esNulo(codMediadorEspejo)
							&& particularValidator.mediadorExisteVigente(codMediadorEspejo) && !Checks.esNulo(numActivo)
							&& !particularValidator.esTipoMediadorCorrecto(codMediadorEspejo)
							&& !PONER_NULL_A_APIS.equals(codMediadorEspejo)) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

	private List<Integer> activoNoEstaRelleno(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		try {
			for (int i = 1; i < this.numFilasHoja; i++) {
				try {
					String numActivo = exc.dameCelda(i, 2);
					String codMediadorApi = exc.dameCelda(i, 5);
					String codMediadorEspejo = exc.dameCelda(i, 6);

					if (Checks.esNulo(numActivo)
							&& (!Checks.esNulo(codMediadorApi) || !Checks.esNulo(codMediadorEspejo))) {
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e.getMessage(), e);
		}

		return listaFilas;
	}

}
