package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVActualizarGestores;
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
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;


@Component
public class MSVActualizadorGestor extends AbstractMSVActualizador implements MSVLiberator {

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
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo= null;
		ActivoAgrupacion agrupacion= null;
		ExpedienteComercial expediente= null;
		Usuario usuario= null;
		EXTDDTipoGestor tipoGestor= null;
		DtoHistoricoMediador dtoMediador = null;
		
		if(!Checks.esNulo(exc.dameCelda(fila, 2))){
			activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 2)));
		}
		if(!Checks.esNulo(exc.dameCelda(fila, 3))){
			Long idAgrupacion= activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(Long.parseLong(exc.dameCelda(fila, 3)));
			agrupacion= activoAgrupacionApi.get(idAgrupacion);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, 4))){
			expediente= expedienteComercialApi.findOneByNumExpediente(Long.parseLong(exc.dameCelda(fila, 4)));
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, 0)) && !MSVActualizarGestores.GESTOR_MEDIADOR.equals(exc.dameCelda(fila, 0))){					
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, 0));
			Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor,filtroBorrado);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, 1))){
			Filter filtroUsuario= genericDao.createFilter(FilterType.EQUALS,"username", exc.dameCelda(fila, 1));
			Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			usuario = genericDao.get(Usuario.class,filtroUsuario,filtroBorrado);
		}
		if(!Checks.esNulo(exc.dameCelda(fila, 5))) {
			dtoMediador = new DtoHistoricoMediador();
			dtoMediador.setCodigo(exc.dameCelda(fila, 5));
			
			if(!Checks.esNulo(activo)) {
				dtoMediador.setIdActivo(activo.getId());
				
				activoApi.createHistoricoMediador(dtoMediador);
			}
			
			if(!Checks.esNulo(agrupacion)) {
				List<ActivoAgrupacionActivo> aga = agrupacion.getActivos();
				
				for(ActivoAgrupacionActivo act: aga) {
					dtoMediador.setIdActivo(act.getActivo().getId());
					
					activoApi.createHistoricoMediador(dtoMediador);
				}
			}
		}
		
		if(!Checks.esNulo(tipoGestor) && !Checks.esNulo(usuario)){
			if(!Checks.esNulo(activo)){
				GestorEntidadDto dto = new GestorEntidadDto();
				dto.setIdEntidad(activo.getId());
				dto.setIdUsuario(usuario.getId());
				dto.setIdTipoGestor(tipoGestor.getId());
				activoAdapter.insertarGestorAdicional(dto);
			}
			else if(!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getTipoAgrupacion()) && 
						DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo()) &&
						tipoGestor.getCodigo().equals(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL)){
				
					ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;
					agrupacionTemp.setUsuarioGestorComercial(usuario);
					activoAgrupacionApi.saveOrUpdate(agrupacionTemp);
			}
			else if(!Checks.esNulo(expediente)){
				GestorEntidadDto dto = new GestorEntidadDto();
				dto.setIdEntidad(expediente.getId());
				dto.setIdUsuario(usuario.getId());
				dto.setIdTipoGestor(tipoGestor.getId());
				expedienteComercialApi.insertarGestorAdicional(dto);
			}
			else{
				throw new ParseException("Error al procesar la fila " + fila,1);
			}
		}
		return new ResultadoProcesarFila();
	}

}
