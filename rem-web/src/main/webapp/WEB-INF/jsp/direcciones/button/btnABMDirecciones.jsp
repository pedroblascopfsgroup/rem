<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
	text:'<s:message code="plugin.lindorff.clientes.ABMDirecciones.boton" text="**Direcciones"/>', 
		iconCls:'icon_bienes',
		handler : function(){
			var nombre=data.cabecera.nombre+" "+data.cabecera.apellidos;
			app.openTab("<s:message code="plugin.lindorff.clientes.ABMDirecciones.menu" text="**Mantenimiento Direcciones: "/>"+nombre, 
			"direccion/abmDireccion",{idCliente:data.id},{id:'abmdireccion'+data.datosCliente.codClienteEntidad,iconCls : 'icon_bienes'})
		}
	})