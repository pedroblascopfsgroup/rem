<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
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
	flow : 'admin/usuariosData'
	,reader: new Ext.data.JsonReader({
    	root : 'users'
    	,totalProperty : 'total'
    }, Usuario)
});

gt=usersStore;

var filtro = new Ext.form.TextField({
	enableKeyEvents : true
	,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					usersStore.webflow({start:0, criterio : filtro.getValue()});
  					}
  				}
	}
	,allowBlank : false
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
		,{header : 'Password', dataIndex : 'password'}
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


var txtBuscar =new Ext.form.TextField({
	name : 'criterio'
	,fieldLabel : 'Nombre'
		,allowBlank : false
});

var btnBuscar= new Ext.Button({
	text : 'buscar'
	/*,handler : function(){
		//usersStore.webflow({start:0, criterio : filtro.getValue()});
		if (formBuscar.isValid()){
			var params = formBuscar.getForm().getValues();
			params.start = 0;
			usersStore.webflow(params);
		}
	}*/
});

var formBuscar = new Ext.form.FormPanel({
	items : [
	         txtBuscar
	         ,btnBuscar
	         ]
	,autoHeight : true
	,bodyStyle : 'padding:10px'
});

btnBuscar.on('click', function(){
	Ext.log("click");
	Ext.log(formBuscar.isValid());
		//usersStore.webflow({start:0, criterio : filtro.getValue()});
		if (formBuscar.isValid()){
			var params = formBuscar.getForm().getValues();
			params.start = 0;
			usersStore.webflow(params);
		}
	});


var form = new Ext.Panel({
	items : [
	         formBuscar
	         ,grid
	         ]
	,autoHeight : true
});


//añadimos al padre y hacemos el layout
page.add(form);
	
</fwk:page>