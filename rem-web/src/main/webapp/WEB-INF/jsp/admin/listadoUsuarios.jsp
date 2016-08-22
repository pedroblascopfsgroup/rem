<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

var Usuario = Ext.data.Record.create([
	{name : 'nombre'}
	,{name : 'email'}
	,{name : 'password'}
	,{name : 'username'}
	,{name : 'apellido1'}
	,{name : 'apellido2'}
]);

//utilizamos implicitamente el mismo flow que ha cargado el grid, si no, le pasaríamos flow : 'admin/listadoUsuarios'
var usersStore = page.getStore({
	eventName : 'getData'
	,reader: new Ext.data.JsonReader({
    	root : 'users'
    	,totalProperty : 'total'
    }, Usuario)
});


var filtro = new Ext.form.TextField({
	enableKeyEvents : true
	,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					usersStore.webflow({start:0, criterio : filtro.getValue()});
  					}
  				}
	}
});


usersStore.webflow();

var campo = new Ext.Toolbar.MenuButton({
	text : 'campo'
	,tooltip : 'Campo por el que filtrar'
	,menu : {items:[
		new Ext.menu.CheckItem({text : 'Nombre', value : 'nombre', checked : true})
		,new Ext.menu.CheckItem({text : 'Apellidos', value : 'apellido1', checked : false})
		,new Ext.menu.CheckItem({text : 'Login', value : 'username', checked : false})
		]
	}
});


var buscar = new Ext.Button({
	text : 'buscar'
	,handler : function(){
		usersStore.webflow({start:0, criterio : filtro.getValue()});
	}
});


var toggle = new Ext.Button({
	text : 'toggle'
	,handler : function(){
		filtro.disabled? filtro.enable() : filtro.disable();
	}
});



var sm = new Ext.grid.CheckboxSelectionModel();
var grid = new Ext.grid.EditorGridPanel({
	title : 'Usuarios'
	,cm : new Ext.grid.ColumnModel([sm,
		{header : 'Login', dataIndex : 'username' }
		<sec:authorize ifAllGranted="ROLE_ADMIN">
		,{header : 'Password', dataIndex : 'password'}
		</sec:authorize>
		,{header : 'Nombre', dataIndex : 'nombre', editor : new Ext.form.TextField({
			allowBlank : false
			})}
		,{header : 'Apellido1', dataIndex : 'apellido1', editor : new Ext.form.TextField({
			allowBlank : false
			})}
		,{header : 'Apellido2', dataIndex : 'apellido2'}
	])
	,store: usersStore
	,autoHeight : true
	,viewConfig : {
		autoFill : true
		,forceFit : true
	}
	,tbar :[
		campo
		,filtro
		,buscar
		,'-'
		,toggle
		
	]
	,selModel: sm
	,clicksToEdit:1
	,bbar : [  fwk.ux.getPaging(usersStore)  ]
});

//añadimos al padre y hacemos el layout
page.add(grid);
	
</fwk:page>