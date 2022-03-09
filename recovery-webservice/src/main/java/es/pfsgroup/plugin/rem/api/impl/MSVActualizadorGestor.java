package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInformeComercialHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRolMediador;

@Component
public class MSVActualizadorGestor extends AbstractMSVActualizador implements MSVLiberator {

	private final int COL_TIPO_GESTOR = 0;
	private final int COL_USERNAME = 1;
	private final int COL_NUM_ACTIVO = 2;
	private final int COL_NUM_AGRUPACION = 3;
	private final int COL_NUM_EXPEDIENTE = 4;
	private final int COL_COD_API_PRIMARIO = 5;
	private final int COL_COD_API_ESPEJO = 6;	
	private final String PONER_NULL_A_APIS = "0";
	
	protected static final Log logger = LogFactory.getLog(MSVActualizadorGestor.class);	

	
	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GESTORES;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			String gestor = exc.dameCelda(fila, COL_TIPO_GESTOR); 				
			String username = exc.dameCelda(fila, COL_USERNAME);				
			String numActivo = exc.dameCelda(fila, COL_NUM_ACTIVO);
			String numAgrupacion = exc.dameCelda(fila, COL_NUM_AGRUPACION);
			String numExpediente = exc.dameCelda(fila, COL_NUM_EXPEDIENTE);
			String codApiPrimario = exc.dameCelda(fila, COL_COD_API_PRIMARIO);
			String codApiEspejo = exc.dameCelda(fila, COL_COD_API_ESPEJO);			
			
			Activo activo = Checks.esNulo(numActivo) ? null : activoApi.getByNumActivo(Long.parseLong(numActivo));
			ExpedienteComercial expediente = Checks.esNulo(numExpediente) ? null : expedienteComercialApi.findOneByNumExpediente(Long.parseLong(numExpediente));
			ActivoAgrupacion agrupacion = null;
			Usuario usuario = null;
			EXTDDTipoGestor tipoGestor = null;
			
			if (!Checks.esNulo(numAgrupacion)) {
				Long idAgrupacion = activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(Long.parseLong(numAgrupacion));
				agrupacion = activoAgrupacionApi.get(idAgrupacion);
			}

			if (!Checks.esNulo(gestor)) {
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestor);
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor, filtroBorrado);
			}

			if (!Checks.esNulo(username)) {
				Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "username", username);
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				usuario = genericDao.get(Usuario.class, filtroUsuario, filtroBorrado);
			}
			
			if (activo != null) {
				// Insert y/o Update API Primario
				if (!Checks.esNulo(codApiPrimario) && !PONER_NULL_A_APIS.equals(codApiPrimario)) {
					Filter codProveedorFilter = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.valueOf(codApiPrimario));
					ActivoProveedor apiPrimario = genericDao.get(ActivoProveedor.class, codProveedorFilter);

					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setMediadorInforme(apiPrimario);
						infoComercial.setActivo(activo);
						infoComercial.setAuditoria(Auditoria.getNewInstance());
						activo.setInfoComercial(infoComercial);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorInforme(apiPrimario);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}

					// Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					Filter borradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter, borradoFilter);

					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					}

					ActivoInformeComercialHistoricoMediador nuevoHistoricoMediadorPrimario = new ActivoInformeComercialHistoricoMediador();
					nuevoHistoricoMediadorPrimario.setActivo(activo);
					nuevoHistoricoMediadorPrimario.setMediadorInforme(apiPrimario);
					nuevoHistoricoMediadorPrimario.setFechaDesde(new Date());
					nuevoHistoricoMediadorPrimario.setAuditoria(Auditoria.getNewInstance());
					Filter trlFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					DDTipoRolMediador tipoRolMediador = genericDao.get(DDTipoRolMediador.class, trlFilter);
					nuevoHistoricoMediadorPrimario.setTipoRolMediador(tipoRolMediador);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, nuevoHistoricoMediadorPrimario);

					// Poner a null API Primario
				} else if (!Checks.esNulo(codApiPrimario) && PONER_NULL_A_APIS.equals(codApiPrimario)) {
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setActivo(activo);
						infoComercial.setAuditoria(Auditoria.getNewInstance());
						activo.setInfoComercial(infoComercial);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorInforme(null);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}

					// Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					Filter borradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter, borradoFilter);

					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					}
				}

				// Insert y/o Update API Espejo
				if (!Checks.esNulo(codApiEspejo) && !PONER_NULL_A_APIS.equals(codApiEspejo)) {
					Filter codProveedorFilter = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.valueOf(codApiEspejo));
					ActivoProveedor apiEspejo = genericDao.get(ActivoProveedor.class, codProveedorFilter);

					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setMediadorEspejo(apiEspejo);
						infoComercial.setActivo(activo);
						infoComercial.setAuditoria(Auditoria.getNewInstance());
						activo.setInfoComercial(infoComercial);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorEspejo(apiEspejo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}

					// Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					Filter borradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter, borradoFilter);

					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					}

					ActivoInformeComercialHistoricoMediador nuevoHistoricoMediadorPrimario = new ActivoInformeComercialHistoricoMediador();
					nuevoHistoricoMediadorPrimario.setActivo(activo);
					nuevoHistoricoMediadorPrimario.setMediadorInforme(apiEspejo);
					nuevoHistoricoMediadorPrimario.setFechaDesde(new Date());
					nuevoHistoricoMediadorPrimario.setAuditoria(Auditoria.getNewInstance());
					Filter trlFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					DDTipoRolMediador tipoRolMediador = genericDao.get(DDTipoRolMediador.class, trlFilter);
					nuevoHistoricoMediadorPrimario.setTipoRolMediador(tipoRolMediador);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, nuevoHistoricoMediadorPrimario);

					// Poner a null API Espejo
				} else if (!Checks.esNulo(codApiEspejo) && PONER_NULL_A_APIS.equals(codApiEspejo)) {
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setActivo(activo);
						infoComercial.setAuditoria(Auditoria.getNewInstance());
						activo.setInfoComercial(infoComercial);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorEspejo(null);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}

					// Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					Filter borradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter, borradoFilter);

					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					}
				}
			}
			
			if (tipoGestor != null && !Checks.esNulo(usuario)) {
				if (!Checks.esNulo(activo)) {
					GestorEntidadDto dto = new GestorEntidadDto();
					dto.setIdEntidad(activo.getId());
					dto.setIdUsuario(usuario.getId());
					dto.setIdTipoGestor(tipoGestor.getId());
					activoAdapter.insertarGestorAdicional(dto);
				} else if (!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getTipoAgrupacion())
						&& DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())
						&& tipoGestor.getCodigo().equals(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL)) {

					ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;
					agrupacionTemp.setUsuarioGestorComercial(usuario);
					activoAgrupacionApi.saveOrUpdate(agrupacionTemp);
				} else if (expediente != null) {
					GestorEntidadDto dto = new GestorEntidadDto();
					dto.setIdEntidad(expediente.getId());
					dto.setIdUsuario(usuario.getId());
					dto.setIdTipoGestor(tipoGestor.getId());
					expedienteComercialApi.insertarGestorAdicional(dto);
				} else {
					throw new ParseException("Error al procesar la fila " + fila, 1);
				}
			}

		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

}
