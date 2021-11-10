package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import es.capgemini.pfs.diccionarios.DictionaryDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.OfertaGencatApi;
import es.pfsgroup.plugin.rem.gencat.NotificacionesGencatManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Component
public class MSVActualizadorCargaMasivaSancion extends AbstractMSVActualizador implements MSVLiberator {

	protected static final Log logger = LogFactory.getLog(MSVActualizadorCargaMasivaSancion.class);

	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;

	@Autowired
	private OfertaGencatApi ofertaGencatApi;

	@Autowired
	protected ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private DictionaryDao dictionaryDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private NotificacionesGencatManager notificacionesGencat;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES;
	}

	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	private static final int POSICION_COLUMNA_FECHA_SANCION = 1;
	private static final int POSICION_COLUMNA_RESULTADO_SANCION = 2;
	private static final int POSICION_COLUMNA_NIF = 3;
	private static final int POSICION_COLUMNA_NOMBRE = 4;

	private static final String COD_EJERCE = "Ejerce";
	private static final String COD_NO_EJERCE = "No ejerce";

	public static final String DD_TIPO_DOCUMENTO_CODIGO_NIF = "15";
	private SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Activo activo = null;
			activo = activoApi.getByNumActivo(Long.valueOf(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO)));
			List<ComunicacionGencat> list = new ArrayList<ComunicacionGencat>();
			
			ExpedienteComercial expediente = null;
			
			if (!Checks.estaVacio(activo.getOfertas())) {
				for (ActivoOferta activoOferta : activo.getOfertas()) {
					if (!Checks.esNulo(activoOferta.getPrimaryKey().getOferta()) && DDEstadoOferta.CODIGO_ACEPTADA
							.equals(activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
								activoOferta.getPrimaryKey().getOferta().getId());
						expediente = genericDao.get(ExpedienteComercial.class, filtro);
						
						break;
					}
				}
			}
		
			if (COD_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {

				if (!Checks.esNulo(activo)) {
					Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

					Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");

					// Datos comunicación
					List<ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class,
							orderByFechaCrear, filtroIdActivo, filtroBorrado);

					if (!Checks.esNulo(resultComunicacion) && !resultComunicacion.isEmpty()) {
						list.add(resultComunicacion.get(0));
					}
				}
				if (Checks.esNulo(list) || list.isEmpty()) {
					return getNotFound(fila, true);
				}
			} else if (COD_NO_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {

				ComunicacionGencat comunicacionGencat = comunicacionGencatApi
						.getByNumActivoHaya(Long.valueOf(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO)));

				list.add(comunicacionGencat);

				if (Checks.esNulo(list) || list.isEmpty()) {
					return getNotFound(fila, false);
				}
			}

			for (int i = 0; i < list.size(); i++) {

				ComunicacionGencat tmp = list.get(i);
				tmp.setFechaSancion(new SimpleDateFormat(DateFormat.DATE_FORMAT)
						.parse(exc.dameCelda(fila, POSICION_COLUMNA_FECHA_SANCION)));
				if (COD_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {

					if (!Checks.esNulo(exc.dameCelda(fila, POSICION_COLUMNA_NIF))
							&& !Checks.esNulo(exc.dameCelda(fila, POSICION_COLUMNA_NOMBRE))) {
						tmp.setNuevoCompradorNif(exc.dameCelda(fila, POSICION_COLUMNA_NIF));
						tmp.setNuevoCompradorNombre(exc.dameCelda(fila, POSICION_COLUMNA_NOMBRE));
						tmp.setSancion((DDSancionGencat) dictionaryDao.getByCode(DDSancionGencat.class,
								DDSancionGencat.COD_EJERCE));
						tmp.setEstadoComunicacion((DDEstadoComunicacionGencat) dictionaryDao.getByCode(
								DDEstadoComunicacionGencat.class, DDEstadoComunicacionGencat.COD_SANCIONADO));

						OfertaGencat ofertaGencat = ofertaGencatApi.getOfertaByIdComunicacionGencat(tmp.getId());

						if (!Checks.esNulo(ofertaGencat)) {
							ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofertaGencat.getOferta());
							if (!Checks.esNulo(exp)) {
								try {
									gencatApi.crearNuevaOfertaGENCAT(exp, tmp);
								} catch (Exception e) {
									logger.error("Error en MSVActualizadorCargaMasivaSancion", e);
									getNotCreateOfertaGENCAT(fila, true);
								}

							} else {
								getOfertaExpedienteNull(fila, false);
							}
						} else {
							getOfertaExpedienteNull(fila, true);
						}

					} else {
						Boolean posicionNif = Checks.esNulo(exc.dameCelda(fila, POSICION_COLUMNA_NIF));
						Boolean posicionNombre = Checks.esNulo(exc.dameCelda(fila, POSICION_COLUMNA_NOMBRE));
						getIsNullNameOrNifValues(fila, posicionNombre, posicionNif);
					}

				} else if (COD_NO_EJERCE.equals(exc.dameCelda(fila, POSICION_COLUMNA_RESULTADO_SANCION))) {
					tmp.setSancion((DDSancionGencat) dictionaryDao.getByCode(DDSancionGencat.class,
							DDSancionGencat.COD_NO_EJERCE));
					tmp.setEstadoComunicacion((DDEstadoComunicacionGencat) dictionaryDao
							.getByCode(DDEstadoComunicacionGencat.class, DDEstadoComunicacionGencat.COD_SANCIONADO));
				}

				if (!Checks.esNulo(activo)) {
					DtoGencatSave gencatDto = new DtoGencatSave();
					gencatDto.setFechaSancion(dateformat.format(tmp.getFechaSancion()));
					gencatDto.setSancion(tmp.getSancion().getDescripcion());
					notificacionesGencat.sendMailNotificacionSancionGencat(gencatDto, activo, tmp.getSancion(), expediente);
					darDeBajaAgrupacionRestringida(activo);
				}
				comunicacionGencatApi.saveOrUpdate(tmp);
			}
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

	private ResultadoProcesarFila getNotFound(int fila, boolean nif) {

		String error = "numero de activo";

		if (nif) {
			error = "NIF";
		}

		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc("No se ha encontrado ningún registro con el " + error + " introducido");
		resultado.setCorrecto(false);

		return resultado;

	}

	private ResultadoProcesarFila getIsNullNameOrNifValues(int fila, boolean nombre, boolean nif) {
		String error = "";

		if (nombre && !nif)
			error = "El campo NIF es obligatorio";
		else if (!nombre && nif)
			error = " El campo nombre es obligatorio";
		else
			error = "El campo nombre y NIF son obligatorios";

		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc(error);
		resultado.setCorrecto(false);

		return resultado;

	}

	private ResultadoProcesarFila getOfertaExpedienteNull(int fila, boolean oferta) {
		String error = "";

		if (oferta)
			error = "No se ha encontrado una oferta asociada a este activo";
		else
			error = "No se ha encontrado ningún expediente asociado a este activo";
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc(error);
		resultado.setCorrecto(false);

		return resultado;

	}

	private ResultadoProcesarFila getNotCreateOfertaGENCAT(int fila, boolean ofertaGENCAT) {
		String error = "";

		if (ofertaGENCAT)
			error = "No se ha podido crear la nueva oferta para este activo";
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc(error);
		resultado.setCorrecto(false);

		return resultado;

	}

	private void darDeBajaAgrupacionRestringida(Activo activo) {

		List<ActivoAgrupacionActivo> listaAgrupaciones = activo.getAgrupaciones();

		if (!listaAgrupaciones.isEmpty()) {

			for (ActivoAgrupacionActivo agrupacion : listaAgrupaciones) {
				DDTipoAgrupacion tipoAgrupacion = agrupacion.getAgrupacion().getTipoAgrupacion();
				String codigo = tipoAgrupacion.getCodigo();

				if (codigo.equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
						|| codigo.equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)
						|| codigo.equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {

					try {
						ActivoAgrupacion activoAgrupacion = agrupacion.getAgrupacion();
						activoAgrupacion.setFechaBaja(new Date());

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
	}

}
