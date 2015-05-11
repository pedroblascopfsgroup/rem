<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:page>

var cargaTab = function(title, flow) {
	return function() {
		//app.fireEvent('opentab', {title:titulo, flow:url});
		app.openTab(title, flow);
	}
};

var tabListener = function(title, flow){
	return {
		click : function(){ app.openTab(title, flow); } 
	};
};

Ext.onReady(function() {
	
	var tree_children = [
	{
		text : 'Usuarios'
		,children : [
			{
				text : 'listado'
				,leaf : true
				,listeners :{click: function(){ app.openTab("Listado", "admin/listadoUsuarios"); } }
				
			}
			,{
				text : 'listado editable'
				,leaf : true
				,listeners :tabListener("Listado", "admin/editarUsuarios")
				
			}
			,{
				text : 'listado con 2 flows'
					,leaf : true
					,listeners :tabListener("Listado", "admin/usuarios")
					
			}
			,{
				text : 'listado clientes'
				,leaf : true
				,listeners :tabListener("<s:message code="menu.clientes" text="**Clientes"/>", "clientes/listadoClientes")
				
			}
		]
	},
	{
		text : '<s:message code="admin.tree.clientes" text="**Clientes" />'
		,children : [
		{
				text : '<s:message code="admin.tree.clientes.consulta" text="**Consulta" />'
				,leaf : true
				,listeners :tabListener('<s:message code="menu.clientes" text="**Clientes"/>', 'clientes/listadoClientes')
				
		}]
	},
	{
		text : '<s:message code="admin.tree.stats" text="Estadísticas" />',
		children : [
		{
			text : 'Acceso a operaciones'
			,leaf : true
			,listeners : tabListener("Listado", "admin/listadoUsuarios")
		},{
			text : 'Tiempos'
			,leaf : true
		}
		,{
			text : 'carga grid'
			,leaf : true
		}
		]
	}
	
	
	];
	
	var tree = new Ext.tree.TreePanel({
		//el : 'admin_tree',
		id : 'admin_tree',
		animate : true,
		/* height : 200, */
		autoHeight : true,
		border : false,
		autoScroll : true,
		loader : new Ext.tree.TreeLoader(),
		containerScroll : true
	

	});

	Ext.log("page="+page+" uuid="+page.getUUID());

	var root = new Ext.tree.AsyncTreeNode({
		leaf : false,
		loaded : true,
		expanded : true,
		text : 'Administraci&oacute;n',
		children : tree_children
	})

	tree.setRootNode(root);
	page.add(tree);

	tree.render();
	root.expand();
	
	
});
</fwk:page>