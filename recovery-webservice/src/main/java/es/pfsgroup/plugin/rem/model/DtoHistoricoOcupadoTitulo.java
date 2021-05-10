package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

public class DtoHistoricoOcupadoTitulo extends WebDto {

	private static final long serialVersionUID = 1L;

	private Long id;
    private String ocupado;
    private String conTitulo;
    private Date fechaAlta;
    private String horaAlta;
    private String usuarioAlta;
    private String lugarModificacion;

    public Long getId () {
    return this.id ;
    }

    public void setId (Long id) {
    this.id = id;
    }

    public String getOcupado() {
        return this.ocupado;
    }

    public void setOcupado(String ocupado) {
        this.ocupado = ocupado;
    }

    public String getConTitulo() {
        return this.conTitulo;
    }

    public void setConTitulo(String conTitulo) {
        this.conTitulo = conTitulo;
    }

    public Date getFechaAlta() {
        return this.fechaAlta;
    }

    public void setFechaAlta(Date fechaAlta) {
        this.fechaAlta = fechaAlta;
    }

    public String getHoraAlta() {
        return this.horaAlta;
    }

    public void setHoraAlta(String horaAlta) {
        this.horaAlta = horaAlta;
    }

    public String getUsuarioAlta() {
        return this.usuarioAlta;
    }

    public void setUsuarioAlta(String usuarioAlta) {
        this.usuarioAlta = usuarioAlta;
    }

    public String getLugarModificacion() {
        return this.lugarModificacion;
    }

    public void setLugarModificacion(String lugarModificacion) {
        this.lugarModificacion = lugarModificacion;
    }

}