package es.pfsgroup.plugin.rem.albaran;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.albaran.dao.AlbaranDao;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.api.AlbaranApi;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VbusquedaProveedoresCombo;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Service("albaranManager")
public class AlbaranManager extends BusinessOperationOverrider<AlbaranApi> implements AlbaranApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private AlbaranDao albaranDao;
	
	@Autowired
	private GenericAdapter adapter;

	@Override
	public String managerName() {
		return "albaranManager";
	}

	public Page findAll(DtoAlbaranFiltro dto) {
		Page page = albaranDao.getAlbaranes(dto);
		return page;
	}

	public Page findAllDetalle(DtoDetalleAlbaran detalleAlbaran) {
		return albaranDao.getPrefacturas(detalleAlbaran);
	}

	public Page findPrefectura(DtoDetallePrefactura dto) {
		return albaranDao.getTrabajos(dto);
	}
	
	@Override
	public List<VbusquedaProveedoresCombo> getProveedores() {
		
		List<VbusquedaProveedoresCombo> comboApiPrimario = albaranDao.getProveedores();
		
		return comboApiPrimario;
	}

	@Transactional
	public Boolean validarAlbaran(Long id) {
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", id));
		if(alb.getEstadoAlbaran() != null && alb.getEstadoAlbaran().getCodigo() != null ) {
			DDEstadoAlbaran estadoAlb = genericDao.get(DDEstadoAlbaran.class,
					genericDao.createFilter(FilterType.EQUALS, "descripcion", DDEstadoAlbaran.DESCRIPCION_VALIDADO));
			alb.setEstadoAlbaran(estadoAlb);
			genericDao.update(Albaran.class, alb);
			List<Prefactura> prefacturasList = genericDao.getList(Prefactura.class, genericDao.createFilter(FilterType.EQUALS, "albaran.numAlbaran", id));
			for(Prefactura pref : prefacturasList) {
				DDEstEstadoPrefactura estadoPrefactura = genericDao.get(DDEstEstadoPrefactura.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstEstadoPrefactura.CODIGO_VALIDA));
				pref.setEstadoPrefactura(estadoPrefactura);
				genericDao.update(Prefactura.class, pref);
			}
		}else {
			return false;
		}
		return true;
	}
	
	@Transactional
	public Boolean validarPrefactura(Long id, String[] listaString) {
		//List<DtoDetallePrefactura> lista = obtenerDtoDeString(listaString);
		Prefactura prefactura = genericDao.get(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "numPrefactura", id));
		
		if(prefactura.getEstadoPrefactura() != null && prefactura.getEstadoPrefactura().getCodigo() != null ) {
			if(listaString != null && listaString.length > 0) {
				for(int i = 0; i < listaString.length; i++) {
					Long numTrabajo = Long.valueOf(listaString[i]);
					Trabajo tbj = genericDao.get(Trabajo.class,
							genericDao.createFilter(FilterType.EQUALS, "numTrabajo", numTrabajo));
					if(tbj != null) {
						tbj.setPrefactura(null);
						genericDao.save(Trabajo.class, tbj);
					}
				}
			}
			DDEstEstadoPrefactura estadoPrefactura = genericDao.get(DDEstEstadoPrefactura.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstEstadoPrefactura.CODIGO_VALIDA));
			prefactura.setEstadoPrefactura(estadoPrefactura);
			genericDao.save(Prefactura.class, prefactura);
			
		}else {
			return false;
		}
		return true;
	}
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran(){
		List<DDEstadoAlbaran> lista =  albaranDao.getComboEstadoAlbaran();
		return lista;
	}
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura(){
		List<DDEstEstadoPrefactura> lista =  albaranDao.getComboEstadoPrefactura();
		return lista;
	}
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo(){
		List<DDEstadoTrabajo> lista = albaranDao.getComboEstadoTrabajo();
		return lista;
	}
	
	private List<DtoDetallePrefactura> obtenerDtoDeString(String listaString){
		List<DtoDetallePrefactura> lista = new ArrayList<DtoDetallePrefactura>();
		
		String l1 = listaString.replace("[","");
		String[] l2 = l1.split("\\{");
		for(int i = 0; i< l2.length; i++) {
			if(!l2[i].isEmpty()) {
				DtoDetallePrefactura dto = new DtoDetallePrefactura();
				String l3 = "";
				l3 = l2[i].replaceAll("[^\\.\\,A-Za-z0-9:-]", "");
				String[] sep = l3.split("\\,") ;
				for (String campo : sep) {
					if(campo.contains("numTrabajo")) {
						String valor[] = campo.split(":");
						dto.setNumTrabajo(Long.parseLong(valor[1]));
					}
					if(campo.contains("checkIncluirTrabajo")) {
						String valor[] = campo.split(":");
						//Se niega por un tema del front que llegan los valores invertidos
						Boolean check = Boolean.valueOf(valor[1]);
						dto.setCheckIncluirTrabajo(!check);
					}
				}
				lista.add(dto);
			}
		}
		
		return lista;
	}
	
	@Override
	public Page obtenerDatosExportarTrabajosPrefactura(DtoAlbaranFiltro dto) throws ParseException {
		return albaranDao.getTrabajosPrefacturas(dto);
	}
	
	@Override
	public Boolean getEsUsuarioCliente() {
		Usuario usuariologado = adapter.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS,"usuario.id" , usuariologado.getId()));
		return usuarioCartera != null;
	}
}
